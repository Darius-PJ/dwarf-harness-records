package main

import (
	"context"
	"crypto/sha256"
	"encoding/json"
	"errors"
	"fmt"
	"io"
	"os"
	"path/filepath"
	"reflect"
	"uuid"

	"github.com/Darius-PJ/dwarf-harness/contract/ledger"
	"github.com/Darius-PJ/dwarf-harness/internal/core/agents"
	"github.com/Darius-PJ/dwarf-harness/internal/core/ledgerstore"
)

func main() {
	if err := run(); err != nil {
		fmt.Fprintln(os.Stderr, err)
		os.Exit(1)
	}
}

func id(n int) uuid.UUID {
	return uuid.MustParse(fmt.Sprintf("019a1393-0000-7000-8000-%012x", n))
}

// This is a disposable public-owner-Service CLI, not an in-package test or a
// benchmark. Its opaque identities require no provider, credential or network.
func run() (err error) {
	ctx := context.Background()
	root, err := os.MkdirTemp("", "t139-service-smoke-")
	if err != nil {
		return err
	}
	defer func() { err = errors.Join(err, os.RemoveAll(root)) }()
	resolvedRoot, err := filepath.EvalSymlinks(root)
	if err != nil {
		return err
	}
	root = resolvedRoot
	store, err := ledgerstore.Create(root, ledger.Defined())
	if err != nil {
		return err
	}
	var service *agents.Service
	defer func() {
		if service != nil {
			err = errors.Join(err, service.Close())
		}
		if store != nil {
			err = errors.Join(err, store.Close())
		}
	}()
	var report agents.Reconciliation
	service, report, err = agents.Open(ctx, store, root, agents.DefaultLimits())
	if err != nil || len(report.Issues) != 0 {
		return fmt.Errorf("open empty colony: report=%+v: %w", report, err)
	}
	bindings := []agents.Binding{{AgentID: id(0x100), ContextID: id(0x102)}, {AgentID: id(0x200), ContextID: id(0x202)}}
	for i, binding := range bindings {
		_, err := service.RegisterAgent(ctx, agents.AgentRegistration{CommandID: id(1 + i), AgentID: binding.AgentID, SessionID: id(0x101 + i*0x100), ContextID: binding.ContextID, Directory: fmt.Sprintf("Smoke-%d", i), AgentMarkdown: []byte("# Synthetic smoke instructions\n")})
		if err != nil {
			return fmt.Errorf("register agent: %w", err)
		}
	}
	owner := bindings[0]
	work := agents.Binding{AgentID: owner.AgentID, ContextID: id(0x110)}
	if _, err := service.CreateContext(ctx, agents.ContextCreation{Binding: work, CommandID: id(3), Kind: "work"}); err != nil {
		return fmt.Errorf("create work context: %w", err)
	}
	taskID := id(0x300)
	if _, err := service.CreateTask(ctx, owner, agents.TaskCreation{CommandID: id(4), TaskID: taskID, Description: []byte("Synthetic registration smoke task.\n"), AcceptanceSHA256: ledger.Digest(sha256.Sum256([]byte("synthetic acceptance"))), Audience: []uuid.UUID{bindings[0].AgentID, bindings[1].AgentID}}); err != nil {
		return fmt.Errorf("create task: %w", err)
	}
	audience := []uuid.UUID{bindings[0].AgentID, bindings[1].AgentID}
	resource := agents.ResourceRegistration{CommandID: id(5), ResourceID: id(0x400), Resource: ledger.Resource{Kind: "external", ResourceKey: "paid-route/" + id(0x450).String()}, Audience: audience}
	domain := agents.WorkDomainRegistration{CommandID: id(6), WorkDomainID: id(0x401), Audience: audience}
	resourceReceipt, err := service.SetResourceRegistration(ctx, owner, resource)
	if err != nil {
		return fmt.Errorf("create resource: %w", err)
	}
	domainReceipt, err := service.SetWorkDomainRegistration(ctx, owner, domain)
	if err != nil {
		return fmt.Errorf("create domain: %w", err)
	}
	resourceV1, err := service.ResourceStatus(ctx, agents.ResourceRegistrationLookup{Resource: resource.Resource, ThroughSequence: resourceReceipt.Sequence})
	if err != nil || !reflect.DeepEqual(resourceV1.Record, ledger.RuntimeResourceRegistered{ResourceID: resource.ResourceID, Version: 1, Resource: resource.Resource, Audience: audience}) {
		return fmt.Errorf("resource version one: %+v: %w", resourceV1, err)
	}
	domainV1, err := service.WorkDomainStatus(ctx, agents.RegistrationLookup{ID: domain.WorkDomainID, ThroughSequence: domainReceipt.Sequence})
	if err != nil || !reflect.DeepEqual(domainV1.Record, ledger.RuntimeWorkDomainRegistered{WorkDomainID: domain.WorkDomainID, Version: 1, Audience: audience}) {
		return fmt.Errorf("domain version one: %+v: %w", domainV1, err)
	}
	taskConsumer := ledger.DeclarationConsumer{Kind: "task", TaskID: taskID}
	workConsumer := ledger.DeclarationConsumer{Kind: "context", Binding: ledger.Binding(work)}
	generalConsumer := ledger.DeclarationConsumer{Kind: "context", Binding: ledger.Binding(bindings[1])}
	declarations := []agents.DeclarationChange{
		{CommandID: id(7), DeclarationID: id(0x500), Subject: ledger.RegistrationRef{Kind: "resource", ID: resource.ResourceID, Version: 1}, Audience: audience, Consumers: []ledger.DeclarationConsumer{taskConsumer}},
		{CommandID: id(8), DeclarationID: id(0x501), Subject: ledger.RegistrationRef{Kind: "resource", ID: resource.ResourceID, Version: 1}, Audience: audience, Consumers: []ledger.DeclarationConsumer{workConsumer}},
		{CommandID: id(9), DeclarationID: id(0x502), Subject: ledger.RegistrationRef{Kind: "work_domain", ID: domain.WorkDomainID, Version: 1}, Audience: audience, Consumers: []ledger.DeclarationConsumer{taskConsumer}},
		{CommandID: id(10), DeclarationID: id(0x503), Subject: ledger.RegistrationRef{Kind: "work_domain", ID: domain.WorkDomainID, Version: 1}, Audience: audience, Consumers: []ledger.DeclarationConsumer{generalConsumer}},
	}
	var originals []agents.DeclarationView
	var declarationReceipts []agents.RegistrationReceipt
	allReceipts := []agents.RegistrationReceipt{resourceReceipt, domainReceipt}
	for _, request := range declarations {
		receipt, err := service.SetDeclaration(ctx, owner, request)
		if err != nil {
			return fmt.Errorf("create declaration %s: %w", request.DeclarationID, err)
		}
		view, err := service.DeclarationStatus(ctx, agents.RegistrationLookup{ID: request.DeclarationID, ThroughSequence: receipt.Sequence})
		want := ledger.RuntimeDeclarationChanged{DeclarationID: request.DeclarationID, Version: 1, Subject: request.Subject, Audience: request.Audience, Consumers: request.Consumers}
		if err != nil || !reflect.DeepEqual(view.Record, want) || view.ReceiptSequence != receipt.Sequence {
			return fmt.Errorf("declaration version one: %+v want %+v: %w", view, want, err)
		}
		originals = append(originals, view)
		declarationReceipts = append(declarationReceipts, receipt)
		allReceipts = append(allReceipts, receipt)
	}

	revisedResource := resource
	revisedResource.CommandID, revisedResource.ExpectedVersion, revisedResource.Audience = id(11), 1, []uuid.UUID{owner.AgentID}
	r2, err := service.SetResourceRegistration(ctx, owner, revisedResource)
	if err != nil {
		return fmt.Errorf("revise resource: %w", err)
	}
	revisedDomain := domain
	revisedDomain.CommandID, revisedDomain.ExpectedVersion, revisedDomain.Audience = id(12), 1, []uuid.UUID{bindings[1].AgentID}
	d2, err := service.SetWorkDomainRegistration(ctx, owner, revisedDomain)
	if err != nil {
		return fmt.Errorf("revise domain: %w", err)
	}
	allReceipts = append(allReceipts, r2, d2)
	// Source revisions alone must not change any declaration's selected scope.
	for _, original := range originals {
		view, err := service.DeclarationStatus(ctx, agents.RegistrationLookup{ID: original.Record.DeclarationID, ThroughSequence: ledger.ToEnd})
		if err != nil || !reflect.DeepEqual(view.Record, original.Record) {
			return fmt.Errorf("source revision changed declaration pin: %+v: %w", view, err)
		}
	}
	wantedDeclarations := make([]ledger.RuntimeDeclarationChanged, len(originals))
	for i, original := range originals {
		wantedDeclarations[i] = original.Record
	}
	for _, i := range []int{0, 1, 3} {
		request := declarations[i]
		request.CommandID, request.ExpectedVersion, request.Subject.Version = id(13+i), 1, 2
		request.Audience, request.Consumers = []uuid.UUID{owner.AgentID}, []ledger.DeclarationConsumer{}
		if i == 0 {
			request.Consumers = []ledger.DeclarationConsumer{workConsumer, taskConsumer}
		}
		if i == 3 {
			request.Audience = []uuid.UUID{bindings[1].AgentID}
		}
		receipt, err := service.SetDeclaration(ctx, owner, request)
		if err != nil {
			return fmt.Errorf("revise/withdraw declaration %d: %w", i, err)
		}
		allReceipts = append(allReceipts, receipt)
		wantedDeclarations[i] = ledger.RuntimeDeclarationChanged{DeclarationID: request.DeclarationID, ExpectedVersion: 1, Version: 2, Subject: request.Subject, Audience: request.Audience, Consumers: request.Consumers}
	}
	checkViews := func() error {
		through := store.Durable()
		currentResource, err := service.ResourceStatus(ctx, agents.ResourceRegistrationLookup{Resource: resource.Resource, ThroughSequence: ledger.ToEnd})
		wantResource := ledger.RuntimeResourceRegistered{ResourceID: resource.ResourceID, ExpectedVersion: 1, Version: 2, Resource: resource.Resource, Audience: revisedResource.Audience}
		if err != nil || !reflect.DeepEqual(currentResource.Record, wantResource) || currentResource.ReceiptSequence != r2.Sequence || currentResource.ThroughSequence != through {
			return fmt.Errorf("current resource: %+v: %w", currentResource, err)
		}
		currentDomain, err := service.WorkDomainStatus(ctx, agents.RegistrationLookup{ID: domain.WorkDomainID, ThroughSequence: ledger.ToEnd})
		wantDomain := ledger.RuntimeWorkDomainRegistered{WorkDomainID: domain.WorkDomainID, ExpectedVersion: 1, Version: 2, Audience: revisedDomain.Audience}
		if err != nil || !reflect.DeepEqual(currentDomain.Record, wantDomain) || currentDomain.ReceiptSequence != d2.Sequence || currentDomain.ThroughSequence != through {
			return fmt.Errorf("current domain: %+v: %w", currentDomain, err)
		}
		oldResource, err := service.ResourceStatus(ctx, agents.ResourceRegistrationLookup{Resource: resource.Resource, ThroughSequence: resourceV1.ThroughSequence})
		if err != nil || !reflect.DeepEqual(oldResource, resourceV1) {
			return fmt.Errorf("historical resource: %+v: %w", oldResource, err)
		}
		oldDomain, err := service.WorkDomainStatus(ctx, agents.RegistrationLookup{ID: domain.WorkDomainID, ThroughSequence: domainV1.ThroughSequence})
		if err != nil || !reflect.DeepEqual(oldDomain, domainV1) {
			return fmt.Errorf("historical domain: %+v: %w", oldDomain, err)
		}
		for i, original := range originals {
			view, err := service.DeclarationStatus(ctx, agents.RegistrationLookup{ID: original.Record.DeclarationID, ThroughSequence: ledger.ToEnd})
			if err != nil || !reflect.DeepEqual(view.Record, wantedDeclarations[i]) || view.ThroughSequence != through {
				return fmt.Errorf("current declaration %d: %+v: %w", i, view, err)
			}
			old, err := service.DeclarationStatus(ctx, agents.RegistrationLookup{ID: original.Record.DeclarationID, ThroughSequence: original.ThroughSequence})
			if err != nil || !reflect.DeepEqual(old, original) {
				return fmt.Errorf("historical declaration %d: %+v: %w", i, old, err)
			}
			// Resolve both current and historical pins, not just today's source.
			for _, ref := range []ledger.RegistrationRef{view.Record.Subject, original.Record.Subject} {
				evidence, err := service.RegistrationVersion(ctx, agents.RegistrationVersionLookup{Ref: ref, ThroughSequence: ledger.ToEnd})
				if err != nil {
					return fmt.Errorf("pinned source %v: %w", ref, err)
				}
				if ref.Kind == "resource" {
					want := currentResource
					if ref.Version == 1 {
						want = resourceV1
						want.ThroughSequence = through
					}
					if evidence.Resource == nil || evidence.WorkDomain != nil || !reflect.DeepEqual(*evidence.Resource, want) {
						return fmt.Errorf("wrong resource pin: %+v want %+v", evidence, want)
					}
				} else {
					want := currentDomain
					if ref.Version == 1 {
						want = domainV1
						want.ThroughSequence = through
					}
					if evidence.WorkDomain == nil || evidence.Resource != nil || !reflect.DeepEqual(*evidence.WorkDomain, want) {
						return fmt.Errorf("wrong domain pin: %+v want %+v", evidence, want)
					}
				}
			}
		}
		return nil
	}
	if err := checkViews(); err != nil {
		return err
	}
	if err := checkReceipts(ctx, service, store, allReceipts); err != nil {
		return err
	}
	before := store.Durable()
	beforeLog, err := logBytes(store.LogDir())
	if err != nil {
		return err
	}
	if err := service.Close(); err != nil {
		return err
	}
	service = nil
	if err := store.Close(); err != nil {
		return err
	}
	store = nil
	var repair ledgerstore.Recovery
	store, repair, err = ledgerstore.Open(root, ledger.Defined())
	if err != nil {
		return err
	}
	reopenLimits := agents.DefaultLimits()
	reopenLimits.MaxRegistrations, reopenLimits.MaxDeclarations = 1, 1
	service, report, err = agents.Open(ctx, store, root, reopenLimits)
	if err != nil || len(report.Issues) != 0 || repair.TruncatedBytes != 0 || store.Durable() != before {
		return fmt.Errorf("reopen changed complete history: durable=%d want=%d repair=%+v report=%+v: %w", store.Durable(), before, repair, report, err)
	}
	if err := checkViews(); err != nil {
		return err
	}
	again, err := service.SetResourceRegistration(ctx, owner, resource)
	if err != nil || !reflect.DeepEqual(again, resourceReceipt) {
		return fmt.Errorf("original resource retry: %+v: %w", again, err)
	}
	again, err = service.SetWorkDomainRegistration(ctx, owner, domain)
	if err != nil || !reflect.DeepEqual(again, domainReceipt) {
		return fmt.Errorf("original domain retry: %+v: %w", again, err)
	}
	for i, request := range declarations {
		again, err = service.SetDeclaration(ctx, owner, request)
		if err != nil || !reflect.DeepEqual(again, declarationReceipts[i]) {
			return fmt.Errorf("original declaration retry %d: %+v: %w", i, again, err)
		}
	}
	if err := checkViews(); err != nil {
		return err
	}
	if err := checkReceipts(ctx, service, store, allReceipts); err != nil {
		return err
	}
	afterLog, err := logBytes(store.LogDir())
	if err != nil {
		return err
	}
	if store.Durable() != before || !reflect.DeepEqual(beforeLog, afterLog) {
		return fmt.Errorf("replay/query/original retry appended or rewrote history: durable=%d want=%d", store.Durable(), before)
	}
	digests := map[string]string{}
	for name, data := range afterLog {
		digests[name] = fmt.Sprintf("%x", sha256.Sum256(data))
	}
	after := store.Durable()
	if err := service.Close(); err != nil {
		return err
	}
	service = nil
	if err := store.Close(); err != nil {
		return err
	}
	store = nil
	if err := os.RemoveAll(root); err != nil {
		return err
	}
	return json.NewEncoder(os.Stdout).Encode(struct {
		Status               string
		DurableBefore        uint64
		DurableAfter         uint64
		RegistrationReceipts int
		OriginalRetries      int
		RepairedBytes        int64
		LedgerSHA256         map[string]string
		Exercised            []string
	}{
		Status: "passed", DurableBefore: before, DurableAfter: after, RegistrationReceipts: len(allReceipts), OriginalRetries: 2 + len(declarations), RepairedBytes: repair.TruncatedBytes, LedgerSHA256: digests,
		Exercised: []string{"public owner Service", "resource and work domain", "all four source/consumer combinations", "source revisions", "mixed replacement", "resource and domain withdrawals", "current and historical metadata", "exact current and historical pins", "close/reopen with both admission limits below retained populations", "actual committed original receipts", "matching retries with unchanged complete ledger"},
	})
}

