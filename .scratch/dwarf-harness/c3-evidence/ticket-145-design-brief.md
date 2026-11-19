# Ticket 145 — one-shot paid transport fault-test repair

## Owner summary
The reproduced failure is an early HTTP response on the original connection, not a second paid send: a truncated request line receives the loopback server's 400 while TLS is closing. The faulted-response drain can race the same close. Core correctly keeps money held without final billing evidence. Recommend a test-only raw-socket-close repair preserving all ten existing rows' error outcomes/counts, with a deliberately graceful control and deterministic regression. Product transport and paid records stay unchanged. This proposal needs a fresh advisor ruling. Sources: A:5–10,18–25; N:32–43; R13:21–26; §0.

## Sources and authority
- **A** = `local://t145-design-assignment.md`; **N** = `local://t145-docs-notes.md`; **T** = ticket 145 text in E1 of `local://t145-publish-edits.md:64–132` until publication, then `.scratch/dwarf-harness/issues/145-explain-and-fix-the-one-shot-paid-transport-test-that-sees-a-faulted-request-succeed.md` (same text). T citations use the publication-edit line numbers, not implied published-ticket line numbers.
- **R13** = `.scratch/dwarf-harness/c3-evidence/ticket-13-design-ruling.md` (wins over its brief); **BR13** = the adjacent `ticket-13-design-brief.md`.
- Repository-relative source lines are the assignment's code base `e3fc732133d8e6d5410f9aefab7f8aceff4f2fef`; the following publication is Markdown-only (A:14–17). **GO** = `C:/Program Files/Go/src/` on the pinned go1.27.3. Go citations below use `GO/<relative path>:line`.
- Private probe provenance and machine paths remain private; public code/comments/close text describe only the mechanism, hosted runs and invariant (A:24–26; `docs/CURRENT-RULES.md:25–30`). No command or test has been run by this designer.
- Bare transport_test.go, transport.go, response.go, openai_response.go and doc.go citations mean `internal/core/providers/`; bare paid_*.go citations mean `internal/core/agents/`. `providers/doc.go` is also shorthand for `internal/core/providers/doc.go`. Colon-only ranges continue the immediately named file.

## §0 — As built: client, server, outcome and money

### 0.1 One send, concurrent read/write, and TLS close
`Envelope.request` supplies a custom `requestBody`, positive `ContentLength`, POST and sealed headers plus authentication; it never installs `GetBody` (`internal/core/providers/transport.go:90–143`). Its dedicated pool enables HTTP/1 only and disables proxy, compression, HTTP/2 and redirects (`:70–87`; `doc.go:19–29`). On the pinned toolchain the HTTP/2 retry branch is unreachable; a reused-connection nothing-written error needs zero outgoing length or `GetBody`, and other retryable failures need `isReplayable`. A positive non-rewindable POST fails both tests. Even an idempotency header alone cannot make this body replayable: the header is considered only inside the body/no-body/GetBody guard (`GO/net/http/transport.go:844–889`; `GO/net/http/request.go:1561–1587`). Thus the current profile has no applicable resend path. This confirms R13:21, with the body's guard stated precisely.

The custom body is not a known in-memory reader: Go sets `FlushHeaders`, flushes headers before copying the body, and later flushes body bytes (`GO/net/http/transfer.go:89–110,1153–1172`; `GO/net/http/request.go:764–783`; `GO/net/http/transport.go:2830–2866`). This explains three wrapped writes in the probe: two for the completed warm exchange, then the faulted second request's header write. It also means the existing `partial_body` row sends a complete header block but, ordinarily, zero body bytes; its label does not imply a body byte was actually sent (`internal/core/providers/transport_test.go:47–58`).

Go reads the answer concurrently with writing the request. A response received on `resc` is returned without requiring write success; the `pcClosed` branch checks a racing response first. A write-error branch can instead win and return an error (`GO/net/http/transport.go:3053–3140`). `writeLoop` publishes its error and closes the connection, while `mapRoundTripError` waits for that loop before returning a failure (`:2830–2866,2362–2410`). `readLoop` can publish response headers before body completion, so obtaining a response does not guarantee that draining it succeeds (`:2454–2544,2590–2646`).

The fixture wraps the **TLS connection**, not raw TCP. `faultConn.Write` first returns from its short TLS write, then calls that TLS connection's `Close` (`internal/core/providers/transport_test.go:21–64,152–161`). Since its TLS `Write` has returned, `tls.Conn.Close` normally sends close_notify before closing the underlying socket; receiving close_notify produces EOF. Its concurrent-write exception instead closes raw directly, but that exception is not the ordinary sequence here (`GO/crypto/tls/conn.go:720–721,1422–1454,1470–1483`). The peer can therefore observe EOF and answer during the interval between close_notify and the local raw close. This is the missing distinction between a failed request write, a returned HTTP answer, and a second send.

