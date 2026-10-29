# Assignment: publish tickets 139 and 140, then audit the tickets' dependencies and order

## Output
- Write `local://t139-t140-publication-edits.md`, an edit file in your role's form. An empty find creates a file. Write it in this order:
  1. `## Owner summary`, at most 25 lines, which the PM shows the owner before anything is applied:
     - each new ticket's number, title, blockers and purpose, one or two lines each;
     - each existing ticket that changes, with the change (new blocker or comment) and the reason in one line;
     - each other document that changes.
  2. `## Audit`:
     - a table of every open ticket the search below found, with its `path:line`, what it says, your disposition (new blocker, cross-link comment or no change) and the reason;
     - the dependency check after the change: new edges listed, and no ticket its own ancestor (by ancestor closure over every `Blocked by` line).
  3. The edits.
  4. The short report your role asks for.
- Copy every find from `main` d12f605 in the main checkout, `C:\Users\darius.jones\Documents\PROJECTS\dwarf-harness`, which is read-only to you. Read `docs/DECISIONS.md` by line range only.

## The owner's words
- 2026-10-24 11:35, chat, answering the overnight log's questions 5 and 6 (`C:\Users\darius.jones\Documents\PROJECTS\DwarfHarness\Overnight-log-2026-10-23.md:28-37`, where the PM recommended publishing both). Quote it verbatim, typos kept: "5. The family ticket should be its own ticket: 139, 6. Publish this as ticket 140, then audit and update ticket dependancies and order"
- Also from that message: "3. The next ticket shall be Ticket 12 then 13".
- His approval of your owner summary comes later. Write it as `«OWNER-APPROVAL»` where the decision entry quotes it.

## Sources
1. **The seed:** `C:\Users\darius.jones\.omp\agent\sessions\-Documents-PROJECTS-dwarf-harness\2026-10-08T23-08-56-101Z_01a11dc6-e3a5-73a6-be48-e2faffbaa318\local\t139-t140-seed.md`. It holds the facts and their sources, with line numbers on d12f605. Its `local\` paths are in that same folder.
2. **The procedure:** `skill://dwarfharness-ticket-publication`, its "Ticket format", "Decomposition rules", "Touching existing tickets" and "Field rules", which were updated today: a blocker may be numbered higher than its ticket, as long as no ticket becomes its own ancestor.
3. **The tracker:** `docs/agents/issue-tracker.md` and `docs/agents/triage-labels.md`. Ticket 01, for the boilerplate the skill names. Ticket 138, the newest published ticket. Tickets 10 and 11, the C3 tickets in this form. Ticket 12's comment of 2026-10-24, line 51, a recent comment's form.
4. **The spec, for coverage numbers:** `.scratch/dwarf-harness/spec.md`. User stories run from line 25, implementation decisions from line 375 and testing decisions from line 583. Choose only numbers whose text the ticket's criteria serve, and cite each in your report.
5. **Records:**
   - `docs/DECISIONS.md`: B3 (line 669), D140 (2608), B32 (2637; item 4 at 2657, Limits at 2658), and D125 and D116, by heading;
   - `docs/CONTRACTS.md:39`, C3's row;
   - the status board, `docs/ROADMAPS.md:164-198`, U3's row at 189, and U3's Status line in `docs/ROADMAP-UNDERCURRENT.md`.

## Settled (don't reopen)
- **Numbers, type and date:**
  - 139 is the registration family and 140 the replay and lookup cost. Both are C3, Type `task` and `ready-for-agent`, with Published 2026-10-24.
  - Write each title as a ticket title, in the tracker's existing imperative form.
  - Each is blocked by 11, unless the audit finds a source requiring more.
- **Proposed blocker changes:** confirm or refute each in the audit, with its source.
  - Ticket 15 gains 140, so its line becomes `Blocked by: 14, 140`.
  - Ticket 61 gains 139, so its line becomes `Blocked by: 07, 09, 11, 15, 17, 139`.
  - Resolved blockers stay on the line.
  - Each changed ticket gets the skill's dated rework comment: the old and new blockers, and why.
- **Ticket bodies:** no file paths or code in a ticket's body (skill). Links to `docs/DECISIONS.md` and to `.scratch/dwarf-harness/c3-evidence/` files are allowed, as ticket 12's comment shows.
- **Current gates:** write each ticket's gate bullets from the current rules, not by copying the bullets of 2026-10-06. For example, since D125 the PM freezes a completed family (`skill://dwarfharness-contract-freeze`), and only a breaking change to a frozen contract, D52, a new dependency (D29) or another decision the documents reserve goes to the owner.
- **One decision entry, D142:**
  - `Decided by: adopted`, quoting the owner's words above and `«OWNER-APPROVAL»`;
  - it records the two publications and every blocker change (the skill: "Record any blocker change in the decision entry and the ticket's rework comment");
  - append it after the log's last entry and keep it short.
- **Order:** record it only where the documents keep it, and change no step's status value.
  - The owner's order is 12, then 13. Ticket 140 must land before ticket 15 (AdvisorT11S4's ruling 4, cited in the seed).
  - U3's board row and U3's Status line say that 61's remaining criteria and ticket 62 "wait for producer freezes: tickets 11, 15, 17". Ticket 11 is resolved and F3-11 frozen (D140). If the audit adds 139, change that text in both places in the same way.
  - Leave C3's Status line and board row unchanged unless the audit shows a need.
- **`docs/CONTRACTS.md`:** change it only where the register already points to producing tickets, and report what you chose.
- **Publication grants nothing:** it changes no step's status, freezes no contract and grants no D52 approval (skill).

## The audit
- **Which tickets:** every ticket in `.scratch/dwarf-harness/issues/` whose Status is not `resolved` and that names any of:
  - ticket 10 or 11, by number or link;
  - the registration family: registered or shared resources, work domains, host registration, resource IDs;
  - the agent service's replay, lookup or startup cost: opening it, replay after restart, turn start, local admission, or task lookups.
- **For each hit:**
  - a new blocker only where one of the ticket's own criteria cannot be met without the new ticket's result; cite the criterion's line;
  - otherwise a cross-link comment in the skill's form where the ticket builds on 139 or 140;
  - otherwise no change.
- **Check these by name:** tickets 16 (restart proof), 59, 62 and 89. Also check any C7 or GUI-F ticket that would show registered resources or work domains, under the skill's producer-first rule.
- **The current graph** (the PM's script on d12f605):
  - 11 blocks 12, 13 and 61;
  - 14 blocks 15;
  - 15 blocks 16 and 61;
  - 17 blocks 18, 19, 20, 59 and 61;
  - 61 blocks 59 and 62;
  - 62 blocks 63 and 73.
  - The open, unblocked tickets are 12, 13, 47 and 49 (47 and 49 deferred, D138). The claimed ticket is 137.

## Placeholders
- `«OWNER-APPROVAL»`: the owner's answer to the summary, filled by the PM.
- Name any other placeholder in your report.

## Yield
`{ "status", "record": "local://t139-t140-publication-edits.md", "edits": [ids], "placeholders": [...], "audit": [{"ticket", "disposition", "reason"}], "choices": [...], "openQuestions": [] }`