func logBytes(dir string) (map[string][]byte, error) {
	entries, err := os.ReadDir(dir)
	if err != nil {
		return nil, err
	}
	out := map[string][]byte{}
	for _, entry := range entries {
		if entry.IsDir() {
			continue
		}
		data, err := os.ReadFile(filepath.Join(dir, entry.Name()))
		if err != nil {
			return nil, err
		}
		out[entry.Name()] = data
	}
	return out, nil
}

func checkReceipts(ctx context.Context, service *agents.Service, store *ledgerstore.Store, expected []agents.RegistrationReceipt) error {
	reader, err := ledger.OpenReader(store.LogDir(), ledger.ReadOptions{Colony: store.Colony(), Through: store.Durable(), AllTypes: true, Consume: ledger.Consumption{}})
	if err != nil {
		return err
	}
	defer reader.Close()
	actual := map[uuid.UUID]agents.RegistrationReceipt{}
	for {
		commit, err := reader.Next()
		if errors.Is(err, io.EOF) {
			break
		}
		if err != nil {
			return err
		}
		for _, record := range commit.Records {
			if record.Type != ledger.TypeRuntimeRegistrationReceipt {
				continue
			}
			receipt, err := ledger.DecodeRuntimeRegistrationReceipt(record.Payload)
			if err != nil {
				return err
			}
			if len(commit.Records) != 3 || commit.Records[0].Type != ledger.TypeCommand || record.Seq != commit.Last {
				return fmt.Errorf("receipt outside complete registration group: %s", receipt.CommandID)
			}
			if _, duplicate := actual[receipt.CommandID]; duplicate {
				return fmt.Errorf("duplicate committed effect for %s", receipt.CommandID)
			}
			actual[receipt.CommandID] = agents.RegistrationReceipt{RuntimeRegistrationReceipt: receipt, EffectSequence: commit.Records[1].Seq, Sequence: record.Seq}
		}
	}
	if len(actual) != len(expected) {
		return fmt.Errorf("registration receipt count: %d want %d", len(actual), len(expected))
	}
	for _, want := range expected {
		got, err := service.RegistrationCommandStatus(ctx, agents.RegistrationCommandLookup{CommandID: want.CommandID, SubmissionSHA256: want.SubmissionSHA256})
		if err != nil || !reflect.DeepEqual(got, want) || !reflect.DeepEqual(actual[want.CommandID], want) {
			return fmt.Errorf("actual original receipt mismatch: got=%+v stored=%+v want=%+v: %w", got, actual[want.CommandID], want, err)
		}
	}
	return nil
}
