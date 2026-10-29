package agents

import (
	"bytes"
	"context"
	"crypto/sha256"
	"errors"
	"fmt"
	"path/filepath"
	"reflect"
	"testing"
	"uuid"

	"github.com/Darius-PJ/dwarf-harness/contract/ledger"
	"github.com/Darius-PJ/dwarf-harness/internal/core/ledgerstore"
)

// This throwaway probe validates the earlier-family setup, not F3-139 replay.
func TestRegistrationFreezeSetupProbe(t *testing.T) {
	t.Parallel()
	id := func(n int) uuid.UUID {
		return uuid.MustParse(fmt.Sprintf("019a1390-0000-7000-8000-%012x", n))
	}
	t.Run("positive", func(t *testing.T) {
		t.Parallel()
		f, commits := scopedGoldenFixture(t, "139", -1)
		if len(commits) != 19 || commits[len(commits)-1].Last != 65 {
			t.Fatalf("fixture boundaries: commits=%d", len(commits))
		}
		path := filepath.Join(f.root, "log", ledger.SegmentName(1))
		beforeBytes := readTestFile(t, path)
		before := f.store.Durable()
		var report Reconciliation
		var err error
		f.service, report, err = Open(context.Background(), f.store, f.root, DefaultLimits())
		if err != nil || len(report.Issues) != 0 || before != 65 || f.store.Durable() != before {
			t.Fatalf("positive Open: report=%+v err=%v durable=%d/%d", report, err, before, f.store.Durable())
		}
		task, err := f.service.TaskStatus(context.Background(), TaskLookup{TaskID: id(0x300)})
		wantTask, decodeErr := ledger.DecodeRuntimeTaskChanged(commits[3].Records[2].Payload)
		if err != nil || decodeErr != nil || !reflect.DeepEqual(task.Task, wantTask) || task.Task.State != "waiting" || task.Task.Assignment != nil || task.Sequence != commits[3].Records[2].Seq || task.DescriptionRef.SHA256 != ledger.Digest(sha256.Sum256([]byte("Registered resource declaration fixture.\n"))) {
			t.Fatalf("earlier task not reconstructed: %+v %v decode=%v", task, err, decodeErr)
		}
		grant, err := f.service.GrantStatus(context.Background(), GrantLookup{GrantID: id(0x600)})
		wantGrant, decodeErr := ledger.DecodeRuntimeGrantIssued(commits[4].Records[1].Payload)
		if err != nil || decodeErr != nil || !grant.Current || grant.Revoked || !reflect.DeepEqual(grant.Grant, wantGrant) || grant.Grant.Resources[0].ResourceKey != "paid-route/"+id(0x450).String() {
			t.Fatalf("earlier grant not reconstructed: %+v %v decode=%v", grant, err, decodeErr)
		}
		afterBytes := readTestFile(t, path)
		if !bytes.Equal(beforeBytes, afterBytes) || f.store.Durable() != before {
			t.Fatal("Open or metadata queries changed the ledger")
		}
		t.Logf("positive Open=success issues=%d completed=%d durable_before=%d durable_after=%d ledger_before_sha256=%x ledger_after_sha256=%x task_sequence=%d task_version=%d grant_authority_version=%d", len(report.Issues), len(report.Completed), before, f.store.Durable(), sha256.Sum256(beforeBytes), sha256.Sum256(afterBytes), task.Sequence, task.Task.Version, grant.Grant.AuthorityVersion)
	})
	t.Run("missing_dependency_negative", func(t *testing.T) {
		t.Parallel()
		f, commits := scopedGoldenFixture(t, "139", -1)
		if err := f.store.Close(); err != nil {
			t.Fatal(err)
		}
		f.store = nil
		var rebuilt bytes.Buffer
		chain := ledger.Genesis()
		for index, commit := range commits {
			drafts := scopedGoldenDrafts(commit)
			if index == 3 {
				task, err := ledger.DecodeRuntimeTaskChanged(drafts[2].Payload)
				if err != nil {
					t.Fatal(err)
				}
				task.Dependencies = []uuid.UUID{id(0x999)}
				drafts[2].Payload = testPayload(t, task)
				receipt, err := ledger.DecodeRuntimeScopedReceipt(drafts[3].Payload)
				if err != nil {
					t.Fatal(err)
				}
				arguments := receipt.Submission.Arguments.(ledger.TaskCreateArguments)
				arguments.Dependencies = task.Dependencies
				receipt.Submission.Arguments = arguments
				receipt.SubmissionSHA256 = ledger.Digest(sha256.Sum256(testPayload(t, receipt.Submission)))
				drafts[3].Payload = testPayload(t, receipt)
				drafts[0].Payload = testPayload(t, ledger.Command{CommandID: receipt.CommandID, SubmissionSHA256: receipt.SubmissionSHA256})
			}
			first := commit.Records[0]
			data, next, err := ledger.EncodeCommit(chain, ledger.CommitHeader{ColonyID: first.ColonyID, CommitID: first.CommitID, EventTimeNS: first.EventTimeNS, ClockHeld: first.ClockHeld}, drafts)
			if err != nil {
				t.Fatal(err)
			}
			rebuilt.Write(data)
			chain = next
		}
		path := filepath.Join(f.root, "log", ledger.SegmentName(1))
		writeTestFile(t, path, rebuilt.Bytes())
		var err error
		f.store, _, err = ledgerstore.Open(f.root, ledger.Defined())
		if err != nil || f.store.Durable() != 65 {
			t.Fatalf("rebuilt negative log must be structurally valid: %v", err)
		}
		before := f.store.Durable()
		var report Reconciliation
		f.service, report, err = Open(context.Background(), f.store, f.root, DefaultLimits())
		if !errors.Is(err, ErrInconsistent) || f.service != nil {
			t.Fatalf("missing earlier dependency was not rejected by actual Core: service=%v report=%+v err=%v", f.service, report, err)
		}
		if f.store.Durable() != before || !bytes.Equal(readTestFile(t, path), rebuilt.Bytes()) {
			t.Fatal("negative Open changed the rebuilt ledger")
		}
		t.Logf("negative ledgerstore.Open=success agents.Open=ErrInconsistent durable_before=%d durable_after=%d rebuilt_sha256=%x error=%v", before, f.store.Durable(), sha256.Sum256(rebuilt.Bytes()), err)
	})
}