### 0.2 Each current fault row (counts include the warm exchange)
The warm exchange and all fault rows use real verified TLS with h2 offered, a reused-connection trace, and an armed one-write fault (`internal/core/providers/transport_test.go:106–188`). `requests` counts handler entries, not malformed request-line bytes; `complete` counts successful full body reads (`:118–144`). The final-state observer must remain: client completion alone is not server consumption (`:89–104`; `.scratch/dwarf-harness/c3-evidence/ticket-13-evidence.md:28,33–34`).

| Mode | Client path | Server path / answer possible before raw close | Expected total dials / requests / complete |
|---|---|---|---|
| `zero_write` | Close TLS without forwarding request bytes; return `(0, io.ErrClosedPipe)` (`transport_test.go:37–39`). | EOF before any new request line is a common network read error, so `conn.serve` sends no reply (`GO/net/http/server.go:2075–2121`). No new response is expected. | `1 / 1 / 1` (`transport_test.go:194–212`). |
| `read_eof` | Mode falls through to ordinary writes; the attempt is sent in full (`:30–35,62–64`). | Second handler reads the whole body, increments complete, hijacks and closes without any response (`:118–140`). Hijack is the terminal observer event. No HTTP response is produced by the framework after hijack (`GO/net/http/server.go:2153–2169`). | `1 / 2 / 2`. |
| `partial_header` | Forward the first eight bytes of the header write, then close TLS and return a short-write error (`:40–46`). Both sealed paths begin `POST /v1`. | On close_notify/EOF, bufio returns the nonempty unterminated line; HTTP parsing rejects it as malformed (`GO/bufio/bufio.go:405–437`; `GO/net/http/request.go:1098–1126`). `readRequest` propagates it and `conn.serve` writes HTTP/1.1 400 with a plain-text body and connection-close before returning; the handler never runs (`GO/net/http/server.go:1050–1058,2075–2121`). This answer can reach the client's read loop before its raw close; its body can instead be interrupted mid-drain. | `1 / 1 / 1`. |
| `partial_body` | Find the header terminator and forward headers plus half the bytes following it, then close TLS (`:47–58`). With current FlushHeaders that is normally headers plus **zero** body bytes. | Valid headers enter the second handler. Reading a positive Content-Length body to TLS EOF fails, so the handler returns before `complete.Add` and without writing (`:118–132`). The framework then supplies default 200 in `finishRequest` (`GO/net/http/server.go:1714–1736,2153–2169`). Thus a default-200 early-response window exists here too; it is not proof of a replay or valid provider output. | `1 / 2 / 1`. |
| `drop` | Forward no request bytes, close TLS, but report `(len(p), nil)` for the single armed write (`:59–61`); a later body write can fail. | Without a request line the server has only EOF or leftover unparseable body bytes if a later write escaped; with the present TLS close later writes fail, so no second handler/response is expected. The same no-reply EOF path as zero_write applies (`GO/crypto/tls/conn.go:1470–1483`; `GO/net/http/server.go:2075–2121`). | `1 / 1 / 1`. |

Observed and inferred are separate. N:30–45 reports 177 failures across 10,000 `partial_header` leaf runs: 35 returned nil error with status 400, all with `dials=1 requests=1 complete=1 writes=3 faultWrites=1`; 142 were faulted-response drain failures. No observed second send. Plain all-modes ×1000 found zero failures in 2,000 leaves for each other mode (N:42–45). The `partial_body` default-200 window above is source-derived, **not observed by that probe**. Zero observations do not disprove a reachable scheduling window. No evidence makes zero_write, read_eof or drop into early-response rows with the current fixtures.

Hosted annotations identify the three failing `partial_header` rows but do not contain their messages (N:5–9; T:77–81). The reproduction establishes this cause without pretending the hosted failure messages were seen. If the owner supplies those logs, compare their failure line to the two reproduced signatures; an inconsistent signature returns to diagnosis, not an assertion that all hosted details are already known (A:28–33).

### 0.3 What Core records for an early non-2xx response
Yes: the product transport can return an early server answer before finishing the request write; net/http intentionally supports that, independently of retries (`GO/net/http/transport.go:3053–3087,3109–3129`). This is not inherently a money defect.

`DispatchPaid` commits SENT intent before `Transport.Do`; it selects the adapter on a nonnil response, closes its body, applies any independent transport error classification and publishes an observation handle. It does **not** equate nil network error to paid success (`internal/core/agents/paid_dispatch.go:201–239,240–268`). The caller subsequently supplies a fresh command to `RecordPaidObservation`; only that command records the result (`paid_settlement.go:254–262,411–446`; R13:20).

For the actual early **plain-text 400**: both adapters keep `Status=400`. Anthropic assigns `invalid_request` before JSON validation and returns `ErrProtocol` for the non-JSON text; OpenAI assigns `protocol_error` when JSON validation fails. A failed response-body read instead assigns the transport-error class. In all cases `Complete` remains false and no terminal usage/no-charge evidence is fabricated (`internal/core/providers/response.go:73–125,128–182`; `openai_response.go:25–89`). Valid JSON 400 errors would classify `invalid_request` for both, except existing provider-specific subcategories; none authorizes release.

