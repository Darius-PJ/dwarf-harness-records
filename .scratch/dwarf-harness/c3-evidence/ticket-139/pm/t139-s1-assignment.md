# Ticket139 S1 — additive contract and complete freeze prerequisites

## Worktree, authority and machine

You are a fresh coder for S1 only. Worktree `C:/Users/darius.jones/worktrees/dwarf-harness/139-registration`, branch `build/139-registration`, exact base `93e8f0afe125b1ea8e87f4b8336664dd390c5b3a`. Your tools start in main: ALL repository edit paths must be absolute worktree paths. Main/private records and T140branches are read-only. No Git writes. PM owns commits, pushes, timedfuzz, finalmain integration handoff.

**Start in CODE/TEXT-ONLY mode.** Primary PM has NOT granted a139localcompute slot. Do not run tests, builds, vet/staticcheck, gofmt/formatters, golden regeneration, fuzzing, Go tooling commands or explicit LSP diagnostics until I send an explicit grant. You may read and edit your owned code and use necessary LSP navigation/references under existing project requirements; no measurement hold is currently active. Before exported existing-symbol modification use LSP references. Record code-ready and ask parent for machine release with exact final commands; continue documenting/reviewing own code without command execution. A future edit hold includes gopls-triggering text edits.

## Read order and precedence

1. `local://coder-context.md:raw` standing constraints (copied into this session).
2. `local://t139-ruling.md:raw` authoritative complete ruling. **Ruling wins on every conflict with brief or old review notes.** All amendments below are already decided; no new design pass.
3. `local://t139-brief.md:raw` only relevant contract/API/golden/evidence sections; many proposed examples are superseded. Frozen old contracts win on old bytes.
4. Ticket139 in main and frozen packagecode/docs needed for direct existing conventions. Private DECISIONS/evidence are team-readable in main underD145, never public; no whole-log reads.

You implement S1, not whole139. Exactly three total slices have been ruled. S2's producer and S3's interrupted recovery remain later; do not add scaffolds for them.

## Exact deliverable and owned paths

