# Ticket139 S2 — Standards axis

Read the pinned common context t139-s2-review-context.md from the secondary PM's local directory supplied at activation. Review ONLY the standards/maintainability axis of that exact diff. Spec conformance is assigned independently; you must not delegate. Report documented breaches and judgement smells separately, not tool-enforced formatting/static issues. Source evidence and the current DwarfHarness conventions override generic heuristics.

Standards sources: injected AGENTS.md; current coder-context.md (D152/D153, B26/B28); docs/ROADMAPS.md working rules and Core roadmap principles; docs/agents/domain.md and tracker conventions; D45 imports/layer table enforced by existing tool; current family patterns in the exact changed package. Do not invent a closed import allowlist—existing approved agents imports legitimately include credentials/providers. No module/dependency/build-constraint changes. Follow the existing family structure; mechanical fifth-result callsite migration is intentional.

Always-on Fowler smell baseline (heuristics, never automatic violations):
- Mysterious Name: name does not reveal purpose → rename; unclear purpose may expose design trouble.
- Duplicated Code: same logic shape in more than one hunk/file → consider extracting the shared shape.
- Feature Envy: method reaches into another object's data more than its own → consider moving it.
- Data Clumps: same fields/parameters travel together → consider a small cohesive type.
- Primitive Obsession: primitive/string replaces a real domain concept → consider its own small type.
- Repeated Switches: same type cascade repeated → consider polymorphism or one shared map.
- Shotgun Surgery: one change scatters edits → consider gathering the changing concept.
- Divergent Change: unrelated reasons change one module → consider separation.
- Speculative Generality: abstractions/parameters/hooks for unrequested needs → delete/inline until needed.
- Message Chains: long navigation exposes another object's walk → hide the walk where it belongs.
- Middle Man: module mostly delegates → consider removing the delegation layer.
- Refused Bequest: implementation ignores/overrides most inherited behavior → favor composition.

Repository conventions OVERRIDE this baseline. Every baseline smell must be labelled a judgement call, not a hard breach. Skip tooling-enforced issues. In particular do not replace the established explicit family switches with a registry/polymorphic framework merely because this list mentions repeated switches; boring bounded repetition can be the correct repo pattern.

Assess new permanent tests against the observable-contract bar: no source/wiring/default/mock-echo/wording/time pins, no per-test deadlines or sleeps, meaningful boundaries/transitions/real errors. The I/O-pinning new test was already deleted; do not restore it. Read the actual three mutation outcomes and the original-binding no-append question in the common context before crediting proof. Preserve honest masking distinctions.

Write private report t139-s2-standards-review.md (under400 words) and JSON t139-s2-standards-review.json in the supplied secondary PM local directory, or return complete report content if role write restrictions prevent artifact creation. JSON fields: status, axis, subjectSHA, baseSHA, verdict, findings, evidenceReviewed, remainingExternalGates, ownerGates, confirmationNeeded. Cite source/hunk for every finding; distinguish hard breach vs judgement. Approved means your axis is technically approved subject only to separately named remaining unchanged-subject fuzz/hosted/integration gates. No source edit or routine confirmation pass.