The observation is a bounded context-owned private object, then its digest/size bind the result. `derivePaidResult` starts `Kind=unknown`, supplies a nonempty error class, and returns that result unless completion, status 200, provider-message identity and admission model all match; the no-charge rule is considered only afterwards (`internal/core/agents/paid_capture.go:297–351`; `paid_settlement.go:28–55,69–116`). `RecordPaidObservation` writes `runtime.paid_result{kind:unknown,...evidence...}` with receipt outcome `unknown`; no usage, no cost, no no-charge evidence or output messages (`paid_settlement.go:411–446`). `paidResultState` ends the child but retains the original full hold in the unknown branch; no new send permit is produced (`paid_attempt.go:293–332,335–338`). If the host never records the observation, SENT remains unresolved/held rather than silently settled.

The source-derived default 200 in partial_body likewise has no provider SSE content type/terminal usage, so it stays unknown. An error class named `denied`/`invalid_request` is diagnostic classification, **not** a definite financial no-charge result. Ticket 13's ruling expressly forbids zero settlement from generic HTTP errors, EOF, timeout or disconnect; only its complete, pinned, documented no-charge facts authorize that financial result (R13:23,37; BR13:236–244,294–302; `docs/DECISIONS.md:727,3196`). Thus current Core's conservative result is correct: no money release based on the incomplete request or early status. No product, money or record change is justified by this evidence.

## §1 — Numbered design choices

The base, transport profile, no-record/no-module/testing-only constraints and one-slice permission are settled, not P-choices (A:13–25).

### P1 — Raw FIN close in ordinary fault rows
**Options:** (a) accept additional early-response outcomes; (b) close the raw socket directly without close_notify; (c) make the raw close abortive with SetLinger(0)/RST; (d) change product response/error precedence.

**Recommend (b), ordinary raw `net.Conn.Close`, no linger setting, plus P2/P3.** Continue writing through verified TLS, but cut its actual `tls.Conn.NetConn()` directly. Partial_header/body cannot cause their server answer until the server sees EOF; that EOF now follows closing the local raw socket, whose local read side is already closed before the peer can answer. Zero_write/drop send no parseable new request. Read_eof remains server-side hijack/close without a response. The server might still *write* an answer; the locally closed client cannot receive it. Sources: §0; T:110–112; A:19–24,75–81; `GO/crypto/tls/conn.go:1422–1483`; `internal/core/providers/transport_test.go:37–64,194–212`.

Reject (a) for the ordinary rows because C4 preserves their error outcomes. RST can discard the partial headers before the server sees them, undermining partial_body's required handler count. Changing product precedence would discard legitimate early responses despite correct held-money behavior. A raw fixture cut is not evidence that real paid failures are free; the unknown/full-hold policy stays (R13:21,23; `providers/doc.go:19–29`).

### P2 — Counts first, every row and every outcome
**Options:** (a) retain outcome/drain-first assertions; (b) repair only partial_header; (c) collect outcomes nonfatally, complete server observation, then validate dial/request/completion counts first everywhere.

**Recommend (c).** One private collector/validator serves all ten ordinary leaves, P3 and real-network count negative controls. A second dial **or** extra complete request fails unconditionally before judging error, response, status or drain. Preserve terminal-state-before-server-close ordering from 64c4afb. Sources: T:111–112; A:78–81; `transport_test.go:80–104,183–212`; `.scratch/dwarf-harness/c3-evidence/ticket-13-evidence.md:33–34`.

### P3 — Deterministic close-window regression and graceful control
**Options:** (a) stress only; (b) a channel-held real TLS close; (c) fake a RoundTripper answer; (d) use sleeps.

**Recommend (b).** A TLS-side Close interposer calls `tls.Conn.CloseWrite`, then waits on a channel until Do returns. Today's `faultConn` calls that interposer and necessarily receives the real server's 400 before local raw close. The repaired ordinary cut bypasses it and returns an error. Keep a separate deliberate graceful-control row selecting the interposer, accepting exactly HTTP/1.1 400 with nil Do error and counts 1/1/1. Run both variants for both providers, partial_header only. Early-answer behavior remains covered without relaxing ordinary rows. Sources: T:109–112,117; A:71–83; `GO/crypto/tls/conn.go:1460–1483`; `GO/net/http/transport.go:3053–3087,3128–3129`; `GO/net/http/server.go:2118–2120`; N:34–36.

### P4 — Preserve partial_body's actual byte placement
**Options:** (a) retain its header-terminator/half-remainder cut; (b) pass the entire header write and fault half the next body write. Both expect dials=1/requests=2/complete=1 and an error.