Under your worktree only:
- new contract/ledger/registration.go
- new contract/ledger/registration_submission.go
- new contract/ledger/registration_test.go
- new contract/ledger/registration_fuzz_test.go
- new contract/ledger/registration_golden_test.go
- new contract/ledger/testdata/f3/139/**, generator-created only
- additive catalogue entries/comment in contract/ledger/catalogue.go
- append F3-139 specification and accurate catalogue overview in contract/ledger/doc.go

A narrowly justified additional registration-owned file in that same package is allowed if it keeps a large file manageable; no generic parser/registry/framework. List it in changed. No previousgolden, oldrules/codecmeaning/schema1–4 or module/workflow change. No Core producer/scaffold or permanent new agents test in S1. Temporary own probe support described below is allowed and must be removed/restored byte-identically before finalhashes.

Changed package is contract/ledger. Imports additions: STANDARD LIBRARY ONLY. Reuse existing strict JSON/UUID/digest/conditional-member, Resource, Origin, Binding and encodinghelpers. Do not implement another JSONparser or Resource. The shared frozen format staysversion1; Defined49→53 by adding exactly4types.

## Ruled contract (implement complete ruling)

Four version1 types:
- runtime.resource_registered: resource_id,expected_version,version,resource,audience
- runtime.work_domain_registered: work_domain_id,expected_version,version,audience
- runtime.declaration_changed: declaration_id,expected_version,version,subject,audience,consumers
- runtime.registration_receipt: command_id,submission_sha256,submission,outcome,version

Exact type/constants/Encode/Decode APIs follow existing family conventions and ruling. Resource uses existing ledger.Resource constrained to external. **Explicit opaque resource_key is supplied and bound; it is NOT derived from registrationUUID.** Existing1–256UTF8/no-control key grammar remains. paid-route/<UUID>, explicit bareUUID and ordinaryopaquekey allwork. No provider/credential/URL/accountinputorresolver. Document trustedhost nonsecretidentity semantic precondition honestly; no bogus secretdetector/URLheuristic. New registeredaddress immutable/unique are SERVICErules, not decodehistorylookups.

RegistrationRef kind,id,version (resource/work_domain). Consumers are taskkind/task_id or contextkind/binding. Audience requirednonempty strictlyUUIDbyteascendingdistinct; consumers requiredpossibly[] strictlycompactknownJSONbyteascendingdistinct. Kind-scoped entitynamespaces: sameUUID across resource/domain/declarationallowed. Expected0creates1, positive +1 throughMaxInt64 with checked arithmetic; do not add familywidecrosskindexclusion.

Schema5 has THREEoperations: resource.set, work_domain.set, declaration.set. Root order schema,actor,origin,operation,arguments. actorowner. Concreteargs:
resource_id,expected_version,resource,audience;
work_domain_id,expected_version,audience;
declaration_id,expected_version,subject,audience,consumers.
**NO RegistrationTarget; NO register/reviseops/wrappers or implicitresourcefallback.** Digest is SHA256 exactcompactknown-fieldencoding. Receiptdigest recomputed, resultversion==expected+1. Outcome openwellformedtoken; writer applied, unfamiliarpreserveddecode but laterCorefailclosed. Other documentedkinds/actor/opsclosed.

Frozencompletepayload/submissioncap65536 oninputincludingignoredbytes BEFOREparse and encodedoutput. FullUTF8completeobject, duplicatememberrejection everydepth evenignoredextensions, knownnon-nullrequired, unknownoptionalmembersignored, wrongkindknownfieldsforbiddenevennull, UUIDv7canonical and nonzerolowercasedigest, plainunsigneddecimalint64range. Numericfanout/populationceiling NOT decoderlimits. Only two futureproducerlimits are MaxRegistrations256 and MaxDeclarations1024; S1 does not touchCoreLimits.

Allgroups exactlyF0command,matchingnewfamilyeffect,registrationreceipt. Allowner, sameagent/session/context and commandoperationID; noturn/measurement/bodyrefs/mixedfamily. Fullspec separates codecstructural rules from Corepreflight/replaystate rules: exactoriginalrequest, globalcommanddedupbeforeCAS/limits, addressimmutability/uniqueness, registeredorigin/audiences, currentversion pinnedsource, scopecontainment, completeconsumerreplacement includingemptywithdrawal, receiptactualsequences beforeack. Do NOT buildCoreproducer to enforce these inS1.

Status comments newfamily say **proposed for freeze (D125)**; do not say frozen before jointreview/record. PayloadownerC3; only internal/core/agents throughledgerstore.Submit; Coreownerqueries/replay thenTicket61; accessfilteredopaqueidentity/version/audience/source/consumer/receiptmetadata no privatecontent/secret/providerconfiguration; allknownfields/envelopebindings essential. Recordavailability != produceroperational.

## Golden — precise amended ruling

Newfixture chapter139, fixedcolony019a1390-0000-7000-8000-000000000001. Preservebrief's id(n) scheme and realobject/taskbodybytes. Completefixture is **19commits/65records**: originaltwoagentregistrations, oneworkcontextcreation, realownerunassignedtaskcreation =4commits/20records; then onevalidF3-11ownerrootgrantgroup = fifthcommit/records21–23; then14newfamily3recordgroups =42records. Firstneweffect/receipt25/26; final64/65. GenerateIDs/times consistently from amendedordinalsequence, actualhashes/chain and realproducer canonicalcodecs. No manualJSONLediting.

ResourceR identityid(0x400), explicitResource{external,"paid-route/"+id(0x450)}. Grantid(0x600), ownerA/generalorigin, grantee/solerecipientA/general, model.call, exactResource, externaldataclass, zerononnegativecapacityfields/depth0, until_revoked, no parent/taskbinding, authority0→1. No paidrouteorproviderrecords needed. Grantbefore registration proves permissionindependence.

The14newgroups fromruling: Rv1audienceAB; Dv1AB; all4source→task/contextdeclarations; Rv2A; Dv2B; resource declaration mixedconsumers pinRv2; resource-contextwithdraw; domain-taskwithdraw; domain-contextrevise pinDv2; Rv3AB; resource-taskrevise pinRv3. Counts/nestedtables/keyorder/fixtures come fromruling not obsoletebrief62records. TestGoldenF3_139 -update alonewritesALLnewlog/objects/bodiesfiles, hash-named bodies/objects LF/noCR. Existingfixturebytesallunchanged includingD149correctedF3-13.

## Tests and actualCore prerequisite probe

Keep permanentcodec/canonicalization tests only for plausibleobservable contractbugs: malformedrecursive/nestedduplicate/null/wrongconditionalfields; openoutcome+unknownoptional; versions/overflow; audience/consumerorder/duplicates; nonsecretopaquekeyaddress handling; canonicalsubmission/receiptbinding; exactandoversizedcompleteinput/effect/receiptcaps. Goldenassertsfrozenbytes/actualReadersemantics. Reuse priorgoldentests+hashproof; no cataloguecount/source/wiring-onlycompatibilitytest. t.Parallel first independentfixtureowningrow; isolateddeterministicrealfixtures.

AFTERcomputegrant, run mandatory throwaway **TestRegistrationFreezeSetupProbe** using actualledgerstore.Open and agents.Open onnewfixturebeforejointfreezereview. PreproducerCoremayignoreF3-139types; validateearlierfamilies. Require successfulOpen, zeroreconciliationissues, durable65before/after, unchangedledgerbytes, reconstructedearliertask+grant. Reconciliation.Completed maybenonempty (legitmaterializationrepair); donotforbidit.

Negativecontrol: separaterebuiltcopiedlogwith earlierownertaskcreate missingdependency; rebuildsubmission/digest/chainconsistently; actualOpenmustreject. Nevercorruptretainedgolden. Retainprobesource/commands/outputsprivately. Temporary chapter139support in scoped_golden_test.go allowed only if needed; hashbaselinefirst, restoreexactbeforefinalhash. Own throwaway testfileinagents removedbeforefinalhash. No permanentprobepadding, fakeStore or guessedsequenceoutput. Put retainedsource/logsinS1evidenceoutsideworktree.

NewFuzzDecodeF3_139 exercises4codecs+schema5, realgoldenshapes, recursivelyambiguousJSON/boundaries. Coder runsseeds only. PM owns120scampaignaftercodecommit. Do not fuzzoldcodec withoutactualchangedpath. S1 no concurrency/sharedstatechange: NOlocalrace/×20. Noplatformfilechanges: NOalltargetstatic. No irrelevantmoney/sandbox/permissionmutationcampaignforpurecodec; requiredprobe negativecontrol above is specific meaningful acceptance evidence.

## Finalcommands after explicitslotgrant only

Go1.27.3; GOTOOLCHAIN=local; GOFLAGS empty; CGO_ENABLED=0; GOOSwindows/GOARCHamd64. Allcommands serial. Bashdeadline1200for19mcommands; do not alterproducttestdeadlines or tools/check. Run focusednewtests, oneplainverbosecontractpackagefinalrun, gofmt-l explicitownedGo list, hostgovet/gotoolstaticcheck, importaudit, gomodtidy-diff/verify. TestGoldenF3_139 -update (newfixture), allTestGolden -update and unchangedoldfixtureproof, realledgerstoreconsumerpackage test. ActualCorepositive/negativeprobe asabove. No tools/check, fullgate, benchmark, providerrequests, newtoolsinstall or secretreads. PMwillreusetree/hashverifiedfinalevidence not gratuitouslyrepeatpackagechecks.

Evidencefolder `C:/Users/darius.jones/worktrees/dwarf-harness/t139-s1-evidence` outsideworktree. Allscript/logsourcehere; deleteonlyyourthrowawayscriptsafterproof and retain requiredsource/outputartifacts/yield. Do not deleteotherexistingworktrees/evidence. Filehashbaselinebeforetemporarymutations and exactrestoreassertions. Afterlasteditfinalsequence savealllogs and fileSHA256; noeditsafteryield.

## Critical reviewer notes (verbatim)

- Implement this ruling, not conflicting examples from the brief.
- `Resource` is explicit and immutable; never derive its key from the registration UUID.
- Preserve the full existing opaque external-key contract, including paid-route addresses, without invoking their producers.
- Three operations; no `RegistrationTarget`; two producer population limits.
- Golden is **19 commits / 65 records**, with the earlier root grant and paid-route-shaped address.
- The actual Core prerequisite probe occurs **before** the joint freeze review.
- Obtain all new fixture hashes from the generator; preserve old frozen bytes and D149’s corrected F3-13.
- Catalogue and comments must distinguish specification, later producer implementation and actual freeze status honestly.
- No new dependency, provider path, graph work, cache or main/shared-record ownership is transferred.
- No technical source question remains open. Compute scheduling, final hashes, CI runs and the completed S1 freeze review are future execution gates, not missing design evidence.

## Yield

Beforecompute: send CODE_READY with exactcommandlist to parent and **wait for explicitgrant**, not an assumed machinefree.
FinalJSON `{changed:[{path,reason}], commands:[{command,environment,exit,log}], tests, breaks, timing, finalHashes:{path:sha256}, goldens:{path:sha256}, deletedOrRenamed:[{path,reason}], probe:{source,positive,negative,restoration}, openQuestions}`. Markracenotrun(reasoncodec-only), neverzero. List everychangedtracked/newfilewithhash and everytest/rowremoved/renamedwithreason. Finalhashesonlyafterallprobesremovedandoriginalhelpersrestored. No Gitwrites. Stoponlyif the SAMEfailurepersistsaftertwoattemptstofixit, then yieldexactblocker; distinctcompilecorrectionsarenotstopcondition. Ask numbered questions toparent; readeravailable forboundedfacts; nosubagents.
