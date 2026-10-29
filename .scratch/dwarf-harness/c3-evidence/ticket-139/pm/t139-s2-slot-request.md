# Ticket139 S2 CODE_READY — next-ready serial execution slot

Actual base34090c3b634b9854904671c336db91c350e6328c, own139-registration/build/139-registration. Fresh CoderT139S2 source complete; no builds/formatters/lint/tests/fuzz/measurement/provider execution. LSP diagnostics report no issues, not runtime proof. Complete original report: secondary local/t139-s2-code-ready.md. Exact runner/final-commands.txt is being retained at C:/Users/darius.jones/worktrees/dwarf-harness/t139-s2-evidence before execution.

## Actual owned paths
All under internal/core/agents/: registration_types.go, registration_commands.go, registration_replay.go, registration_state.go, registration_query.go, registration_service_test.go, registration_replay_test.go, registration_fuzz_test.go, service.go, types.go, scoped_replay.go, replay.go, doc.go, scoped_golden_test.go, integrity.go, paid_fixture_test.go, paid_fuzz_test.go, paid_live.go, paid_read.go, paid_settlement.go, paid_state.go, review_execute.go, review_fuzz_test.go, review_replay_test.go, review_state.go, scoped_submit.go, history_index.go.27paths; no dependencies/frozen files/old assertions/main/private-record writes.

The delegated history_index diff is exactly: cached decode receives ignored fifth result; putCommand immediately returns when match.registration !=nil. Nothing else in that file. Code-ready SHA256 from author's Get-FileHash:2cf636da336a1cecd4d5d65c81a97ddaaa8a022c52c9f3d3a075b796a8c6ac3e (pre-format, not final). Consumer test concurrent-retry proves normalized original receipt/no duplicate after intervening two-command F0 traffic, then changed normalized input conflicts. Include exact final guard diff/hash in final review/packet.

## Environment and serial sequence
Pinned Go/gofmt C:/Program Files/Go/bin, Go1.27.3; GOTOOLCHAIN=local, emptyGOFLAGS, GOROOT=C:/Program Files/Go, GOOS=windows, GOARCH=amd64, CGO_ENABLED=0 ordinarily. No local full gate, five-target static, benchmark/measurement/provider action or unrelated package rerun.

0. Capture module/old-fixture/source baselines; owned-only gofmt-w, then gofmt-l27paths (120s each).
1. Focused/seeds once: go test -v -count=1 -timeout=19m -run '^(TestRegistration.*|FuzzRegistrationGroupReplay|FuzzScopedGroupReplay|FuzzReviewGroupReplay|FuzzPaidGroupReplay|FuzzPrivateGroupReplay)$' ./internal/core/agents (tool1200s).
2. Three independently reachable risk-selected mutations below; each named target attempted red, exact byte/hash restore, same target green, with actual logs. Any masking/survival is reported, not counted as a red. No extra whole-package run per mutant.
3. One plain verbose changed package: go test -v -count=1 -timeout=19m ./internal/core/agents (1200s).
4. Host go vet ./internal/core/agents and go tool staticcheck ./internal/core/agents (600s each).
5. One whole-package race: go test -race -v -count=1 -timeout=29m ./internal/core/agents (1800s).
6. Only affected new concurrent rows ×20: go test -race -v -count=20 -timeout=45m -run '^(TestRegistrationVersionCAS|TestRegistrationCommitRetryAndClose)$/^(resource|work_domain|declaration|concurrent-retry|close-fence)$' ./internal/core/agents (2800s). No unchanged legacy HistoryIndexLookupRace repetitions.
7. Production/test go-list import audit, go mod tidy -diff, go mod verify; final module/old-fixture comparison, owned final format/hashes/command metadata. No codec regeneration because frozen codecs/goldens do not change.

Race steps only set CGO_ENABLED=1 and CC=C:/Users/darius.jones/AppData/Local/Programs/llvm-mingw-20260922-ucrt-x86_64/bin/x86_64-w64-mingw32-clang.exe. Outer runner must accommodate the serial sequence; child deadlines retain the stated margins. All failures retained; final hashes follow all restoration/final edits. No execution before explicit primary renewed ready-slot grant.

## Three actual guard mutations, PM selected
- Remove executeRegistration's initial non-owner refusal; named TestRegistrationAuthorityAndIdentity must observe forbidden admission.
- Remove original command-ID/digest/submission comparisons from preflightRegistration while keeping family/planner validation; TestRegistrationOriginalRequestPreflight uses a codec/state-valid self-consistent altered audience/digest and must observe publication instead of no append.
- Change only the post-Submit refreshLocked context.Background() to the caller ctx; target TestRegistrationCommitRetryAndClose/installed-lost-ack-and-cancel cancels after durable Submit and observes actual projection/receipt, lost acknowledgment and restart. A premature return is observed through its result channel, without a per-test timer. The proposed TestRegistrationInstalledBeforeAck is removed because corrupting authority to prevent query refresh pins I/O/error behavior; production validation is unchanged.

Each command is go test -v -count=1 -timeout=19m -run '<exact anchored test[/subtest]>' ./internal/core/agents, tool1200s; the third expression is '^TestRegistrationCommitRetryAndClose$/^installed-lost-ack-and-cancel$'. These are authority/original-request/postcommit-cancellation correctness risks, not arbitrary naming/default mutants.

## Subsequent PM fuzz requested in same grant
After final product code is committed and all27 hashes bind to its immutable SHA, request4serial campaigns,120s each,-parallel=1: FuzzRegistrationGroupReplay, FuzzScopedGroupReplay, FuzzReviewGroupReplay, FuzzPaidGroupReplay. New target accepts/reopens real stores for accepted groups; shared dispatch makes the three existing targets relevant. Private normal seeds only: no private decoder/planner change. Retain actual argv/env/exit/duration/executions/interesting/corpus/logs and hash agreement. Then release compute explicitly, not holding it for review/hosted CI. No grant carries to S3.

## Primary grant and narrow proof correction
Primary mailbox255–265 grants this finite serial sequence and subsequent four campaigns; no S3 grant. The narrow third-mutant correction above follows the primary's explicit warning against I/O-pinning tests. Final argv/runner will be read before launch. The accepted mode0 seed for each of resource/domain/declaration forces real ledgerstore.Submit→Core Open→typed current status/actual receipt assertions; the focused seed output must confirm those paths pass before claiming runtime reachability.