**Recommend (a).** It preserves the existing row semantics while fixing the established cause. Explain its actual FlushHeaders behavior in the fixture comment: normally headers and zero body bytes. Literal partial-body placement would improve its name's precision but is a separate semantic change unnecessary for this cause. P1 prevents delivery of its default-200-after-EOF answer; P2 still counts first even if an unexpected answer appears. Do not alter the handler's early return to suppress the framework response. Sources: T:112; A:8–9,71–81; `transport_test.go:47–58,128–132,202–204`; `GO/net/http/transfer.go:101–109`; `GO/net/http/request.go:764–778`; `GO/net/http/server.go:1714–1736`.

### P5 — Hosted stress diagnostics plus exact-final-SHA matrices
**Options:** (a) three ordinary final-SHA matrices, about 105–120 minutes serial hosted elapsed; (b) ten ordinary matrices, about 350–400 minutes; (c) two final-SHA matrices plus two throwaway stress-diagnostic matrices, one base and one fixed, about 140–160 minutes plus added stress runtime. These use the PM's supplied estimate of 35–40 minutes/matrix, not a ticket-145 measurement. Public standard runners use no paid minutes.

**Recommend (c), for the ruling to choose.** Deterministic P3 red/green and PM local stress are primary proof. Three lucky runs would be weak given the PM's approximately 2/28 Linux incidence plus a macOS failure. A temporary test executes 1,000 sequential iterations of the original two-provider/five-mode test on all three systems in tests and race, and reports failed-iteration counts through summary subtest names. Diagnostic SHAs never land or replace the final-SHA runs (§5.4). No workflow edit, retries, skips, quarantine or wider timeout. A post-fix target failure returns to diagnosis; reruns never count. Sources: T:110–113; A:82–83; `docs/CURRENT-RULES.md:19–24`; `docs/DECISIONS.md:3060–3067`; `skill://dwarfharness-ticket-publication` “Audit lessons (D167)”; PM outline response item 1 in this conversation.

### P6 — One test-only slice
**Options:** (a) one providers fixture/oracle/regression/docs slice; (b) add a product/money slice; (c) split fixture and oracle changes.

**Recommend (a).** No product/accounting defect was found; (b) has no justified work. The coupled fixture, oracle and regression should be reviewed together, not ship an incomplete proof between slices. The assignment expressly permits one slice here. No agents edit, where ticket 16 S4 runs. Sources: A:15–25; T:101–112; R13:21,23; `docs/CURRENT-RULES.md:8–20,37–48,72–74`.


## §2 — Exact test-fixture and oracle changes

All new helpers stay private in `internal/core/providers/transport_test.go`. No exported interface changes. The following resolves implementation details of P1–P4; the code is still subject to the fresh ruling (T:111–112).

### 2.1 Ordinary cuts, collector and validator
1. Add required test-only `cut func() error` to `faultConn`. At verified dial completion, require the returned connection to be `*tls.Conn` (the existing tls.Dialer guarantees it), obtain its real `NetConn`, and initialize cut to that raw connection's Close. No nil/graceful fallback. Replace **all five** `c.Conn.Close()` fault calls (zero_write, partial_header, both partial_body branches, drop) with `c.cut()`. Preserve forwarded bytes, n/error results, armed transition and counters. Read_eof still falls through to ordinary TLS writes. Only the injected cut is raw; final transport/server cleanup stays normal. Sources: P1/P4; `transport_test.go:30–64,71–73,150–161`.
2. Extract the existing complete row into `exerciseOneShotFault(t, provider, mode, closeMode, extraActivity) oneShotObservation`. closeMode is `raw`, `raw_window` or `graceful_control`; extraActivity is `none`, `extra_dial` or `extra_complete`. Ordinary leaves use raw/none; only P3 uses the window variants; only count controls use extra activity. Keep the same server, ALPN offers, envelope, verified dial, warm exchange, counters, terminal observer and httptrace. The helper does not call t.Parallel; original callers retain their existing parallel leaf structure. Warm validation/drain remains strict. Sources: P2/P3; `transport_test.go:106–183`.
3. Observation fields are final dial/request/complete/write/faultWrite counts, reused/protocol/idempotency flags, terminal state, attempt error, drain/close errors, and response-present/status/protocol scalar values. Never retain/log response.Request, request objects or authentication headers. After the faulted Do returns, release P3's channel immediately, then collect any response drain/close errors **nonfatally**, close idle connections, await first terminal state, close server, and snapshot counts. Leave fatal `drain` itself unchanged for warm/status/redirect tests. Sources: P2; `transport_test.go:80–104,183–212`; `internal/core/agents/paid_dispatch.go:228–229`; R13:26.
4. `checkOneShot(observation, mode, closeMode) error` first compares **all three** count expectations in §0.2. Any mismatch returns a wrapped private `errOneShotCounts` sentinel with the scalar snapshot. Next check existing warm reuse/exactly-one-fault and HTTP/1/no-idempotency invariants. Only then judge outcomes: raw and raw_window require nonnil attempt error, as before. An unexpected response/drain result is diagnostic, never a substitute for a missing error. Graceful_control is valid only for partial_header and requires a response, HTTP/1.1 400 and nil Do error; its drain may complete or hit the known transport-close error. No other early-response exception exists. Sources: P1–P3; T:111–112; N:34–35.
5. Keep original `TestPaidHTTP1OneShot` leaf names, parallel placement, exact counts and nonnil-error outcomes; fail on any validator error. Remove the pre-count nil-error/strict fault-drain assertions, not the one-shot checks. Add a short package-doc clarification beside doc.go:19–29: net/http can return an early response before request-write completion; status alone proves neither replay nor no charge, and Core holds without final billing evidence. This documents existing behavior, not new policy. Sources: P1/P2; §0.3; T:110–112; R13:21,23.

