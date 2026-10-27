# Where ticket 13's time and budget went (PM-Beta, 2026-10-27)

Asked by the owner on 2026-10-27: are process steps slowing the coders, can several sessions code at once, and can the project finish by the end of December? Sources: the agents' transcripts in the session folder, the coders' `commands.json(l)` files in `worktrees\dwarf-harness\t13-*-evidence\`, `agent.db` `usage_history`, `git reflog main`, and the issue files.

## Wall clock: 36.4 h (2026-10-25 16:07 → 10-27 04:28)
- About 11 h waiting overnight for the owner's answer to the budget question (asked 22:10, answered 09:58; S3a's coder idle from 23:02 to 10:00).
- About 1 h for the restart pause and the owner's questions (15:58–16:55).
- 8.1 h of S4's measurement: run 03 took 16,781 s and was superseded (wrong cold-precondition labels); run 04 took 12,170 s.
- 2.2 h of design: DesignerT13 113 min, three readers in parallel, the ruling 26 min.
- About 14 h for the eight slices S1–S4b: coding, the PM's checks, 11 reviews or confirmations (250 min, Fable $76.89, stand-ins $7.30), and five fix-up rounds (S1's toolchain and test race, S2b's golden, S3b and S3c rejects, S4's erratum). Two were real majors: S3c's credential lock serializing every exchange, and its deleted approved tests.

## Coder time, eight slices, without the measurement: about 9.6 h
- About 6.7 h of model time, writing code and tests: 69%.
- About 2.8 h of commands: whole-package race 64 min, whole-package plain runs 50 min (30 of them S1's load diagnosis), rule breaks 20 min, five-target vet and staticcheck 13 min, ×20 race repeats 11 min, focused tests 8 min.
- Each coder made its first code edit within 1–4 minutes, so reading in is not the cost.
- Per normal slice (S3a–S3c): 100–115 active minutes, 60–75 of them model time.

## Budget per ticket
- Ticket 13: `anthropic:7d` 0.74 → 0.97, +23 points; ticket 12: 0.39 → 0.65, +26 points. At about a quarter of the weekly window per ticket, the window allows about 4 tickets a week.
- Anthropic dollars for ticket 13: the PM's own session $106.31 (718 turns, 399,760 tokens of context per turn on average, peak 701,159), Fable $76.89, Sonnet $13.25, the Opus helpers $5.61.
- Codex: about 0.8 of a window (0.27 before the early restart of 10-26 02:52, then 0.54). Astra coders $225.05.

## Pace and shape
- 17 tickets since 2026-10-09 (13 counted as done); C3's tickets 10–13 took six days. 123 remain; December 31 is 65 days away, so about 1.9 tickets a day are needed.
- The longest dependency chain still holds 21 tickets: 13 → 14 → 15 → 16 → 17 → 20 → 21 → 22 → 24 → 25 → 29 → 34 → 35 → 57 → 113 → 117 → 125 → 126 → 128 → 129 → 136.
- Unblocked once 13 closes: 14, 89, 139, 140 (C3); 47 and 49 are deferred (D138); 137 is on hold.
