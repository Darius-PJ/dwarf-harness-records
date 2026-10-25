# OG2: freeze request for the F0 ledger contracts

**Requested:** 2026-10-10, at the end of Core step C1 (ticket 03), under D40. **Answer:** 2026-10-10, option 1 in your own words: "Freeze all three, create a markdown detailing user needs for the three parts and place it into repo root and hold for continuation". [D111](../../../docs/DECISIONS.md#d111-f0-ledger-contracts-frozen-at-version-1) records the freeze, adapted from Appendix A to your answer, and `CONTRACTS.md` records Appendix B's edit. The rest of this packet stays as sent.

C1 is Done with this request sent; it does not wait for your answer ([`ROADMAP-CORE.md`, C1](../../../docs/ROADMAP-CORE.md#c1-action-ledger-and-body-store), stop point). The steps that build on these contracts do wait ([status board](../../../docs/ROADMAPS.md#status-board)):

- C2 needs `ledger-format` and `ledger-appender`;
- U1 needs `ledger-format` and `ledger-reader`;
- R1 needs all three;
- U3's foundation needs `ledger-appender`.

## 1. What is requested

Freeze three contracts at commit `95aa88d` of `main`, each as **Version 1** with status **Frozen**:

- **`ledger-format` v1** (package `contract/ledger`): the record line and envelope, and the commit, hash-chain, cap and segment rules of [B18](../../../docs/DECISIONS.md#b18-c1-ledger-format-v1-encoding-colony-store-and-os-adapter); the optional envelope key `body_refs`; and the F0 catalogue of four C1 record types (§2.3).
- **`ledger-reader` v1** (package `contract/ledger`): B18's reader and `Check`, with the new option `ReadOptions.AllTypes` and the newly exported `ParseSegmentName`.
- **`ledger-appender` v1** (package `contract/ledger/appender`): the `Appender` interface and its errors, including the refusal of unpublished body references and of the types only Core's store writes.

**What a freeze means.** A frozen contract changes only by addition: new optional fields, new types, and new type versions with upgraders. A breaking change needs your decision entry listing every step it affects, and the golden tests catch a change made without one (D40; [`CONTRACTS.md`, Rules](../../../docs/CONTRACTS.md#rules)). Later record families join through their own additive catalogue freezes once their producers specify them (B2). This request freezes none of them.

Appendix A holds a draft decision entry and Appendix B the register edit, for you to accept or edit. Ticket 03 applies neither.

## 2. Surfaces

### 2.1 `go doc -all ./contract/ledger` at `95aa88d`

```text
package ledger // import "github.com/Darius-PJ/dwarf-harness/contract/ledger"

Package ledger is the ledger-format and ledger-reader contract (F0): the on-disk
encoding of a colony's history, the rules that verify it, and the read-only
Reader through which every consumer replays it. Format version 1 is a draft
until its owner freeze (D40); this documentation is the format.

# Records

A log is a sequence of records. Each record is one line:

    lowercase_hex(SHA-256(json)) TAB json LF

where json is compact UTF-8 JSON (unchanged by json.Compact) holding one object,
and the hash covers exactly those bytes. Readers check the bytes as stored and
never re-marshal.

The object's keys, in the order the writer emits them:

    key                   type          presence   rule
    format                integer       required   always the first key; 1
    seq                   integer       required   colony sequence; the first record is 1
    commit_id             UUIDv7        required   one fresh ID per commit
    commit_index          integer       required   0-based position in the commit
    commit_count          integer       required   records in the commit, at least 1
    prev_hash             64 hex        required   the previous record's hash; ZeroHash for seq 1
    event_time_ns         integer       required   UTC Unix nanoseconds, above 0, never decreasing
    clock_held            true          optional   the time is held at the previous record's
    colony_id             UUIDv7        required   the colony's ID
    type                  string        required   ^[a-z][a-z0-9_]*(\.[a-z][a-z0-9_]*)+$
    type_version          integer       required   at least 1
    actor                 string        required   owner, agent, core or runner
    agent_id              UUIDv7        optional
    execution_session_id  UUIDv7        optional
    context_id            UUIDv7        optional
    turn_id               UUIDv7        optional
    operation_id          UUIDv7        optional   links a start and its end
    measurement_path      string        optional   ^[a-z][a-z0-9_]*(\.[a-z][a-z0-9_]*)*$
    body_refs             digest array  optional   non-empty; strictly ascending, hence distinct
    payload               object        required   the type's payload; {} when it has no fields

IDs are canonical lowercase dashed UUIDv7 strings. Integers are plain JSON
integers with no sign, fraction or exponent; seq and event_time_ns exceed 2^53
and are exact only for decoders that preserve 64-bit integers. A digest is the
SHA-256 of some bytes as 64 lowercase hex digits, never all zero (Digest).

body_refs lists the bodies in the colony's body store that the record
references. They are the record's only body references: a hash inside a payload,
such as a private-content hash, a check digest or a Git object ID, is not one. A
record family whose payload names a stored body must also list it in body_refs,
and says so in its own payload rules, because readers do not check payload
interiors.

A record is invalid if its first key is not format; if a key repeats or a known
key is null; if a required key is missing; if an optional key is present but
empty, clock_held is false, or any value breaks its rule. A format other than 1
in a correctly hashed record is reported as an *UnsupportedFormatError; every
other invalid record fails closed. Keys this version does not know are ignored,
so the envelope can gain optional keys by addition; Record.JSON keeps them.
An absent optional key decodes to its type's zero value: a zero uuid.UUID,
an empty MeasurementPath, a nil BodyRefs, ClockHeld false. Present and absent
are never ambiguous, because a present value is never empty, and no default is
ever guessed.

A payload must be a JSON object with no repeated key in any object at any depth.
EncodeCommit refuses one that is not; readers do not re-verify payload
interiors, which belong to each type's contract.

# Commits and the chain

A commit is one or more records written together. Its records have consecutive
seq, the same commit_id, commit_count, event_time_ns and clock_held, and
commit_index 0 to commit_count-1; the record with commit_index commit_count-1
ends it. Every record's prev_hash is the hash of the record before it, across
commits and segments. Event time never decreases; clock_held marks a commit
whose time was held at the previous record's because the clock moved backwards,
and is never on seq 1. EncodeCommit is the one encoder: it assigns seq,
prev_hash and the commit fields, and refuses any commit a reader would reject.

A line over MaxRecordBytes, counting hash, TAB and LF, or a commit whose lines
total over MaxCommitBytes is refused by EncodeCommit, and Check and Reader fail
closed on any such line or complete commit found on disk. This bounds a reader's
memory to one commit and the torn tail below. Changing either cap later breaks
the format, because older readers reject larger records, and needs its own
decision entry (D40).

# Segments

The log directory holds segment files named by the sequence of their
first record as 20 zero-padded decimal digits and ".jsonl" (SegmentName,
ParseSegmentName). The first segment is 00000000000000000001.jsonl, and each
later one is named by the previous segment's last seq plus 1. A segment holds
whole commits only, and only the newest may be empty or end in a torn commit.
Entries whose names begin with a dot are ignored; any other entry that is not
a regular file with a segment name fails closed. Compressed segments are not
recognised; adding them needs a name rule.

# Torn tails and failing closed

Check accepts only complete, correctly hashed and chained commits in order.
Let E be the end of the last complete commit in the final segment.
The bytes from E to the end of the file are a torn final commit, reported
as CheckResult.TornBytes and never replayed, only if they are at most
MaxCommitBytes and every LF-terminated chunk among them that is, or ends in,
a correctly hashed line decodes and fits the one commit that could have been in
flight:

  - its colony_id is the colony's, and all such lines share commit_id,
    commit_count, event_time_ns and clock_held;
  - seq is the last complete commit's seq + 1 + commit_index, and commit_index
    strictly increases with file position;
  - the line with commit_index 0, if present, begins exactly at E and links to
    the last complete commit's hash; a line whose predecessor in the commit is
    present links to it;
  - the time is not before the last complete commit's, and is equal to it when
    clock_held is set.

Other chunks, such as partial lines, zeros or garbage, are permitted, because
an interrupted write can persist blocks out of order or as zeros. Anything else
fails closed with a *CorruptError, as do an invalid line, an incomplete commit
or emptiness in any earlier segment, a missing first segment and a gap between
segment names. A correctly hashed line after damaged bytes therefore fails
closed.

The rule cannot tell damage confined to the final commit, up to MaxCommitBytes,
from an interrupted write. Detecting that waits for external anchoring of the
latest hash (D36, assurance A3).

# Reading

A Reader opens files read-only and never writes, truncates, renames or locks,
so replay has no effects and may run while a writer holds the colony.
It returns whole commits only, verifying every record it reads, consumed or not:
hash, chain, sequence, commit framing, colony and time. Types absent from
ReadOptions.Consume are skipped; a consumed type at an undeclared version stops
the reader with an *UnsupportedVersionError. With ReadOptions.AllTypes the
reader also returns the records of unconsumed types, for their envelope fields,
such as body_refs. Their versions are not checked, and their payloads are not
the consumer's to decode: a consumer decodes only the payloads of the type
versions it consumes, so that skipping an unknown type stays safe. Cursor
advances past every commit fully processed, skipped or returned, and stays at
the last one on any error, so a consumer may persist it.

A reader resuming after a cursor starts in the segment holding the next record
and first verifies the link from the last line of the segment before it.
Whole-log verification is Check's job.

Inside a running Core, ReadOptions.Through must be the writer's durable mark: a
complete but unacknowledged commit can be on disk while the writer waits for its
flush. ToEnd reads every complete commit on disk and applies the torn-tail rule;
it is for offline reading, and while a writer is live it may expose a commit the
writer has not acknowledged.

# Catalogue

A Catalogue lists the record type versions a writer may append. Defined
returns those this contract version defines: the four F0 record types below,
each at version 1. The type namespace "ledger." is reserved for F0 record types:
no other record family may use it. The namespace "fixture." is reserved for this
contract's golden fixtures and tests: no record family may use it, and Defined
never contains it.

# F0 record types

Core's ledger store produces the F0 record types. Each payload has a Go type
with an Encode method, which validates the value and emits compact JSON with
its keys in the order tabled below, and a Decode function. Their errors wrap
ErrInvalid. A decoder refuses a payload that is not a JSON object; a missing
required key, a key repeated at any depth, or a known key that is null; an ID
that is not a canonical lowercase UUIDv7; a digest that is not 64 lowercase
hex digits or is zero; an integer with a sign, fraction or exponent, or out of
range; and any value or ordering rule broken. Keys it does not know are ignored,
at the top level and inside the elements of bodies, so that a type version can
gain optional keys by addition. Encoding a decoded payload reproduces the bytes
that Encode produced.

Core's writer guarantees the record rules stated under each type: it refuses a
draft that would break one (see package appender), and, when it opens a log,
it fails closed on a record that breaks a rule the records themselves show.
Check, Reader and EncodeCommit do not apply them.

ledger.command v1 (Command) is the identity tombstone of D58: the record that
a command, named by its immutable command ID, was submitted. It carries no
request content; the command families (Core step C3) carry the request. Only
the digest is compared when a command ID is submitted again, so the caller's
submission_sha256 must cover everything that binds the request: its content,
its candidate and its context. Any binding the digest leaves out could change
under the same ID without the mismatch that D58 requires, which would make its
mismatch rule hollow.

    key                type    presence  rule
    command_id         UUIDv7  required  the caller's immutable command ID (D37)
    submission_sha256  digest  required  SHA-256 of the caller's canonical immutable submission bytes

Record rules: it is the record at commit_index 0 of the commit that holds the
command's effect, and a commit holds at most one; a log holds at most one record
per command_id; body_refs is absent. Only Core's store writes it, when a command
is submitted; the writer refuses it through Append.

ledger.body_pin v1 (BodyPin) pins the bodies its body_refs lists, so that
collection keeps them, until a ledger.body_unpin with the same pin_id.

    key     type    presence  rule
    pin_id  UUIDv7  required  names the pin; the pinned bodies are the record's body_refs

Record rules: body_refs is present, and every body it lists was published when
the record was written; pin_id was not active. A pin ID released earlier starts
a new pin.

ledger.body_unpin v1 (BodyUnpin) releases every body of an active pin.

    key     type    presence  rule
    pin_id  UUIDv7  required  an active pin

Record rules: body_refs is absent; pin_id was active.

ledger.bodies_collected v1 (BodiesCollected) is the unavailable-body history:
it records that an explicit collection, ordered by its actor under the policy
its payload states, made the bodies it lists unavailable.

    key         type              presence  rule
    before_ns   integer           required  the policy's age cutoff in event-time nanoseconds; above 0
    keep_bytes  integer           optional  the policy's byte target; above 0 when present
    bodies      array of objects  required  non-empty; strictly ascending by sha256

Each element of bodies is {"sha256": digest, "bytes": integer}: a collected
body's digest and its size, at least 0.

Record rules: body_refs is absent, because the bodies it lists are payload
values, not references; actor is owner or core. Only Core's store writes it,
during an explicit collection; the writer refuses it through Append. It lists
only bodies that an earlier record referenced and that no active pin held.

CONSTANTS

const (
	// MaxRecordBytes caps one encoded line: hash, TAB, JSON and LF.
	MaxRecordBytes = 1 << 20
	// MaxCommitBytes caps all lines of one commit.
	MaxCommitBytes = 16 << 20
)
const (
	TypeCommand         = "ledger.command"          // version 1
	TypeBodyPin         = "ledger.body_pin"         // version 1
	TypeBodyUnpin       = "ledger.body_unpin"       // version 1
	TypeBodiesCollected = "ledger.bodies_collected" // version 1
)
    The F0 record types, each at version 1. The package documentation specifies
    their payloads and record rules.

const FormatVersion = 1
    FormatVersion is the ledger format version that this package writes and
    reads.

const ToEnd = ^uint64(0)
    ToEnd as ReadOptions.Through reads every complete commit on disk. It is for
    offline reading: while a writer is live it may expose a commit the writer
    has not yet acknowledged.

const ZeroHash = "0000000000000000000000000000000000000000000000000000000000000000"
    ZeroHash is the prev_hash of the record with seq 1.


VARIABLES

var (
	// ErrInvalid marks a refusal by EncodeCommit, or an invalid argument to
	// Check or OpenReader. Nothing is written.
	ErrInvalid = errors.New("ledger: invalid record")
	// ErrTooLarge marks an EncodeCommit refusal for a line over
	// MaxRecordBytes or a commit over MaxCommitBytes.
	ErrTooLarge = errors.New("ledger: record or commit over cap")
	// ErrCorrupt marks a log that fails closed; see CorruptError.
	ErrCorrupt = errors.New("ledger: corrupt log")
	// ErrUnsupportedFormat marks a record whose format is not FormatVersion;
	// see UnsupportedFormatError.
	ErrUnsupportedFormat = errors.New("ledger: unsupported format version")
	// ErrUnsupportedVersion marks a consumed type at an undeclared version;
	// see UnsupportedVersionError.
	ErrUnsupportedVersion = errors.New("ledger: unsupported type version")
	// ErrCursor marks a reader bound that is not the end of a commit.
	ErrCursor = errors.New("ledger: cursor or bound not at a commit end")
)

FUNCTIONS

func ParseSegmentName(name string) (first uint64, ok bool)
    ParseSegmentName returns the first sequence that a segment file name names;
    it is the inverse of SegmentName. It returns false for a name that is not
    20 decimal digits followed by ".jsonl", or whose digits exceed the range of
    uint64.

func SegmentName(first uint64) string
    SegmentName returns the file name, within the log directory, of the segment
    whose first record has sequence first.


TYPES

type Actor string
    Actor is the kind of party a record is attributed to.

const (
	ActorOwner  Actor = "owner"
	ActorAgent  Actor = "agent"
	ActorCore   Actor = "core"
	ActorRunner Actor = "runner"
)
    The closed set of actors (D35). Adding one is a format change.

type BodiesCollected struct {
	BeforeNS  int64           `json:"before_ns"`           // above 0
	KeepBytes int64           `json:"keep_bytes,omitzero"` // 0 = absent
	Bodies    []CollectedBody `json:"bodies"`              // non-empty, strictly ascending by SHA256
}
    BodiesCollected is the payload of a ledger.bodies_collected v1 record.

func DecodeBodiesCollected(payload json.RawMessage) (BodiesCollected, error)
    DecodeBodiesCollected decodes a ledger.bodies_collected v1 payload.
    Its errors wrap ErrInvalid.

func (p BodiesCollected) Encode() (json.RawMessage, error)
    Encode returns p as a ledger.bodies_collected v1 payload, omitting
    keep_bytes when KeepBytes is 0. It refuses, with an error wrapping
    ErrInvalid, a BeforeNS below 1, a negative KeepBytes, an empty Bodies,
    and a body whose SHA256 is zero, whose Bytes is negative or whose SHA256 is
    not above the one before it.

type BodyPin struct {
	PinID uuid.UUID `json:"pin_id"` // a UUIDv7
}
    BodyPin is the payload of a ledger.body_pin v1 record. The pinned bodies are
    the record's BodyRefs.

func DecodeBodyPin(payload json.RawMessage) (BodyPin, error)
    DecodeBodyPin decodes a ledger.body_pin v1 payload. Its errors wrap
    ErrInvalid.

func (p BodyPin) Encode() (json.RawMessage, error)
    Encode returns p as a ledger.body_pin v1 payload. It refuses, with an error
    wrapping ErrInvalid, a PinID that is not a UUIDv7.

type BodyUnpin struct {
	PinID uuid.UUID `json:"pin_id"` // a UUIDv7
}
    BodyUnpin is the payload of a ledger.body_unpin v1 record.

func DecodeBodyUnpin(payload json.RawMessage) (BodyUnpin, error)
    DecodeBodyUnpin decodes a ledger.body_unpin v1 payload. Its errors wrap
    ErrInvalid.

func (p BodyUnpin) Encode() (json.RawMessage, error)
    Encode returns p as a ledger.body_unpin v1 payload. It refuses, with an
    error wrapping ErrInvalid, a PinID that is not a UUIDv7.

type Catalogue struct {
	// Has unexported fields.
}
    Catalogue is a set of record type versions that a writer may append.

func Defined() Catalogue
    Defined returns the record type versions this contract version defines, F0's
    catalogue: TypeCommand, TypeBodyPin, TypeBodyUnpin and TypeBodiesCollected,
    each at version 1. It never contains a type in the reserved fixture
    namespace.

func NewCatalogue(tvs ...TypeVersion) (Catalogue, error)
    NewCatalogue returns the catalogue of tvs. Every type must match the type
    grammar, every version must be at least 1, and no entry may repeat.

func (c Catalogue) Contains(tv TypeVersion) bool
    Contains reports whether tv is in the catalogue.

type Chain struct {
	Seq         uint64 // last sequence; 0 for an empty log
	Hash        string // last record's hash; ZeroHash for an empty log
	EventTimeNS int64  // last event time; 0 for an empty log
}
    Chain is the position after the last committed record.

func EncodeCommit(after Chain, h CommitHeader, drafts []Draft) ([]byte, Chain, error)
    EncodeCommit frames drafts as one commit continuing after. It assigns seq,
    prev_hash and the commit fields, and returns the commit's lines and the
    chain position after them. It refuses, with an error wrapping ErrInvalid,
    any commit a reader would reject, and, with an error wrapping ErrTooLarge,
    a line over MaxRecordBytes or a commit over MaxCommitBytes. It is a pure
    function.

func Genesis() Chain
    Genesis returns the chain position of an empty log.

type CheckResult struct {
	Last      Chain  // end of the last complete commit (Genesis() if none)
	Segment   string // final segment file name; "" if the log has no segments
	Size      int64  // bytes of complete commits in Segment
	TornBytes int64  // bytes after Size that form a torn final commit
}
    CheckResult reports where a verified log ends.

func Check(logDir string, colony uuid.UUID) (CheckResult, error)
    Check verifies the whole log in logDir, read-only, for colony and reports
    where it ends. It never writes, truncates or locks. It fails closed with
    a *CorruptError, or an *UnsupportedFormatError, on anything but complete,
    correctly hashed and chained commits in order followed by at most one torn
    final commit (see the package documentation).

type CollectedBody struct {
	SHA256 Digest `json:"sha256"` // not zero
	Bytes  int64  `json:"bytes"`  // at least 0
}
    CollectedBody is one body that a ledger.bodies_collected record lists.

type Command struct {
	CommandID        uuid.UUID `json:"command_id"`        // a UUIDv7
	SubmissionSHA256 Digest    `json:"submission_sha256"` // the digest of the whole binding
}
    Command is the payload of a ledger.command v1 record, the identity tombstone
    of one command. It carries no request content.

func DecodeCommand(payload json.RawMessage) (Command, error)
    DecodeCommand decodes a ledger.command v1 payload. Its errors wrap
    ErrInvalid.

func (p Command) Encode() (json.RawMessage, error)
    Encode returns p as a ledger.command v1 payload. It refuses, with an
    error wrapping ErrInvalid, a CommandID that is not a UUIDv7 and a zero
    SubmissionSHA256.

type Commit struct {
	ID      uuid.UUID
	First   uint64   // seq of the commit's first record
	Last    uint64   // seq of its last record
	Records []Record // its consumed records, or all with AllTypes, in seq order
}
    Commit is one complete commit as a Reader returns it.

type CommitHeader struct {
	ColonyID    uuid.UUID
	CommitID    uuid.UUID
	EventTimeNS int64
	ClockHeld   bool // the clock moved backwards and EventTimeNS is held at after's
}
    CommitHeader carries the fields the writer stamps once per commit.

type Consumption map[string][]int
    Consumption maps each consumed type to the type versions the reader decodes.

type CorruptError struct {
	Segment string
	Offset  int64
	Reason  string
}
    CorruptError locates a fail-closed finding. Segment is the file name in the
    log directory, or "" for the directory itself, and Offset is the byte offset
    in Segment where the finding begins. errors.Is(err, ErrCorrupt) holds.

func (e *CorruptError) Error() string

func (e *CorruptError) Unwrap() error

type Digest [sha256.Size]byte
    Digest is a SHA-256 digest. Its text form is 64 lowercase hex digits.
    The zero Digest means absent; no present value may be zero.

func ParseDigest(s string) (Digest, error)
    ParseDigest parses s as exactly 64 lowercase hex digits that are not all
    zero. Its errors wrap ErrInvalid.

func (d Digest) MarshalText() ([]byte, error)
    MarshalText returns d as 64 lowercase hex digits.

func (d Digest) String() string
    String returns d as 64 lowercase hex digits.

type Draft struct {
	Type               string
	TypeVersion        int
	Actor              Actor
	AgentID            uuid.UUID
	ExecutionSessionID uuid.UUID
	ContextID          uuid.UUID
	TurnID             uuid.UUID
	OperationID        uuid.UUID
	MeasurementPath    string
	BodyRefs           []Digest        // strictly ascending, none zero
	Payload            json.RawMessage // a JSON object
}
    Draft is what a producer supplies for one record. A zero ID, an empty
    MeasurementPath and an empty BodyRefs mean the field is absent.

type Envelope struct {
	Format      int
	Seq         uint64
	CommitID    uuid.UUID
	CommitIndex int
	CommitCount int
	PrevHash    string
	EventTimeNS int64
	ClockHeld   bool
	ColonyID    uuid.UUID
	Draft
}
    Envelope is a record's decoded envelope. ClockHeld is false when the key is
    absent.

type ReadOptions struct {
	Colony  uuid.UUID   // required; every record must carry it
	After   uint64      // last sequence already consumed; 0 = from the start
	Through uint64      // last sequence to read: the writer's durable mark, or ToEnd
	Consume Consumption // the consumed types; records of other types are skipped

	// AllTypes also returns the records of types absent from Consume, for
	// their envelope fields. Their versions are not checked, and their
	// payloads are not the consumer's to decode: a consumer decodes only the
	// payloads of the type versions it consumes. Types in Consume are still
	// version-checked.
	AllTypes bool
}
    ReadOptions bound and filter a Reader.

type Reader struct {
	// Has unexported fields.
}
    Reader returns the complete commits of a log in order, verifying every
    record it reads. It is read-only and not safe for concurrent use.

func OpenReader(logDir string, opts ReadOptions) (*Reader, error)
    OpenReader opens the log in logDir for reading after opts.After. It verifies
    the link into the segment holding opts.After+1 from the last line of the
    segment before it.

func (r *Reader) Close() error
    Close releases the open segment file. Next then fails with an error wrapping
    os.ErrClosed, unless it had already failed or reached the end.

func (r *Reader) Cursor() uint64
    Cursor returns the last sequence of the last commit fully processed, whether
    skipped or returned; before the first, it is After. A consumer may persist
    it as its next After.

func (r *Reader) Next() (Commit, error)
    Next returns the next commit with a consumed record, or with AllTypes the
    next commit. Commits with none are skipped, and Cursor still advances
    past them. It returns io.EOF after Through, or with ToEnd after the
    last complete commit; a torn final commit is not returned. It returns an
    *UnsupportedVersionError for a consumed type at an undeclared version,
    ErrCursor when After or Through falls inside a commit or After lies beyond
    the log, and ErrCorrupt when the log fails closed or ends before a numeric
    Through. Errors are final.

type Record struct {
	Envelope
	Hash string // lowercase hex SHA-256 of JSON
	JSON []byte // the exact stored JSON bytes
}
    Record is a verified record as stored. Payload is a sub-slice of JSON.

type TypeVersion struct {
	Type    string
	Version int
}
    TypeVersion names one version of a record type.

type UnsupportedFormatError struct {
	Segment string
	Offset  int64
	Format  int
}
    UnsupportedFormatError locates a correctly hashed record whose format is not
    FormatVersion. errors.Is(err, ErrUnsupportedFormat) holds.

func (e *UnsupportedFormatError) Error() string

func (e *UnsupportedFormatError) Unwrap() error

type UnsupportedVersionError struct {
	Seq       uint64
	Type      string
	Version   int
	Supported []int
}
    UnsupportedVersionError reports a record of a consumed type at a version the
    reader did not declare. errors.Is(err, ErrUnsupportedVersion) holds.

func (e *UnsupportedVersionError) Error() string

func (e *UnsupportedVersionError) Unwrap() error
```

### 2.2 `go doc -all ./contract/ledger/appender` at `95aa88d`

```text
package appender // import "github.com/Darius-PJ/dwarf-harness/contract/ledger/appender"

Package appender is the ledger-appender contract (D50): the restricted way
a producer adds records to one colony's ledger. Core's writer is its only
implementation. A caller supplies ledger.Draft values, which carry no sequence,
hash, time, colony or commit field; the writer assigns all of them, so a caller
can neither write ledger files nor choose sequences.

An Append is acknowledged only after its commit is completely written and
durably flushed. Otherwise it fails with an error that says what became of the
commit:

  - ErrRefused: the request is invalid or not allowed. Nothing was written,
    and the same request fails again. A refusal for size also matches
    ledger.ErrTooLarge.
  - ErrPoisoned: an earlier failure left the writer needing recovery. Nothing
    was written.
  - ErrUncertain: the commit may or may not survive, and the writer is now
    poisoned. The commit is not acknowledged. In-process recovery removes it;
    after a crash before that recovery, recovery at the next start keeps it if
    it is complete and valid. A caller that needs certainty looks the commit up
    after recovery.
  - ErrClosed: the writer is closed. Nothing was written.
  - the error of ctx: ctx ended while the call waited for the writer. Nothing
    was written. ctx bounds only that wait: once writing starts, the commit
    completes or fails whatever ctx does.

A draft's BodyRefs may name only bodies already published to the colony's body
store. The writer refuses, with ErrRefused, a draft that names an unpublished
body or breaks a rule of its record type, including the F0 types that only the
writer itself produces (ledger.command and ledger.bodies_collected).

The writer serializes commits and promises no fairness among waiting callers.
Priority for control commits (AC06) belongs to Core's concrete writer, as a
separate method or interface, so that this contract does not change for it.

This contract is a draft until its owner freeze (D40).

VARIABLES

var (
	// ErrRefused marks an Append that was not allowed. Nothing was written,
	// and the same request fails again.
	ErrRefused = errors.New("appender: append refused")
	// ErrPoisoned marks an Append refused because the writer needs recovery.
	// Nothing was written.
	ErrPoisoned = errors.New("appender: writer poisoned; recovery required")
	// ErrUncertain marks an Append whose commit may or may not survive. It is
	// not acknowledged, and the writer is now poisoned.
	ErrUncertain = errors.New("appender: commit outcome uncertain")
	// ErrClosed marks an Append to a closed writer. Nothing was written.
	ErrClosed = errors.New("appender: writer closed")
)

TYPES

type Appender interface {
	// Append commits drafts, in order, as one commit. It returns only after
	// the commit is completely written and durably flushed.
	Append(ctx context.Context, drafts []ledger.Draft) (Committed, error)
}
    Appender appends commits to one colony's ledger.

type Committed struct {
	First, Last uint64
}
    Committed is the sequence range of an acknowledged commit.
```

### 2.3 The F0 catalogue

F0 holds four C1 record types, each at version 1, which Core's ledger store produces. Their payloads and record rules are in the `contract/ledger` package doc (§2.1). The last column gives the sequence numbers of each type's records in the catalogue golden file (§2.4). No source defines a privacy-class vocabulary, so each entry describes what its records hold (question 10).

| Type, version 1 | Payload owner | Producer | Permitted appender caller | Consumers | Privacy class | Replay-essential fields | Golden sample |
|---|---|---|---|---|---|---|---|
| `ledger.command` | C1 | Core's store, in `Submit` | Core's store only; refused through `Append` | Core's command-ID index; C3's command and result producers; any replay consumer that needs command identity | identifiers and a digest; no submission content | `command_id`, `submission_sha256` and the sequence range of its commit | seq 3 |
| `ledger.body_pin` | C1 | Core's store, at a caller's request | `internal/core/...`, `internal/router/...` and `internal/undercurrent/graph/...`, through `Append` | Core's collection; C4's pins for finalization and failure obligations | identifiers and body digests; no content | `pin_id`, `body_refs` | seq 2 |
| `ledger.body_unpin` | C1 | Core's store, at a caller's request | as for `ledger.body_pin` | as for `ledger.body_pin` | identifiers only | `pin_id` | seq 6 |
| `ledger.bodies_collected` | C1 | Core's store, in `Collect` | Core's store only; refused through `Append` | Core's reads of unavailable bodies; C4's `artifact_unavailable`; any consumer that shows bodies | digests, sizes and policy values; no content | `bodies[].sha256`, `bodies[].bytes`, `before_ns`, `keep_bytes` | seqs 5 and 7 |

### 2.4 Golden files

| File | What it holds | SHA-256 |
|---|---|---|
| `contract/ledger/testdata/f0/log/00000000000000000001.jsonl` | seq 1–4 of the two-segment fixture log | `c72c4a739965586d984b524dbc6ee67a5b9d866756639fbb03b04e90f441f2e5` |
| `contract/ledger/testdata/f0/log/00000000000000000005.jsonl` | seq 5–6 of that log, after a segment rotation | `3ee9f566e69e9cccb89ed435afee322950d3084a69ed0301684c15be70f8e65b` |
| `contract/ledger/testdata/f0/catalogue/log/00000000000000000001.jsonl` | seq 1–7: all four F0 types, `body_refs`, a command at the head of its commit and two collections | `319c805312afd1abf824d306bcd799dd42bd3ae04fdf33fb74bc3f742ac8c898` |

The fixture log holds four commits of `fixture.sample` v1 and v2 and `fixture.other` v1: one- and two-record commits, absent and present optional fields, a held clock, two versions of one type and a rotation (B18). `TestGoldenF0` builds all three files with `EncodeCommit` and compares them byte for byte (V2), and Core's writer reproduces both logs. The two `f0/log` files are unchanged since ticket 02, which shows that adding `body_refs` changed no existing record.

### 2.5 Decision entries

- [B18](../../../docs/DECISIONS.md#b18-c1-ledger-format-v1-encoding-colony-store-and-os-adapter), ticket 02: the encoding of format v1, the colony store and the OS adapter.
- B21, ticket 03: body references, the F0 records, the body store and command identities, and the workload measurements. It is appended to `docs/DECISIONS.md` unchanged in the commit that closes ticket 03 after this request; Appendix C holds its final text.

## 3. Evidence

### 3.1 Checks

| | What it shows | Result |
|---|---|---|
| V1 | `go test ./contract/... ./internal/core/...` with `CGO_ENABLED=0`: every test passes, and the workload harness skips | Passed: `contract/ledger`, `internal/core/durable` and `internal/core/ledgerstore` ok; `contract/ledger/appender` has no test files (95aa88d, 2026-10-10) |
| V2 | `TestGoldenF0 -update` rewrites the goldens and `git status` shows no change: all three golden files are reproduced byte for byte | No change (95aa88d, 2026-10-10) |
| V3 | The fuzz targets `FuzzCheckTruncation`, `FuzzCheckTornTail` and `FuzzCheckCorruption`: no failure and no new corpus file | Passed: `FuzzCheckTruncation`, `FuzzCheckTornTail` and `FuzzCheckCorruption`, 120 s each; no new corpus file (95aa88d, 2026-10-10) |
| V4 | Six stress tests, 20 runs each: concurrent appends stay gapless; a killed writer releases its lock and keeps every acknowledged commit; the durable mark advances only after a flush; commands submitted around a crash are recorded once; old command IDs resolve as a model predicts; a collection sees references appended during its scan | 20 of 20 for each of the six tests, no failure (95aa88d, 2026-10-10) |
| V5 | `go run ./tools/check`: all nine steps, including the race tests and the Linux and macOS cross builds | All nine steps passed (95aa88d, 2026-10-10) |
| V6 | `go list`: `contract/...` imports only the standard library (and `contract/ledger` for the appender); only `internal/core/durable` imports `golang.org/x/sys` | As stated: `contract/ledger` imports only the standard library, its `uuid` package included; the appender adds only `contract/ledger`; only `internal/core/durable` imports `golang.org/x/sys/windows` (95aa88d, 2026-10-10) |
| V7 | `go mod tidy` leaves `go.mod` and `go.sum` unchanged: no dependency was added | No change (95aa88d, 2026-10-10) |
| V8 | `git ls-files --eol`: the three golden files are LF in the index and in the worktree | `i/lf w/lf` for all three (95aa88d, 2026-10-10) |

### 3.2 Platform status and limits

- **Verified on Windows, NTFS, on this machine** (Intel Core i7-10610U, Windows 10.0.19045.6456): the full check, the race tests, and the tests against the real operating system. A writer process killed mid-load releases its lock and loses no acknowledged commit; commands submitted around a crash are recorded once.
- **Not verified:** other file systems and network shares.
- **Linux and macOS** are compiled and vetted only (the check's cross builds; `go vet` for linux/amd64 and darwin/arm64) until C3's CI exists (D42).
- **No power-loss guarantee** (B3): the store relies on the file system and the device honouring their flushes.
- **Torn tails:** damage confined to the final commit, up to 16 MiB, cannot be told from an interrupted write until the latest hash is anchored externally (D36, assurance A3).
- **Test seams** serve deterministic regressions and prove no platform behaviour (B18).

### 3.3 Workload measurements

[Core Appendix A.10](../../../docs/DESIGN-CORE-AND-LAUNCHERS.md#a10-colony-ledger-and-body-store-c1-ticket-03) records the measurements: setup, the assumed model, one table per scenario group, and limits. Every figure is a measurement against an assumed workload on one Windows machine; none is a threshold, a pass mark or a capacity claim.

| Measure | Value | A.10 table |
|---|---|---|
| Cold `Open` of `12x7`, `20x7`, `60x7` and `20x30` | 75.4 s, 133 s, 431 s, 617 s for 2.43, 4.04, 12.1, 17.4 GiB of log; peak working set 38.5, 38.6, 91.4, 60.6 MiB | Recovery, cold |
| Warm `Open`, median of three, same colonies | 84.1 s, 139 s, 431 s, 610 s; peak working set 39.2, 39.4, 58.2, 58.5 MiB | Recovery, warm |
| One-record `Append`, one writer, p50 | 0.515 ms | Sequential appends |
| Steady load, arrival to acknowledgement, p50/p99, at 12, 20 and 60 contexts | 4.17/17.3 ms; 4.18/16.0 ms; 3.84/15.9 ms | Steady load |
| Burst drain, at 12, 20 and 60 contexts | 0.152 s; 0.252 s; 0.725 s | Burst |
| Commits per second with no waits, at 12, 20 and 60 contexts | 1,090; 976; 917 | Saturation |
| Failed publications and appends, by error | none | Body publication; Steady load; Burst; Saturation; Explicit collection |
| A first-day command looked up again: p50/max; segments scanned | 465/1,020 ms; 20 over 20 calls, one per call on average | Command-ID lookups |
| Longest append during an explicit collection | 677 ms | Explicit collection |
| Disk per context-hour of `60x1b`, log and bodies | 4.85 MiB | Generation |

Latencies below a few milliseconds are quantized to the clock's step on this machine (A.10, Limits).

### 3.4 Capacity reasoning (D78)

D78 asks for capacity reasoning before an affected boundary is frozen, with assumptions, calculations and measurements labelled apart ([`CONTRACTS.md`](../../../docs/CONTRACTS.md), D78 paragraph).

- **Assumption.** The workload model of A.10, which you confirmed at OG3: 60 contexts as the larger population, and each change running the 41-commit script twice ("Heavier: double the traffic"). Per context-hour: 492 commits, 960 records, 96 commands and 96 bodies of 3.61 MiB.
- **Calculation from the assumption.** 1.64, 2.73 and 8.20 commits a second at 12, 20 and 60 contexts; 43.3, 72.2 and 217 MiB of bodies an hour.
- **Measurement.** §3.3 and A.10.
- **Calculations from the measurements, not measurements themselves:**
  1. **Headroom** at saturation: 667, 357 and 112 at 12, 20 and 60 contexts. Each is the commit rate measured with no waits, over 60 s, divided by the model's rate. It compares one writer's serialized commits with the modelled rate on this machine. It is not accepted throughput under real producers, and no headroom target is set.
  2. **Disk.** At 60 contexts the log grows by about 1.73 GiB a day, and bodies by about 5.08 GiB a day before any collection. The log is never deleted or compacted (D36), so it grows without bound; no constant-space claim is made (Core §13.1).
  3. **Startup.** A cold `Open` of `60x7` took 431 s for 12.1 GiB of log. `Open` reads the whole log twice, once to verify it and once to rebuild its indexes, so its time grows with the log. At 35,500 ms per GiB, each day at 60 contexts adds about 62 s to a cold `Open` (61.6 s from the unrounded figures; 1.73 GiB × 35,500 ms per GiB), if the measured scaling holds (compare `20x7` with `20x30` in A.10). D34 names the remedy and leaves the trigger to you: snapshots or a SQLite index come only when startup replay time or index memory exceeds a budget you set. None is set.
  4. **Memory.** The live projections are bounded. `Open` of `60x7`, with the command index full at 65,536 commands, added 22.9 MiB of Go heap. Active pins are capped at 65,536 (pin, body) pairs. Only the segment catalogue and the collection index grow with history, by one entry per segment and per collection record.
- **What a freeze fixes.** The per-record framing: every record carries its hash, a TAB and the envelope keys, and in the model a record averages 1,348 bytes on disk, payload included. Every record read is verified, because each is hashed and chained (D35, D36) and readers check each one (B18). Snapshots and indexes are rebuildable acceleration outside the log (D34, B3), so adding them needs no format change. Changing a cap, adding compressed segments (which v1 readers do not recognise in `log/`) or renaming envelope keys would need your D40 decision entry after a freeze (B18).
- **Not claimed:** no budget, threshold, SLA or pass mark; no capacity claim; one machine; the model is an assumption.

## 4. Questions

Each question says what the freeze fixes and gives our recommendation. Questions 1–7 are the ones B18 promised for this request (B18, Limits), updated for ticket 03. You answer them all at once with an option in §5; to change a point, choose "Freeze with changes" and name its question.

### Q1. The F0 catalogue

F0 now holds four C1 record types at version 1: `ledger.command`, `ledger.body_pin`, `ledger.body_unpin` and `ledger.bodies_collected` (§2.3). Ticket 02 left F0 empty. Each type is fully specified and has a real C1 producer or consumer, so none is a placeholder (B2). The namespace `ledger.` is reserved for F0 types, and `fixture.` for this contract's fixtures and tests, which the catalogue never contains.

Each type's record rules are in the package doc. Core's writer refuses a draft that breaks one. When it opens a log, it fails closed on a record that breaks a rule the records themselves show:

- a `ledger.command` that is not the first record of its commit, or a second one in a commit;
- `body_refs` present on a command, unpin or collected record, or absent on a pin;
- a pin whose pin ID is already active, or an unpin of one that is not;
- a collected record whose actor is neither `owner` nor `core`;
- a command ID repeated while its earlier record is still in the in-memory index;
- a payload that does not decode.

A newer version of an F0 type stops `Open` with an unsupported-version error. Three stated rules cannot be checked when a log opens: that a pin's bodies were published when it was written, that a collected body was referenced by an earlier record, and that a command ID older than the in-memory index is not repeated. None of these can arise through the store's own writers, and opening never checks whether bodies are present.

**Recommendation:** freeze the catalogue, the two reserved namespaces and the record rules as presented.

### Q2. Envelope keys, order and encodings

A record is one line: the SHA-256 of its JSON in lowercase hex, a TAB, the JSON, and LF. The JSON's keys, in the order the writer emits them: `format`, `seq`, `commit_id`, `commit_index`, `commit_count`, `prev_hash`, `event_time_ns`, `clock_held`, `colony_id`, `type`, `type_version`, `actor`, `agent_id`, `execution_session_id`, `context_id`, `turn_id`, `operation_id`, `measurement_path`, `body_refs`, `payload`.

- `format` must come first, so that a record of a later format stops a reader with a clear error instead of failing as corruption.
- `body_refs` sits just before `payload`, which stays last.
- IDs are canonical lowercase UUIDv7 strings. Integers have no sign, fraction or exponent.
- `seq` and `event_time_ns` can exceed 2^53, so they are exact only for decoders that keep 64-bit integers. Every consumer is Go (D45).

**Recommendation:** freeze as presented.

### Q3. Commit marker

The record with `commit_index == commit_count-1` ends its commit (D35's mark). No separate flag exists that could disagree with the count, and the count also lets recovery recognise an incomplete commit.

**Recommendation:** freeze as presented.

### Q4. Caps

A line may hold at most 1 MiB, counting its hash, TAB and LF, and a commit at most 16 MiB; a line or commit of exactly the cap is accepted. `Check` and the reader fail closed on anything larger, which bounds a reader's memory to one commit. Changing either cap later breaks the format, because older readers reject larger records, so it needs your D40 decision entry. The 64 MiB segment target is writer policy, not a format rule.

**Recommendation:** freeze both caps at these values.

### Q5. Strictness of the envelope

- The actor set is closed: `owner`, `agent`, `core` and `runner`. Adding one is a format change.
- `measurement_path` is an optional token whose vocabulary each record family owns.
- Unknown keys are ignored, so optional keys can be added later. A missing optional field reads as absent, never as a guessed default.
- A repeated key, a `null` known key, a missing required key, a present but empty optional value, or `"clock_held":false` makes a record invalid.
- A payload may not repeat a key at any depth: `EncodeCommit` refuses one, and readers do not re-check payload interiors.

**Recommendation:** freeze as presented.

### Q6. The appender's errors

`Append` returns only after its commit is written and durably flushed. Otherwise it fails with one of these:

- `ErrRefused`: nothing was written, and the same request fails again. A size refusal also matches `ledger.ErrTooLarge`.
- `ErrPoisoned`: nothing was written; the writer needs recovery.
- `ErrUncertain`: the commit may or may not survive, and the writer is now poisoned.
- `ErrClosed`: nothing was written.
- the error of its context, which bounds only the wait for the writer.

"The same request fails again" means for the same store state: a refusal for an unpublished body or an inactive pin ends once the caller publishes the body or the pin's state changes, and the one refusal that depends on the clock, the command-ID time bound of Q9, is a store rule outside this contract.

The refusals include a draft that names an unpublished body, a draft that breaks a rule of its F0 type, and the types only Core's store writes, `ledger.command` and `ledger.bodies_collected`. The writer promises no fairness among waiting callers. Priority for control commits (AC06, ticket 28) goes on Core's writer as a separate method or interface, so this contract does not change for it.

**Recommendation:** freeze as presented.

### Q7. The reader's bound and its two additions

`Through` is explicit. Inside a running Core it is the writer's durable mark. `ToEnd` reads every complete commit on disk and applies the torn-tail rule; it is for offline reading, because beside a live writer it can expose a commit the writer has not acknowledged.

New in ticket 03:

- `ReadOptions.AllTypes` also returns the records of types the reader does not consume, for their envelope fields such as `body_refs`. Their versions are not checked, and their payloads are not the consumer's to decode, so skipping an unknown type stays safe. Consumed types are still version-checked.
- `ParseSegmentName` returns the first sequence that a segment file name names; it is the inverse of `SegmentName`.

**Recommendation:** freeze as presented.

### Q8. What `body_refs` means

`body_refs` is optional. When present, it is a non-empty, strictly ascending list of lowercase-hex SHA-256 digests, none of them zero: a canonical set. It lists the bodies in the colony's body store that the record references, and it holds the record's only body references:

- the writer refuses a reference to a body that is not published;
- collection treats a body as reachable only through these lists;
- hashes inside payloads, such as private-content hashes, check digests and Git object IDs, are not references;
- a family whose payload names a stored body must also list it in `body_refs`, and say so in its payload rules.

Records without references are byte for byte as ticket 02 wrote them.

**Recommendation:** freeze as presented.

### Q9. Command identities: what C1 settles of D58

D58 decided that the same request ID with the same immutable submission retrieves the original request, that a different submission under the same ID is a mismatch error, and that different IDs stay separate. It left open "Exact immutable submission fields and request/operation schema, ID issuance and retention, and result-delivery mechanics", adding: "These do not reopen the identity behavior selected here."

Ticket 03 settles the parts that belong to C1 (B21):

- **The tombstone record.** `ledger.command` v1 holds only `command_id` and `submission_sha256`, no request content. It is the first record of the commit that holds the command's effect. A commit holds at most one, and a log at most one per command ID. Only Core's store writes it, in `Submit`.
- **IDs and retention.** Command IDs are UUIDv7 (D37) and unique across the colony. A recorded ID resolves for the life of the log: an ID evicted from the bounded in-memory index is looked up in the log's segments, never treated as absent.
- **Comparison.** Only `submission_sha256` is compared. The same digest returns the original commit's sequence range and writes nothing, even if the request's records would now be refused. A different digest is refused as a mismatch. The caller's digest must therefore cover everything that binds the request: its content, candidate and context.
- **Issuance bound.** A command ID may be dated at most 5 minutes after the event time of the commit that records it. This is Core policy, outside the freeze; it may grow but never shrink. It is the one refusal that depends on time: nothing is written, so retrying later or minting a new ID is safe.

Left to C3: the canonical submission bytes and fields, the request and operation schema, result delivery, and who may retrieve a duplicate's state (D58: knowing an ID grants no access).

B21 changes no sentence of D58. A "See also: B21" line under D58 points to it, as B2's line does under D40. D58 lists these items as open and names Core C1 among its affected steps, so settling them touched no owner decision under D41.

**Recommendation:** accept these settlements, freeze `ledger.command` v1 as part of F0, and keep the 5-minute bound as Core policy.

### Q10. Privacy-class wording

B2 asks every catalogue entry for a privacy class, but no source defines a vocabulary. The F0 catalogue describes each entry's content instead, for example "identifiers and a digest; no submission content". You can accept descriptive text, or ask for a defined vocabulary that every family then uses.

**Recommendation:** accept the descriptive text now. The privacy class lives in the register, not in Go, so a vocabulary can replace it later without a format change.

### Q11. For information, not frozen: the body store and Core policy

These are rules of Core's store, `internal/core/ledgerstore`, not of any contract. Each can change without a format change. No answer is needed.

- **Layout and cap.** Bodies live in `bodies/<hh>/<64 lowercase hex>`, under 256 fan-out directories made when the colony is created; publications in progress live in `bodies/.tmp`. A body holds at most 64 MiB.
- **Publication.** A body is streamed to a temporary file, hashed under the cap, flushed and closed, then renamed into place and its directory flushed, all before any record may reference it (Core §13.1). On Windows, a program holding the temporary file, such as Defender's real-time scan or an indexer, can make the rename fail with a sharing violation. The error is returned, the store never retries, and the caller may. A.10 counts such failures by error: none.
- **Reads.** `ReadBody` verifies the whole body against its digest before returning it. For an absent body, it takes a snapshot of the collection index while it still holds the store's read lock, and classifies from that snapshot. A body that a collection record lists is unavailable, and the error names that record; any other absent body is missing. A collection that lands after the snapshot reads as missing for that call. The lock prefers waiting writers, so a 64 MiB read delays every publication and read queued behind it.
- **Collection.** Nothing is collected unless the owner or Core asks, with an explicit policy: an actor, an age cutoff and an optional byte target.
  - A body that an active pin holds is never collected.
  - A referenced body is eligible when its newest reference is older than the cutoff. Eligible bodies go oldest first, in batches of up to 256, and each batch's `ledger.bodies_collected` record is durable before any of its files is deleted.
  - A present body with no reference newer than its newest collection record is unreferenced since that collection. Like a body never referenced, it is deleted without a new record only when its file is older than the cutoff, so a body published again after a collection is protected until its reference lands.
  - With a byte target, collection stops once the bytes present fall to the target, counting every body file present, pinned and ineligible ones included.
- **Pins.** At most 65,536 active (pin, body) pairs. If this bound is lowered later, a log that holds more still opens; new pins are then refused while unpins still succeed.
- **Other values.** The in-memory command index holds 65,536 IDs; the issuance bound is 5 minutes; the segment target is 64 MiB.

## 5. Your answer: three options

1. **Freeze all three as presented.** `ledger-format` v1, with the four-type F0 catalogue and `body_refs`, `ledger-reader` v1 and `ledger-appender` v1 are frozen at commit `95aa88d` as Version 1. Your decision entry (Appendix A) and the register edit (Appendix B) are recorded as drafted, or as you edit them.
2. **Freeze with changes.** Name the changes, by question number. They go to a follow-up ticket. The contracts stay Draft until it lands, and the freeze is then recorded at its commit, with your changes.
3. **Not yet.** Nothing is frozen. C1 stays Done, and C2, U1, R1 and U3 keep waiting. You may say what is missing.

The question as sent in the question tool:

```text
C1 is Done. Under D40 I request the owner freeze of ledger-format v1 (with the four-type F0 catalogue and body_refs), ledger-reader v1 and ledger-appender v1, at commit 95aa88d of main. The packet is in your vault at dwarf-harness/.scratch/dwarf-harness/c1-evidence/og2-f0-freeze-packet.md: the surfaces (go doc of both packages, the F0 catalogue table, the three golden files and their digests), the evidence (V1–V8, the platform limits and Core Appendix A.10's measurements with D78's capacity reasoning), eleven questions with our recommendations, a draft decision entry and the register edit. Nothing is frozen until you answer and your decision entry is recorded. C1 does not wait for the answer; C2, U1, R1 and U3 do. Take the time you need.

Options: (1) Freeze all three as presented. (2) Freeze with changes: name them by question number; they go to a follow-up ticket, the contracts stay Draft until it lands, and the freeze is recorded at its commit. (3) Not yet: nothing is frozen, and you may say what is missing.
```

## Appendix A. Draft owner decision entry (not applied)

Written for option 1. For option 2 the entry is **Decided by:** modified, states your changes, and is recorded when the follow-up ticket lands, at its commit. For option 3 no entry is recorded.

```markdown
### D«D-NEXT». F0 ledger contracts frozen at version 1

- **Date:** «FREEZE-DATE». **Decided by:** adopted. In OG2, the F0 freeze request that ticket 03 sent on 2026-10-10, the owner picked "Freeze all three as presented" from the assistant's options.
- **Owner's words (question tool):**
  > Freeze all three as presented
- **Decision:** `ledger-format`, `ledger-reader` and `ledger-appender` are frozen at version 1, at commit 95aa88d (D40).
  - `ledger-format` v1 (`contract/ledger`): the record line, envelope, commit, hash-chain, cap and segment rules of B18 items 1–3; the optional envelope key `body_refs` (B21); and the F0 catalogue: `ledger.command`, `ledger.body_pin`, `ledger.body_unpin` and `ledger.bodies_collected`, each at version 1, with their payloads and record rules, the namespace `ledger.` reserved for F0 types and `fixture.` for contract fixtures.
  - `ledger-reader` v1 (`contract/ledger`): B18 item 4's reader and `Check`, with `ReadOptions.AllTypes` and `ParseSegmentName` (B21).
  - `ledger-appender` v1 (`contract/ledger/appender`): the `Appender` interface and its error taxonomy (B18 item 6), with the refusals of unpublished body references and of the store-owned types `ledger.command` and `ledger.bodies_collected` (B21).
  - The golden samples are `contract/ledger/testdata/f0/log/00000000000000000001.jsonl` (SHA-256 c72c4a739965586d984b524dbc6ee67a5b9d866756639fbb03b04e90f441f2e5), `contract/ledger/testdata/f0/log/00000000000000000005.jsonl` (3ee9f566e69e9cccb89ed435afee322950d3084a69ed0301684c15be70f8e65b) and `contract/ledger/testdata/f0/catalogue/log/00000000000000000001.jsonl` (319c805312afd1abf824d306bcd799dd42bd3ae04fdf33fb74bc3f742ac8c898).
- **Not frozen:** Core's store policy (the 64 MiB body cap, the body layout, the collection policy, the command-index and pin bounds, the 5-minute command-ID bound and the segment target); the privacy-class wording, which stays register text; and every later record family, which joins through its own additive catalogue freeze (B2).
- **Consequences:** these contracts now change only by addition: new optional fields, new types, and new type versions with upgraders. A breaking change needs an owner decision entry listing every step it affects (D40). C2, U1, R1 and U3 may build against the frozen contracts they consume once their other prerequisites are met: C2 still needs D52's approval, R1 needs R0, and U3's foundation needs C2.
- **Changes:** `CONTRACTS.md` (register version and status, status line, F0 catalogue lead-in); the status lines that say the freeze is requested (`ROADMAP-CORE.md` C1, `ROADMAPS.md`, Core, `ROADMAP-GUI.md` and the system specification); the open item in this log; ticket 03's comments.
```

## Appendix B. Draft register edit (not applied)

`CONTRACTS.md` says: "Record each freeze as a decision entry and update the version and status columns below." After the freeze, in `docs/CONTRACTS.md`:

1. **Register rows** `ledger-format`, `ledger-reader` and `ledger-appender`: Version `—` becomes `1`, and Status `Draft` becomes `Frozen`. The other cells are unchanged.
2. **Status line:** a new first entry,

   > «FREEZE-DATE» (the owner freezes `ledger-format`, `ledger-reader` and `ledger-appender` at version 1, D«D-NEXT»);

   and the sentence

   > `ledger-format`, `ledger-reader` and `ledger-appender` are *Draft*: their F0 freeze was requested on 2026-10-10 and is not granted. The other three contracts remain *Not started*; nothing is frozen.

   becomes

   > `ledger-format`, `ledger-reader` and `ledger-appender` are *Frozen* at version 1 (D«D-NEXT»); the other three contracts remain *Not started*.

3. **F0 catalogue:** its lead-in "**F0 catalogue (C1, Draft).**" becomes "**F0 catalogue (C1, frozen at version 1, D«D-NEXT»).**"

## Appendix C. B21 as it will be recorded

### B21. C1: body store, body references, F0 records and command identities

- **Date:** 2026-10-10. **Decided by:** assistant, within the owner's delegated build authority.
- **Question:** C1's ticket 03 completes C1. It publishes bodies before any record references them, collects them only under an explicit policy that keeps unavailable-body history, resolves old command identities after cache eviction, bounds live projections, measures the store and requests the F0 freeze. D33, D35–D38, D58, B2, B3 and Core §13.1 set these duties, and B18 left body references to this ticket. They do not say how a reference is encoded, which records F0 holds, how the body store is laid out and capped, how collection and old-ID lookup work, how far live projections are bounded, or which workload is measured. How does ticket 03 settle them?
- **Decision:**
  1. **Body references** (`contract/ledger`, `ledger-format`; D35, D36, B18 item 1).
     - `Digest` is a SHA-256 digest. Its text form is 64 lowercase hex digits, and the zero digest means absent. `ParseDigest` accepts exactly that form and refuses all zeros; its errors wrap `ErrInvalid`.
     - The envelope gains the optional key `body_refs` between `measurement_path` and `payload`, so `payload` stays last. Its value is a non-empty array of digest strings, strictly ascending and therefore distinct, none zero. `Draft.BodyRefs` carries it; nil and empty both mean absent and write no key. The field is `omitempty`, not `omitzero`, which would write `[]`, a value readers reject.
     - `EncodeCommit` refuses an unsorted, repeated or zero digest with `ErrInvalid`. Readers fail closed with `*CorruptError` on `[]`, `null`, a non-array, a non-string element, uppercase or short hex, a zero digest, and an unsorted or repeated list.
     - `body_refs` names the bodies in the colony's body store that the record references. They are the only references that publication checks and collection consider. A hash inside a payload, such as a private-content hash (D33), a check digest or a Git object ID (D36), is not one. A family whose payload names a stored body must also list it in `body_refs`, and say so in its payload rules, because readers do not check payload interiors.
     - A record without references encodes exactly as in ticket 02, and `testdata/f0/log` is unchanged, so the key is an additive draft change.
  2. **F0 catalogue** (`ledger-format`; B2, Core §13.1).
     - `Defined()` returns four C1 record types at version 1: `ledger.command`, `ledger.body_pin`, `ledger.body_unpin` and `ledger.bodies_collected`. The namespace `ledger.` is reserved for F0 types, as `fixture.` is for contract fixtures (B18 item 5).
     - Each payload has a Go type with an `Encode` method and a decoder. `Encode` validates the value and writes compact JSON with its keys in a fixed order. A decoder refuses, with an error wrapping `ErrInvalid`: a payload that is not an object; a missing required key, a key repeated at any depth, or a known key that is null; an ID that is not a canonical lowercase UUIDv7; a zero or non-canonical digest; an integer with a sign, fraction or exponent, or out of range; and any broken value or ordering rule. Unknown keys are ignored, at the top level and inside `bodies` elements, so that a type version can gain optional keys by addition. Encoding a decoded payload reproduces the bytes `Encode` wrote.
     - `ledger.command` v1 holds `command_id`, a UUIDv7, and `submission_sha256`, a digest. It is D58's identity tombstone (Core §13.1): the record that a command, named by its immutable ID, was submitted. It carries no request content; C3's command families carry the request. `submission_sha256` is the SHA-256 of the caller's canonical submission bytes, and it must cover everything that binds the request, its content, candidate and context (Core §13.2); otherwise D58's mismatch rule is hollow. Record rules: it has `commit_index` 0 in the commit that holds the command's effect; a commit holds at most one; a log holds at most one per `command_id`; `body_refs` is absent. Only Core's store writes it, through `Submit`.
     - `ledger.body_pin` v1 holds `pin_id`, a UUIDv7, and pins the bodies its `body_refs` lists. Record rules: `body_refs` is present, and every body it lists was published when the record was written; `pin_id` was not active. A pin ID released earlier starts a new pin.
     - `ledger.body_unpin` v1 holds `pin_id` and releases every body of that pin. Record rules: `body_refs` is absent; `pin_id` was active.
     - `ledger.bodies_collected` v1 is the unavailable-body history. It holds `before_ns`, the policy's cutoff, above 0; `keep_bytes`, the policy's byte target, optional and above 0; and `bodies`, a non-empty array of `{"sha256": digest, "bytes": integer}` objects, strictly ascending by digest, with `bytes` at least 0. Record rules: `body_refs` is absent, because its bodies are payload values, not references; the actor is `owner` or `core`; it lists only bodies that an earlier record referenced and that no active pin held. Only Core's store writes it, during an explicit collection.
     - The contract states each record rule under its type. Its code checks payloads (`Encode` and the decoders) and canonical `body_refs` (`EncodeCommit` and the reader). `Check`, `Reader` and `EncodeCommit` do not apply the record rules, and no exported helper does. Core's store refuses a draft that breaks one and, when it opens a log, fails closed on a record that breaks a rule the records themselves show (item 10).
     - The catalogue golden, `contract/ledger/testdata/f0/catalogue/log/00000000000000000001.jsonl`, is one LF-only segment (B1) of seven records in six commits. It holds every F0 type version, references on fixture, pin and command-commit records, a command commit with an effect, both states of `keep_bytes`, a pin release and two collections. `TestGoldenF0` builds it with `EncodeCommit` and the F0 encoders and compares it byte for byte. Its two collection records are exactly what `Collect` chooses. At seq 5 only B1 qualifies: B2 is pinned, and B3's newest reference is after the cutoff. At seq 7, with `keep_bytes` 20, B2 alone is taken, which leaves 18 bytes.
     - The register attributes that B2 requires live in `CONTRACTS.md`'s F0 catalogue table, not in Go. No source defines a privacy-class vocabulary, so each entry describes its class in words, such as "identifiers and a digest; no submission content", and OG2 asks the owner whether to keep that or define a vocabulary.
  3. **Reader and appender** (`ledger-reader`, `ledger-appender`; D35, D50).
     - With `ReadOptions.AllTypes`, the reader also returns records of types absent from `Consume`, for their envelope fields such as `body_refs`. Their versions are not checked, and their payloads are not the consumer's to decode, so skipping an unknown type stays safe (D35). Types in `Consume` are still version-checked.
     - `ParseSegmentName` exports the segment-name parser, beside `SegmentName`. Nothing else in B18's reader changes.
     - The appender's package doc gains one paragraph: a draft's `BodyRefs` may name only bodies already published to the colony's body store, and the writer refuses, with `ErrRefused`, a draft that names an unpublished body or breaks a rule of its record type, including the F0 types that only the writer produces (`ledger.command`, `ledger.bodies_collected`). The interface and B18's error taxonomy are unchanged.
  4. **Body store and publication** (`internal/core/ledgerstore`; D36, D38, B3, Core §13.1).
     - A body is the file `bodies/<hh>/<64 lowercase hex>`, mode 0o600, named by its SHA-256 and placed in the fan-out directory named by its first two hex digits. `Create` makes `bodies/.tmp` and all 256 fan-out directories. Names beginning with a dot are ignored in `bodies/` and in each fan-out directory. Any other entry the store did not put there, including a digest name under the wrong `<hh>` and an entry that is not a regular file, fails closed with `ErrBodyStore` wherever the store lists the directory. A body file is never renamed or rewritten once published, and only `Collect` deletes it.
     - `MaxBodyBytes` is 64 MiB. It is provisional Core policy, not a format rule, because no ledger reader reads bodies.
     - `PublishBody(ctx, r)` copies `r` in 1 MiB chunks to a temporary file in `bodies/.tmp`, hashing and counting as it writes, and refuses a body over the cap with `ErrBodyTooLarge`. It then flushes and closes the file. Under the body store's write lock it either keeps an existing body, flushing that body's directory again, or publishes the file with `durable.Rename`, which flushes the target's directory. After a failed rename it removes any target left behind. It returns the digest and size only after the bytes and the name are flushed, and a failed call leaves no file at the target.
     - A body is immutable, so publishing it again writes nothing. That does not refresh a referenced body's age, because collection ages a referenced body by its newest reference.
     - On Windows, a handle that another program holds on the temporary file, such as Defender's real-time scanner, which B3 keeps on, or an indexer, can fail the rename with a sharing violation. `PublishBody` returns that error. The store never retries; the caller may.
     - One `sync.RWMutex` orders the body store, always taken after the writer turn. Reads and reference checks share it; a publication's final step, each collection batch and `Close` take it alone. On Windows a file open for reading cannot be removed or replaced, and on Linux and macOS a renamed file is visible before its directory is flushed, so neither a deletion nor a reference check meets a read or a publication in progress. The mutex prefers a waiting writer: while a large `ReadBody` runs, a waiting publication or collection batch holds back every later read and publication.
     - `PublishBody` and `ReadBody` do not take the writer turn, so they keep working while the store is poisoned.
  5. **Verified reads** (Core §13.1; the system specification's user story 5).
     - `ReadBody(ctx, d)` returns a body only after verifying all of it against its digest. A mismatch, or a file over the cap, returns `ErrBodyCorrupt`. Memory is at most one capped body.
     - An absent body is classified from the `ledger.bodies_collected` records. If one lists it, the result is `*BodyUnavailableError{Digest, Seq}`, matching `ErrBodyUnavailable`, with the sequence of the newest such record. If none does, the result is `ErrBodyMissing`, which fails closed.
     - `ReadBody` takes a snapshot of the collection index while it holds the read lock, and classifies from that snapshot after releasing it. A collection that lands after the snapshot reads as missing for that call.
     - The collection index keeps one commit end per commit that holds a collection record, and the classification reads each segment only up to the newest such end in it. That `Collect` writes its record as a one-record commit is store-internal, not a record rule. The classification lists the log directory itself; it does not use the segment catalogue, which only the writer turn may touch.
     - A body that a collection record lists but whose deletion failed is still served, verified. Authorizing a read is the caller's, C3's.
  6. **Reference checks and pins** (Core §13.1, §13.3).
     - `Append` and `Submit` check every distinct digest in their drafts' `body_refs` under the writer turn and the read lock, after the catalogue check and before any time is stamped. A regular file passes. An absent body is refused with `ErrRefused` and `ErrBodyUnpublished`, naming the digest; an entry that is not a regular file is refused wrapping `ErrBodyStore`; any other error is refused wrapping it. The check is for existence only: publication hashed the body, and every read verifies it.
     - Collection holds the writer turn while it records and deletes, so no body disappears between the check and the commit. A body collected after its producer published it, but before the producer's `Append`, is refused; the producer publishes it again and retries.
     - `Append` refuses `ledger.command` and `ledger.bodies_collected` drafts. It checks pins in draft order: a pin must decode, list bodies and use a pin ID not active at that point; an unpin must decode, list no bodies and name a pin active at that point. A commit may therefore pin and unpin one ID, or release and pin it again.
     - Any appender caller sets pins through `Append`, for example for an active finalization or failure obligation (Core §13.3) or for an owner's hold. Who may release whose pin is C3's.
     - The store keeps the active pins in memory, bounded at 65,536 (pin, body) pairs. `Append` refuses a commit holding a pin that would pass the bound, and always accepts unpins. The projections change only after the flush, so a commit that ends in `ErrUncertain` changes none.
  7. **Explicit collection** (Core §13.1, §13.3).
     - `Collect(ctx, CollectPolicy{Actor, BeforeNS, KeepBytes})` runs only when a caller orders it; the store never collects on its own. Having done nothing, it refuses with `ErrRefused` an actor other than `owner` or `core`, a `BeforeNS` of 0 or less, a negative `KeepBytes`, and a store whose catalogue lacks `ledger.bodies_collected` v1.
     - A present body is eligible when no active pin holds it and one of two cases applies. Either a record references it after the newest collection record that lists it, and that newest reference's event time is before `BeforeNS`; such a body is recorded. Or no record does, and its file's modification time is before `BeforeNS`; such a body, never referenced or unreferenced since its collection, is deleted without a record. A real leftover of a failed deletion has an old modification time, so it is still removed; a fresh republication is protected until its reference lands.
     - Eligible bodies are taken oldest first by that time, then by digest, so the choice is deterministic. With `KeepBytes` above 0, `Collect` stops once present bytes are at most `KeepBytes`. Present bytes are the sizes of every body file in `bodies/` when `Collect` lists it, pinned and ineligible bodies included, less those it deletes.
     - A scan outside the writer turn lists the store and reads the log with `AllTypes`. Batches of at most 256 bodies then each take the writer turn and the write lock, re-read the records appended since the last look, append and flush one `ledger.bodies_collected` record listing the batch's recorded bodies with their sizes, and only then delete the files and flush their directories. A failure to write the record poisons the store, returns `ErrUncertain` and deletes nothing. A recorded body whose deletion fails is a leftover: reads still serve it verified, and a later `Collect` deletes it without a new record.
     - `CollectReport` counts separately the recorded bodies, the bodies deleted without a record that no collection record lists (`Unreferenced`), new leftovers, and earlier leftovers deleted (`LeftoversDeleted`), and gives the records appended and the present bytes at the end.
  8. **Command identities** (D37, D58, B3, Core §13.1–§13.2).
     - `Submit(ctx, command, drafts)` writes a `ledger.command` v1 draft and the drafts of the command's effect as one commit, the command first, and returns `Receipt{Committed, Duplicate}`. It is a store method outside `appender.Appender`, as B18 placed AC06 priority outside it.
     - Before it waits for the writer turn, `Submit` refuses with `ErrRefused` a command draft that is not `ledger.command` v1, that carries `body_refs` or whose payload does not decode, and a store whose catalogue lacks `ledger.command` v1.
     - Under the turn it looks the command ID up before it validates any draft. The same digest returns the original commit's range with `Duplicate` set and writes nothing, even if the drafts would now be refused, for example because a body they name was collected since. Another digest is refused with `ErrRefused` and `ErrCommandMismatch`. Only `submission_sha256` is compared.
     - Command IDs are UUIDv7 (D37), issued by the caller and unique in the colony. A recorded ID resolves for the life of the log, which is never compacted (D36): there is no expiry and no staleness bound.
     - `Submit` refuses with `ErrRefused` and `ErrCommandTime` an ID whose 48-bit millisecond timestamp is later than the commit's event time plus `commandLead`, rounded down to the millisecond. The event time is the one the commit would be stamped with, a held time included, and the arithmetic cannot overflow. `commandLead` is 5 minutes; it is Core policy, not format, and may only grow. `ErrCommandTime` is the one refusal that depends on the clock: nothing was written, so a later retry, or a fresh ID, is safe.
     - A hot index holds the newest 65,536 command IDs in sequence order and evicts the oldest. Each eviction moves a cold horizon to the evicted command's commit end and event time. Eviction is never proof of absence (Core §13.1, B3).
     - An ID that the hot index lacks is absent if nothing was evicted. It is also absent, without a read, if it is dated after the cold horizon's time plus `commandLead`, because event times never decrease and every recorded ID is dated at most `commandLead` after its commit. Otherwise the store reads, oldest first, each segment up to the cold horizon whose range of command-ID timestamps holds the ID, consuming `ledger.command` v1, and stops at the first match.
     - The segments are authoritative; the in-memory segment catalogue only says which of them can hold an ID. It gains an entry at a segment's first commit unless `Open` listed the segment, which covers a segment that `Recover` made current.
     - The lookup runs under the writer turn, so lookup and append are atomic, and an ended `ctx` stops it with nothing written. A command record that a lookup cannot decode means the log changed under the store: the lookup fails with `ErrInconsistent` and writes nothing.
  9. **D58 in C1** (D58; Core §13.1–§13.2).
     - Settled here, for C1: the `ledger.command` tombstone and its place at the head of the effect's commit; caller-issued UUIDv7 command IDs, unique in the colony, that never expire; comparison by digest only; and the 5-minute future bound, which is Core policy and not frozen.
     - Left to C3: the canonical submission bytes and fields, the request/operation schema, result delivery, and authorizing a duplicate's retrieval (D58: knowing an ID grants no access).
     - This entry edits no sentence of D58. A "See also" line under D58 points here, as D40's line points to B2, and OG2 shows these settlements to the owner.
  10. **Opening, rebuilding and bounds** (D34, B3, Core §13.1).
      - `Create` makes `log/`, `bodies/`, `bodies/.tmp` and the fan-out directories, reusing empty ones that an interrupted `Create` left. It refuses with `ErrBodyStore` a `bodies/` that holds a body file, an unexpected entry or a file with a fan-out name. It flushes `bodies/` and the colony directory before it publishes `colony.json`, so a crash leaves no colony or a complete one.
      - `Open` fails closed on a missing `bodies/`, with an error matching `fs.ErrNotExist`; it creates nothing and releases the lock. After B18's `Check` it empties `bodies/.tmp`, then truncates a torn final commit and flushes. A log that `Check` rejects keeps every byte, `.tmp` included.
      - `Open` then reads the log once more, consuming the four F0 types at version 1, and rebuilds the active pins, the collection index, the hot index and the segment catalogue. The hot index evicts during the rebuild too, so its memory stays bounded.
      - The rebuild fails closed with `ErrInconsistent`, naming the record's sequence, on every record rule the records themselves show: a payload that does not decode; a pin that lists no body or whose ID is active; an unpin that lists bodies or whose ID is not active; a collection record with `body_refs` or with an actor other than `owner` or `core`; and a `ledger.command` that is not first in its commit (so a second one in a commit is caught), that has `body_refs`, or that repeats an ID still in the hot index. A newer F0 version stops it with `*ledger.UnsupportedVersionError`. A log the rebuild rejects has been checked and has lost its torn tail and its temporary files, and is otherwise unchanged; the lock is released.
      - Three stated rules are not visible at open: that a pin's bodies were published when it was written, that a collected body was referenced by an earlier record, and that an ID older than the hot window appears only once. The store's own writers cannot break them. The rebuild never checks that bodies are present; reads do.
      - `Open` never fails because a valid log holds more active (pin, body) pairs than the bound: it loads them all, and `Append` then refuses new pins and accepts unpins. The rebuild applies the same pin rules as `Append`, without the bound. The hot index degrades by eviction.
      - Live projections and their bounds: the hot index, 65,536 IDs; the active pins, 65,536 pairs; the segment catalogue, one entry per segment file; the collection index, one commit end per collection commit; a collection's working set, one entry per present body while one `Collect` runs; and one commit of at most 16 MiB per open reader. The hot index, the segment catalogue and the pins change only under the writer turn. The segment catalogue and the collection index grow slowly with history; no constant-memory claim is made (B3).
      - Core policy values, which the owner may change without a format change: `MaxBodyBytes`, 64 MiB; the hot index, 65,536 IDs; the pin bound, 65,536 pairs; collection batches of 256 bodies; `commandLead`, 5 minutes, which may only grow; and B18's 64 MiB segment target. Tests lower all of them except `commandLead`, a constant, through unexported seams.
  11. **Close** (B18 item 6).
      - `Close` takes the writer turn and the write lock, marks the store closed and releases the write lock. It then waits for publications, for body reads with their classification, and for the log scan that begins a collection. Only then does it close the segment and release the colony lock. Afterwards the store holds no file in the colony directory.
      - Each of those operations notices `Close` between chunks, segments or commits and stops with `appender.ErrClosed`; a publication removes its temporary file. Collection batches are not waited for: they hold the writer turn, which excludes `Close`. A lock-free copy of the closed flag serves only to stop early. A `Read` on a publication's source that never returns delays `Close`, so a host cancels its producers' contexts first.
  12. **Tests and verification** (D42).
      - `contract/ledger`: `TestGoldenF0` and `TestGoldenDecodes` over both golden logs; `TestNewCatalogue`; `TestF0PayloadsRoundTrip`; `TestF0PayloadsRefuse`; `TestEncodeCommitRefuses`; `TestCheckFailsClosed`, with each `body_refs` defect located by `Segment` and `Offset`; `TestReaderAllTypes`; and `FuzzCheckTruncation`, which now also cuts the catalogue segment at every commit boundary and its neighbours.
      - `internal/core/ledgerstore`, bodies and collection: `TestPublishBodyRoundTrip`, `TestPublishBodyFailsWithoutDurability`, `TestReadBodyVerifies`, `TestReadBodyClassifiesFromSnapshot`, `TestAppendRefusesUnpublishedBodies`, `TestF0TypeRules`, `TestOpenBodiesLayout`, `TestOpenRebuildsPinsAndCollections`, `TestCollectRespectsPinsAndHistory`, `TestCollectKeepBytesOldestFirst`, `TestCollectSeesReferencesAddedDuringScan`, `TestCollectLeftoverRetried`, `TestCollectKeepsFreshRepublication` and `TestCollectRecordFailureDeletesNothing`. `TestBodiesConcurrentUse` runs publications, reads, appends and submissions with references, collection and `Close` together under `-race`, and checks that `Close` waits for a read and for a publication in flight.
      - Command identities and opening: `TestSubmitDeduplicates`, `TestSubmitDuplicateIgnoresCurrentDrafts`, `TestSubmitRefusesFutureCommandID`, `TestIssueLimitMS`, `TestOldCommandResolvesAfterEviction`, `TestSubmitLookupHonoursCtx`, `TestSubmitFailsClosedOnAnUndecodableCommandRecord`, `TestFreshCommandIDsStayOffTheDisk`, `TestCommandLookupMatchesModel` (2,000 seeded operations against a reference model, about 7 s a run), `TestSubmitFailureLeavesNoIdentity`, `TestSubmitFindsCommandsOfSegmentsRecoverMadeCurrent` and `TestOpenFailsClosedOnF0RuleViolation` (16 rule breaks, 4 newer versions and a control log). `TestDuplicateCommandsAfterCrash` kills a submitting child process and finds every acknowledged ID a duplicate with its range, and one `ledger.command` per ID in the log.
      - Extended: `TestAppendFailurePoisonsUntilRecover` shows publication and reads working while the store is poisoned, and `TestWriterReproducesGolden` has Core's writer reproduce the catalogue golden through `PublishBody`, `Append`, `Submit` and `Collect`.
      - The new seams, `deps.maxBodyBytes`, `maxPinned`, `hotCommands`, `collectBatch`, `afterCollectScan` and `beforeClassify` and the file seams `createTemp`, `rename`, `remove` and `openBody`, serve deterministic regressions only and prove no platform behaviour (B18 item 8). `TestWorkload` is a measurement harness, not a regression test (item 13).
      - Each slice passed the check's nine steps and was reviewed on evidence from a detached worktree of its commit before the rebase. S1, 9f1dea2: 173 tests and subtests passed, and each fuzz target ran 120 s with no failure and no new corpus file; `contract/ledger` changed afterwards only in comments. S2, 413b767: 202 passed. Its fix-up, 6739c56: 204 passed; `TestBodiesConcurrentUse` and `TestReadBodyClassifiesFromSnapshot` ran 10 times under `-race`, and the S2 set 20 times. S3, 66102ae: 248 passed and 2 skipped; the six stress tests ran 20 times each; `TestBodiesConcurrentUse`, `TestReadBodyClassifiesFromSnapshot` and `TestSubmitDeduplicates` ran 5 times under `-race`; the goldens regenerated byte-identically; `go mod tidy` changed nothing; linux and darwin vet passed.
      - On 09c1e03, the commit that reached `main`, the check passed all nine steps; `TestConcurrentAppendsAreGapless`, `TestKilledWriterReleasesLockAndRecovers`, `TestDurableAdvancesOnlyAfterSync`, `TestDuplicateCommandsAfterCrash`, `TestCommandLookupMatchesModel` and `TestCollectSeesReferencesAddedDuringScan` each passed 20 times; the goldens regenerated byte-identically; `go mod tidy` changed nothing and `go mod verify` passed. On e635395 (S4) the check passed all nine steps, linux and darwin vet passed, the smoke run covered every scenario group at 12, 20 and 60 contexts in 35 result lines, and `TestWorkload` skipped in ordinary and `-race` runs. The two killed-child tests run on Windows and NTFS only.
  13. **Workload model and harness** (D78; Core §13.1; the Core roadmap's C1 exit criterion).
      - The sources fix only promotion rates, 72 and 120 changes an hour at 12 and 20 contexts (D78), and bursts of 48 and 80 requests. They give no ledger rates, no record or body sizes and no larger workload. The model below is therefore an assumption, and every result is labelled as a measurement against it.
      - Each context makes 6 changes an hour. Each change runs a fixed 41-commit script twice (`scriptRepeats` = 2, after the owner's OG3 answer): per change, 82 commits, 160 records, 16 commands and 16 bodies totalling 616 KiB; per context-hour, 492 commits, 960 records, 96 commands and 96 bodies (3.61 MiB). Each script run submits one request, five messages and two other commands; publishes a 32 KiB diff, two 128 KiB run logs and five 4 KiB message bodies; and pins the run logs, then releases them. Plain records are `fixture.sample` v1 with seeded payloads of 128 B (70%), 1 KiB (25%) and 8 KiB (5%). A burst releases 4 × contexts requests at once, each publishing a 32 KiB body. The runs use 12, 20 and 60 contexts; 60 is the owner's declared larger workload.
      - The harness is `TestWorkload` in `internal/core/ledgerstore`, in test files only. It skips unless `DWARF_LEDGER_WORKLOAD_OUT` names a results file, and under `-race`; outside its smoke mode it requires a colony directory outside the repository. Each run is a child process that re-executes the test binary, and the parent appends one JSON line per run, which carries `scriptRepeats` and the assumed-workload label. The groups are `generate`, `recover` (cold and warm), `append` (sequential, steady, burst and saturation), `bodies`, `crash`, `dedup` and `collect`. Latencies are nearest-rank percentiles with the maximum, and results are also kept per unit, so a replaced model rescales without a rerun.
      - Peak memory comes from `K32GetProcessMemoryInfo` on Windows and `Getrusage` on Linux and macOS, through the standard `syscall` package. No dependency is added, and x/sys stays in `internal/core/durable` (D29, B3).
      - Cold is a colony's first access after one machine restart. Warm is `Check` and then three `Open`s, reporting the median. The operator labels the cache, because the harness cannot observe it. The append runs use fresh colonies.
      - Publication failures are counted by error, with the operating system's error number, and no call is repeated, so item 4's Windows sharing-violation risk is measured, not assumed.
      - The test fails only on a broken store invariant: a fatal store error, a log that lacks acknowledged records, an acknowledged commit that `Open` drops, a dedup case that ends otherwise than defined, a misclassified collected body, or a generator that disagrees with the model. It applies no threshold.
  14. **Measurements** (D78; Core Appendix A.10). The harness ran at e635395 on one machine: an Intel Core i7-10610U (4 cores, 8 threads) with 16,760,946,688 bytes of RAM, Windows 10.0.19045.6456 on NTFS, go1.27.2, Defender real-time protection on and SysMain running. Core Appendix A.10 records the setup, the model and one table per scenario group; the raw results are `.scratch/dwarf-harness/c1-evidence/ticket-03-workload-results.jsonl`. Measured: a cold `Open` of `60x7`, 12.1 GiB of log on a machine with 15.6 GiB of RAM, took 431 s with a peak working set of 91.4 MiB, and a warm one 431 s with 58.2 MiB. Under the steady load an `Append`, which returns once its commit is durable, took 3.24/4.93 ms (p50/p99) at 12 contexts, 3.21/4.89 ms at 20 and 2.67/4.87 ms at 60, and bursts of 48, 80 and 240 requests drained in 0.152, 0.252 and 0.725 s. Looking up a first-day command again in `20x7` took 465 ms (p50; max 1,020 ms) and scanned one segment per call on average, the longest append during an explicit collection took 677 ms, and `60x1b` used 4.85 MiB of disk per context-hour, log and bodies together. Publication failures counted by error: none. These are measurements on one machine against an assumed workload: they set no threshold, pass nothing and claim no capacity.
  15. **Landing, status and the freeze request** (D40, D41; the Core roadmap's C1).
      - S1–S3 reached `main` together, because a `main` with F0 types in `Defined()` but no store enforcement would be inconsistent; S4 followed. No frozen contract, owner decision or dependency was touched, so `main` moved after the reviews and the check without an owner sign-off (D41).
      - OG2, the D40 freeze request for `ledger-format` v1 with the four-type F0 catalogue and `body_refs`, `ledger-reader` v1 with `AllTypes` and `ParseSegmentName`, and `ledger-appender` v1, was sent to the owner on 2026-10-10 as one question-tool request. It is not awaited: C1 ends with the request. Its packet embeds this entry, so the owner sees items 5, 7 and 10 as worded here and item 9's settlements.
      - Nothing is frozen: the three contracts stay Draft, version —. C1 is Done, marked "F0 freeze requested 2026-10-10, not granted; no contract frozen", in `ROADMAP-CORE.md` and `ROADMAPS.md` in one commit.
- **Owner answers:** OG3, answered in the question tool on 2026-10-09. N is the owner's deployment fact and the restart is on his machine, so these answers are his, not part of this assistant decision. Owner's words:
  - the actual larger enrolled population: "60";
  - the per-context ledger model: "Heavier: double the traffic";
  - one machine restart for the cold runs: "Yes, ask me when ready";
  - the restart itself, asked once the colonies were generated and answered on 2026-10-09: "Restart now".
- **Reasons:**
  - Each item applies D29, D33–D38, D40–D42, D50, D58, D59, D78, B2, B3, B18 and Core §13.1–§13.3, or settles a detail they leave open.
  - **References.** A canonical set gives each meaning one byte form, as the format already requires. A body's size is a store fact, and history records it where it matters, in `ledger.bodies_collected`. B18 reserved an optional key with a fixed position, and the unchanged `f0/log` shows that adding it rewrote no record.
  - **Records.** Each F0 type has a C1 producer or consumer (`Submit`, `Collect`, `Append`'s checks and the pin projection) and a fully specified payload, so none is a placeholder (B2). Command identity as envelope keys would put a C3 concern into every record, and one generic record type would mix three meanings, against D35's typed events. Pins as records survive restarts, show in history and give owner holds a home. A separate pins file would be a second authority store, which ticket 03 forbids, and a predicate passed to `Collect` would make every caller remember every producer's pins. Because a pin is a reference, enforcement and reachability need no second path. The one-record commit is how `Collect` packages its record, not what the record means, so making it a rule would put a meaningless constraint into the F0 freeze. Keeping record-rule enforcement in the store keeps the frozen API narrow.
  - **Store.** Fan-out keeps directories small for listing and for Defender, and making all 256 at `Create` takes a directory flush out of every publication. D36 fixes SHA-256 for bodies, so a name prefix would add nothing. The 64 MiB cap equals the segment target, the largest file Core already writes, and bounds a read to one body. Renaming onto an existing body would fail on Windows while a reader holds it, because Go opens files without `FILE_SHARE_DELETE`, and would rewrite immutable content. Without the lock, a reference check on Linux or macOS could see a rename before its directory flush.
  - **Reads and checks.** No caller sees unverified bytes (the system specification's user story 5). Telling collected from missing keeps a vanished body loud while a collected one stays history (Core §13.1). The snapshot removes a race between `Collect`'s update of the index and a read's classification. The existence check makes "before any ledger event can reference them" (Core §13.1) mechanical without hashing again at append.
  - **Collection.** Recording before deleting is the intent-before-effect order of D38 and D59. A crash before the record changes nothing. A crash after it leaves a leftover that reads serve until it is removed. After `ErrUncertain` nothing was deleted: `Recover` drops the record, or `Open` keeps a complete one, and the next `Collect` finishes. An age-blind leftover rule would delete a body published again after a collection, whatever the cutoff. Batches bound how long collection holds the writer turn; the `collect` run measures the stall.
  - **Identities.** D58 compares the immutable submission and C3 owns its bytes, so the store compares a digest the caller supplies. A duplicate returns the original whatever the current drafts would do, because the same ID and submission never enqueue or execute another request (D58). Tombstone and effect share a commit because one sequencer commits related records together (B3). A complete in-memory index would grow with history, a scan on every miss would make each new command read the log, and an on-disk index needs a measured trigger (D34, B3). Without the issuance bound, one far-future ID would send every later fresh ID to the disk. The fast path is sound only while `commandLead` never shrinks. A staleness bound would refuse legitimate late first submissions; sender scopes are C6's to add if it needs them, and UUIDv7 randomness makes colony-wide uniqueness safe. At the OG3 model the hot index covers about 34 hours of commands at 20 contexts and 11 hours at 60 (65,536 ÷ (96 × 20) and 65,536 ÷ (96 × 60); a calculation from the approved bound and the assumed model, which changes with the model), far above the 5 minutes the fast path needs.
  - **D58 and D41.** D58 lists ID issuance and retention among its open items, says they do not reopen its identity behaviour and names Core C1 among its affected steps, and the log's index of items awaiting the owner does not list them. Settling them for C1 therefore touches no owner decision under D41. B18 settled what D34–D38 left open the same way.
  - **Opening and closing.** A projection built from a log that breaks a rule the writer promised is the bug the rebuild exists to catch. Recreating a missing `bodies/` would hide damage, as recreating `log/` would (B18). A valid log must still open after a bound is lowered. The colony lock means exclusive use of the colony's files until `Close` (B18). An operation that outlived `Close` could keep a temporary file open, and on Windows the next `Open`, which empties `bodies/.tmp`, would then fail.
  - **Measurements.** Windows gives a non-administrator no way to evict one file from the cache, and B3 keeps Defender on, so cold means the first access after a restart. A commit's cost does not depend on history, which enters through `Open` and old-ID lookups and is measured in their own runs; fresh colonies keep the append runs repeatable.
- **Limits:**
  - Nothing is frozen. OG2 was sent on 2026-10-10 and is not awaited; `ledger-format`, `ledger-reader` and `ledger-appender` stay Draft until the owner answers. C2 waits for the freeze of `ledger-format` and `ledger-appender`, and U1 for that of `ledger-format` and `ledger-reader`. The owner's answer and its decision entry belong to no ticket here. Nothing here grants D52 approval, sets a budget, threshold or pass mark, or claims capacity.
  - Left to later steps:
     - C2: the promotion and scratch families, including D23's fields.
     - C3: the command and result families; the canonical submission bytes and fields, the request/operation schema and result delivery (D58); wiring the store into the host; calling `Recover`, `PublishBody`, `Submit` and `Collect` from owner and agent commands; authorizing body reads, pin releases and a duplicate's retrieval; D38's default root; native Linux and macOS runs in its CI (D42).
     - C4: which bodies are diagnostic, and their age/byte policy; the `artifact_unavailable` projection and finalization pins; `CapacityProfile` body reservations (Core §13.2–§13.3).
     - C6: message caps and any sender scoping beyond a colony-wide command ID.
     - C7: cosmetic retry expiry and presentation snapshots.
     - Ticket 28: AC06 control priority.
     - Only on a measured trigger (D34, B3): snapshots, an on-disk or SQLite index, a cold lookup outside the writer turn, one fused startup pass, compressed segments.
  - Platform status: Windows behaviour is verified on NTFS on this machine; other file systems and network shares are unverified. Linux and macOS are compiled and vetted only, until C3's CI exists (D42).
  - This is not a power-loss guarantee (B3): it relies on the file system and the device honouring their flushes. The torn-tail rule cannot tell damage confined to the final commit, up to `MaxCommitBytes`, from an interrupted write until the latest hash is anchored externally (D36, assurance A3).
  - The measurements come from one machine against an assumed workload; Linux and macOS are unmeasured. The colonies were generated without a flush per body file, and the restart was a clean shutdown, not a power loss. Whether SysMain prefetched colony files after the restart is unverified. No figure is a threshold, a pass mark or a capacity claim.
  - The rebuild cannot check three stated record rules (item 10); none can arise through the store's own writers.
- **Changes:**
  - `contract/ledger`: new `digest.go`, `records.go` and `records_test.go`; `envelope.go`, `commit.go`, `catalogue.go`, `reader.go`, `segment.go` and the package doc; the new catalogue golden; `golden_test.go`, `encode_test.go`, `check_test.go`, `reader_test.go`, `fuzz_test.go` and `catalogue_test.go`. `contract/ledger/appender`: its package doc only.
  - `internal/core/ledgerstore`: new `bodies.go`, `pins.go`, `collect.go` and `commands.go`; `store.go` and `files.go`; new `bodies_test.go`, `collect_test.go` and `commands_test.go`; `store_test.go`, `faults_test.go` and `recovery_test.go`; and the measurement harness, new test files only: `workload_test.go`, `peakmem_windows_test.go` and `peakmem_posix_test.go`.
  - Commits on `main`: S1 7afd48c, S2 7b45dbc, the S2 fix-up 96c82c9 and S3 09c1e03, which reached `main` together by fast-forward after a rebase onto 40e2b1b; S4 e635395, by fast-forward.
  - Not changed: `internal/core/durable`, `tools/check`, `go.mod`, `go.sum` and `cmd/`. No module is added (D29), and `internal/core/durable` is still the only importer of x/sys, so B18's allowlist rule is not yet due.
  - Documents: in `DECISIONS.md`, this entry, a "See also" line under D58 and a row for the F0 freeze request under "Open items awaiting the owner"; in `CONTRACTS.md`, the F0 catalogue table with B2's attributes, the Defines text for `body_refs`, the F0 catalogue, `AllTypes`, `ParseSegmentName` and the appender's refusals of unpublished references and store-owned types, and the status line; in Core, §8.6's "Colony log" row, Appendix A's heading and A.1, the new A.10, Appendix B's "Not yet verified" list and the sentences giving C1's status; `ROADMAP-CORE.md` (its status line, C1's status and status row, and C1's row under "Remaining prerequisites and evidence") and `ROADMAPS.md` (its status line, the Path A paragraph and the status board), in one commit; `ROADMAP-GUI.md`'s status paragraph; `docs/RESEARCH-OPENRIG-PERSISTENCE.md` (its link to Core Appendix A, re-pointed at A.7 because the appendix heading gained a date); and the system specification's C1 status.
  - Evidence under `.scratch/dwarf-harness/c1-evidence/`: the raw results and the OG2 packet.