### 2.2 Deterministic window regression and graceful control
Add `TestPaidHTTP1OneShotCloseWindow/{anthropic,openai}/{raw,graceful_control}` using the same collector/validator with partial_header, extraActivity=none. Its raw leaf selects raw_window internally.

Only the window variants wrap the verified TLS connection in a test-only net.Conn interposer. It delegates reads/writes and unarmed Close. After warm completion, arm its Close barrier: first armed Close calls the actual TLS connection's CloseWrite, then waits on release before closing TLS. Use sync.Once for concurrent Close/result publication. raw_window's faultConn.cut still names the actual raw Close, bypassing the interposer; graceful_control explicitly sets cut to the interposer Close. Register an idempotent release cleanup before dispatch; release immediately on Do return, before draining/waiting, on error and success alike. Do not wait for a complete response-body drain to release: body EOF signaling itself can await connection teardown. No sleep/poll/new deadline, unsafe/linkname, fake TLS, synthesized HTTP response or RoundTripper. Sources: P3; `GO/crypto/tls/conn.go:1422–1483`; `GO/net/http/transport.go:2577–2596,2608–2646`; `transport_test.go:150–183`.

**Deterministic red:** install collector/interposer/new rows and cut-field initialization but leave Write's old `c.Conn.Close` calls. The raw leaf necessarily sends close_notify and holds local raw close open until Do receives the real server's 400. Counts are 1/1/1, then the shared validator rejects nil attempt error. The graceful_control accepts precisely that early answer. **Green:** change only those fault calls to c.cut. The raw leaf now returns an error; graceful_control still gets 400; both retain 1/1/1. Save both providers' red/green outputs. This is today's faulty path with test plumbing installed, not a claim that the unmodified baseline already contains the new regression. Sources: P1–P3; T:111; N:34–36.

### 2.3 Real-network count negative controls

Add `TestPaidHTTP1OneShotCounts/{anthropic,openai}/{extra_dial,extra_complete,counts_before_outcome}`. The first two exercise zero_write/raw. All pass only if `errors.Is(checkOneShot(...), errOneShotCounts)`; generic failure is insufficient.

- Extra_dial: after the primary attempt, open/close one additional real verified TLS connection through the same counted dial function, without HTTP. Require the control's actual observation to be dials=2/requests=1/complete=1. Its primary attempt still has the valid error outcome. This isolates the dial gate.
- Counts_before_outcome: exercise partial_header with deliberate graceful_control and extra_complete, then validate it against the **ordinary raw** outcome contract. This is a real dual fault: dials=1/requests=2/complete=2 plus a nil-error 400 that raw forbids. Require those exact observations and errOneShotCounts, not a generic outcome error. Thus moving outcome judgment ahead of counts turns this named row red. No outcome field is fabricated.
- Extra_complete: after warm completion, before arming, send and strictly drain one extra real POST on that same reused connection; then arm zero_write. Require actual dials=1/requests=2/complete=2. Its primary attempt still correctly fails, isolating server-count gates without the dial comparison masking them.

Check those exact control counts before demanding the sentinel, so a broken fixture cannot pass for the wrong mismatch. All traffic stays synthetic loopback TLS. The validator is the ordinary rows' own validator: removing its count stage makes these controls red. Sources: P2; T:111,117; R13:21,26; `transport_test.go:118–144,150–161`.


## §3 — Acceptance criteria and consumer proofs

| Criterion | Consumer-visible proof / plausible bug |
|---|---|
| C1, cause (T:109) | PM reproduction N:32–43 and retained raw hashes, §0 source chain, P3 deterministic red. A false retry diagnosis is contradicted by one dial/handler and the graceful 400. Compare old hosted messages if supplied; do not invent them. |
| C2, remove cause (T:110) | P3 raw red→green while graceful_control still returns 400. Restoring TLS-side Close turns the raw regression red. Product profile/transport remain unchanged; no retry/skip/quarantine/timeout edits. |
| C3, counts-first deterministic test (T:111) | P3 and TestPaidHTTP1OneShotCounts reject independent excess dial and same-connection complete request even with otherwise-correct error outcomes. Every ordinary mode uses the same count stage before outcome/drain judgment. |
| C4, all modes/goldens unchanged (T:112) | Ten original leaves retain §0.2 error outcomes/counts in focused/plain/race runs. Existing sealed-body/header, ALPN/status, redirect and certificate tests stay, with terminal-state waits. Existing paid goldens and TestPaidGroupRulesAndFrozenReplay replay chapters 13/14 unchanged (`internal/core/agents/paid_replay_test.go:29–109`; `contract/ledger/paid_golden_test.go:403`; `contract/ledger/paid_openai_golden_test.go:173`). |
| C5, hosted (T:113) | P5/§5.4 distinguish diagnostic and final SHAs; two fresh exact-final-SHA matrices each need classifier, all native tests/race jobs and aggregate success. Missing/cancelled/failed/exempt matrices are not passes. |

**Money proof stays scoped:** §0.3 follows early capture→unknown record→full hold. Run existing TestOpenAIPaidEvidenceStates denied/quota/rate/overload rows and TestPaidExplicitNewAttemptAfterUnknown: classified refusal is not free, and unknown exposure cannot be reused as headroom (`paid_openai_test.go:289–325`; `paid_exchange_test.go:495–499`). No new settlement algorithm/profile/object format/money fixture is justified because none changes (A:19–24; R13:23).


## §4 — Deliberate rule breaks

Mutants are never landed. Save original file hashes; apply one at a time, record command/exit/named red assertion, restore byte-identically and show that row green. Compilation failure is not successful break evidence. Product transport.go edits below are authorized **only transiently for these breaks**. Hidden second POSTs are a money hazard (`docs/CURRENT-RULES.md:17–18`; `docs/DECISIONS.md:3034`; R13:21,26).

| Mutant | Required named red behavior |
|---|---|
| Restore TLS-side Conn.Close instead of P1 raw cut | TestPaidHTTP1OneShotCloseWindow/{anthropic,openai}/raw rejects nil error/400 after confirming 1/1/1. Graceful_control stays green. |
| Functional GetBody returning a fresh independent reader of the positive body | TestPaidHTTP1OneShot/{anthropic,openai}/zero_write counts/rejects redial before outcome; sealed-body test also rejects GetBody (`GO/net/http/transport.go:868–876`). |
| Functional GetBody plus Idempotency-Key; repeat with X-Idempotency-Key | TestPaidHTTP1OneShot/{anthropic,openai}/read_eof rejects second dial/additional complete request. Composite is essential: header alone cannot replay today's nonrewindable body (`GO/net/http/request.go:1561–1575`; R13:21; provider-ticket skill correction). |
| Either idempotency key alone, including an empty-valued slice | TestTransportUsesOnlySealedHeaderSetAndBody/{anthropic,openai} rejects extra built-request key. Do not claim header alone must replay (`transport_test.go:222–250`; `GO/net/http/request.go:1561–1575`). |
| Remove the validator's whole count stage | TestPaidHTTP1OneShotCounts/{anthropic,openai}/extra_dial and /extra_complete stop receiving errOneShotCounts and turn red despite valid primary error outcomes. |
| Remove only dial comparison | The same /extra_dial controls turn red with normal handler/completion counts. |
| Remove handler-entry and completion comparisons, leaving dial comparison | The same /extra_complete controls turn red with only one real connection. |
| Move outcome judgment ahead of counts | TestPaidHTTP1OneShotCounts/{anthropic,openai}/counts_before_outcome returns a generic nil-error/raw-outcome violation instead of errOneShotCounts and turns red. This uses real extra POST plus graceful 400, not a synthetic result. |

No speculative credential/authority/sandbox/recovery mutants: their product paths are unchanged. No fuzzed product code changes, so no new timed fuzz campaign; normal seed corpus still runs (P6; `docs/CURRENT-RULES.md:17–18`).


## §5 — Slice, owned paths and verification commands

### 5.1 Slice and exhaustive owned paths
One complete S1, fresh coder and one fresh D152-standard review after the fresh design ruling (A:18; `docs/CURRENT-RULES.md:9–15`). Worktree `C:/Users/darius.jones/worktrees/dwarf-harness/145-oneshot`, local branch build/145-oneshot, base e3fc732133d8e6d5410f9aefab7f8aceff4f2fef plus publication Markdown. All execution below is from that worktree; main is read-only.

- **Committed code:** `internal/core/providers/transport_test.go`, `internal/core/providers/doc.go`. Standard-library errors/fmt test imports are allowed for wrapped count errors and scalar diagnostics; other imports stay the base set. No exported signature change. LSP references put faultConn only in this file; firstConnectionTerminal's four consumers here remain unchanged (`transport_test.go:22,30,149,156,93,146,287,333,364`).
- **Temporary hosted diagnostics, never integrated:** `internal/core/providers/zz_t145_hosted_stress_test.go` on §5.4 branches; base diagnostic also permits only the PM's existing two failure-message instrumentation edits to transport_test.go (N:20–22,32–38).
- **No committed edit** in agents/money/ledger/goldens/credentials/terminal/cmd/gitprocess/workspace/go.mod/go.sum/.github/tools/check. Transient transport.go rule breaks are §4 only. An additional proven defect returns to PM/ruling rather than silently enlarging ownership (A:17–24; P6).
- **PM/drafter close, not coder/designer:** public ticket-145 Answer/criteria/status, C3's docs/ROADMAP-CORE.md Status and docs/ROADMAPS.md board; private brief/ruling/evidence in `.scratch/dwarf-harness/c3-evidence/`. Publication owns the cross-links already. No new decision/CURRENT-RULES/CONTRACTS edit: no standing rule, owner gate or contract changes (`docs/CURRENT-RULES.md:25–29`; N:24–31).

Thus ticket 16's assigned paths do not overlap. The PM still orders normal exact-SHA rebase/integration (A:17; `docs/CURRENT-RULES.md:8`). There is no numerical runtime/CPU/RSS/capacity bound or acceptance-driver profile in this ticket: repetition counts are stress evidence, not throughput claims. No performance campaign (A:3–10,18; `docs/CURRENT-RULES.md:15,34–35`).

### 5.2 Coder commands and deterministic red/green
Use pinned go1.27.3, GOTOOLCHAIN=local, empty GOFLAGS, CGO_ENABLED=0 except race, and the stable coder context's existing tools. New barrier/channel/shared test state requires providers package race and affected ×20 even though product state is unchanged. No tool install/upgrade. Sources: `docs/CURRENT-RULES.md:15–18,46`; `skill://dwarfharness-slice-recipes:20,35–48`.

1. Save base imports with `go list -f '{{join .Imports "\n"}}' ./internal/core/providers` and corresponding .TestImports output. Retain PM's established base reproduction logs rather than rerun simply to confirm them (N:32–43).
2. Install P3 plumbing but leave old Write closes; run deterministic red, then raw-cut substitution and the same command green:
   `go test -count=1 -v -timeout 19m -run '^TestPaidHTTP1OneShotCloseWindow$' ./internal/core/providers`.
   Keep both providers' raw failures after normal counts and graceful-control results.
3. Focused final:
   `go test -count=1 -v -timeout 19m -run '^Test(PaidHTTP1OneShot.*|Transport.*)$' ./internal/core/providers`.
4. One plain verbose changed-package run:
   `go test -count=1 -v -timeout 19m ./internal/core/providers`.
5. Unchanged money/replay consumers:
   `go test -count=1 -v -timeout 19m -run '^(TestPaidGroupRulesAndFrozenReplay|TestOpenAIPaidEvidenceStates|TestPaidExplicitNewAttemptAfterUnknown)$' ./internal/core/agents`;
   `go test -count=1 -v -timeout 19m -run '^(TestGoldenF3_13|TestGoldenOpenAIStatic)$' ./contract/ledger`.
   No -update. Compare frozen fixture bytes/digests to base rather than regenerate expectations (T:112; `docs/DECISIONS.md:3214–3224`; R13:47).
6. `gofmt -l internal/core/providers/transport_test.go internal/core/providers/doc.go`;
   `go vet ./internal/core/providers`;
   run existing host staticcheck on `./internal/core/providers`. If its binary needs building, use approved `go build -trimpath -o <external-evidence>/staticcheck.exe honnef.co/go/tools/cmd/staticcheck`, then that executable; no new module/download (`skill://dwarfharness-slice-recipes:37`).
7. CGO_ENABLED=1 and the existing pinned compiler in coder context:
   `go test -race -count=1 -timeout 29m ./internal/core/providers`;
   `go test -race -count=20 -timeout 45m -run '^TestPaidHTTP1OneShot.*$' ./internal/core/providers`.
8. §4 isolated red/restored/green rule breaks. No routine local tools/check, five-target static run or long fuzz campaign (D152; `docs/CURRENT-RULES.md:15–21`).

### 5.3 PM stress commands and local evidence
The PM runs fixed-source counterparts of the already-established base reproductions; keep base red logs N:32–43 instead of routinely reconfirming them:

```text
go test -count=3000 -timeout 19m -run '^TestPaidHTTP1OneShot$/(anthropic|openai)/partial_header$' ./internal/core/providers
go test -race -count=1000 -timeout 29m -run '^TestPaidHTTP1OneShot$/(anthropic|openai)/partial_header$' ./internal/core/providers
go test -count=1000 -timeout 19m -run '^TestPaidHTTP1OneShot$' ./internal/core/providers
```

Base outputs are respectively 130/6,000 leaf failures, two race failures, and 45 partial_header failures in all-mode stress. Race uses the same pinned compiler/CGO setting as §5.2. Run fixed commands after deterministic green; record actual counts and exits. Failure means diagnose, not repeat until green. Any optional additional base comparison is explicitly diagnostic. No test/transport/tools/check timeout is widened; command-line limits follow existing recipes (`skill://dwarfharness-slice-recipes:48`; T:110; A:89–92).

Save evidence externally at `C:/Users/darius.jones/worktrees/dwarf-harness/t145-s1-evidence/`, with source/log paths and SHA-256 in private inventory: deterministic red/green and count/status/error/drain fields; each mutant/red/hash-identical restore/green; golden equality/replay; focused/plain/race/static; PM base/fixed stress; hosted run/ref/SHA/job records. Archive then remove local throwaway mutation scripts, never integrate them. Public text omits the local machine/reproduction details (A:25; `docs/CURRENT-RULES.md:25–30`; `skill://dwarfharness-slice-recipes:45–48`).

### 5.4 Hosted diagnostic and final-SHA procedure (P5)
1. **Before:** make build/145-diag-before-1 from base code, adding only the temporary stress file and the PM's two diagnostic message edits. Never integrate. Temporary `TestT145HostedStress` executes exactly 1,000 sequential outer iterations. Each does `t.Run(iterationName, func(t *testing.T) { t.Run("faults", TestPaidHTTP1OneShot) })`. That extra wrapper waits for the iteration's parallel descendants; directly starting 1,000 parallel top-level children would create unintended load. Count outer t.Run booleans as **failed iterations**, not failed leaves. End with summary subtest `iterations_1000_failed_<F>_passed_<1000-F>`, failing iff F>0. Do not manufacture failure to export zero counts. Original failing leaves/messages identify provider/mode and count/status/drain diagnostics. Unchanged hosted tests and race run this on all three native systems.
2. **After:** build/145-diag-after-1 derives from the final candidate, adding the identical temporary stress file only. Run once, never integrate. Record its distinct SHA and outputs. Target failure returns to diagnosis. A zero-failure baseline diagnostic is honestly zero, not substituted for the PM's established red. Diagnostic SHAs never satisfy final-commit criterion 5.
3. **Exact final-source series:** once fixed diagnostic is green and final code/docs SHA is frozen for review, push that same SHA once to fresh build/145-proof-1 and build/145-proof-2 **before main contains it**. Both diffs still include Go changes, so full matrices run rather than the Markdown/empty-diff exemption. Start the next only after preceding success. These are new pushes, never failed-run reruns; any target failure ends the series and returns to diagnosis. Failed/cancelled/setup/incomplete matrices are not successes (T:113; A:82–83).
4. Record ref/SHA, run ID/URL/attempt=1, classifier/full-matrix decision, per-OS tests/race and aggregate conclusions, observed durations, and private raw-log paths/digests where available. Success requires two full matrices, every native job and Check result green, and fresh slice approval on that exact SHA. Any earlier automatic candidate run is separately labelled and does not reduce the two-run commitment. If ticket 16 forces rebase, the new SHA needs its own fresh approval and two-run series; do not rebase merely to refresh main between runs.
5. Only then fast-forward/push main and perform the reviewed Markdown-only close. Normal guarded push tooling, no .github edit/manual owner-account dispatch. PM removes diagnostic worktrees/branches after preserving evidence; no stress file lands or diagnostic aggregate stands in for final proof (`docs/CURRENT-RULES.md:8,19–24`; `docs/DECISIONS.md:3060–3075`; `skill://dwarfharness-ticket-publication` “Audit lessons (D167)”).

Primary proof is deterministic, not lucky sampling. The two diagnostic matrices add targeted native stress; the two exact-final matrices establish the required final subject. Standard public runners consume no paid minutes (T:113; `docs/DECISIONS.md:2928–2933`). Additional automatic preliminary runs, if made, cost another PM-estimated 35–40 minutes and are outside P5's four-run estimate.


## ownerGates

**None in the proposed scope.** No live provider call, real credential provisioning/access, real spend/ceiling, new dependency/toolchain, frozen-contract/golden/producer-rule change, D52 production admission, owner-decision document, .github edit, privileged machine action or art sign-off is reached. Traffic is synthetic loopback TLS; public standard runners use no paid minutes; routine guarded pushes are delegated. Test-only close policy and hosted run count are reversible ruling choices, not owner reservations (A:18–25; T:101–105,113; `docs/CURRENT-RULES.md:23,37–48,72–74`; `docs/DECISIONS.md:3069–3075`; R13:29–35).

The owner was already asked for old hosted logs; missing logs are not an additional approval gate because reproduction supplies C1 (A:28–30; T:109). If later evidence proves a product/breaking-record remedy necessary, return to PM/fresh ruling and the exact owner question at A:23's boundary; no speculative authorization is supplied here.
