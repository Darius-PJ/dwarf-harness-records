# Ticket140S5 actual parent LSP reference digest

Subject8a17 canonicalMAIN. Actual existing gopls references, no Go/setup/check command. Includes declaration; tests omitted only in this human digest, full actual outputs in t140-s5-lsp-reference-digest.json. No whole-program/reflection completeness beyond reported gopls references is inferred.

## ledger.OpenReader

Found 24 reference(s):

  contract/ledger/reader.go:58:6
    57: // of the segment before it.
    58: func OpenReader(logDir string, opts ReadOptions) (*Reader, error) {
    59: 	if !isV7(opts.Colony) {

  internal/core/agents/replay.go:242:19
    241: func (s *Service) scan(ctx context.Context, after, through uint64, visit func(ledger.Commit) error) (err error) {
    242: 	r, err := ledger.OpenReader(s.store.LogDir(), ledger.ReadOptions{Colony: s.store.Colony(), After: after, Through: through, Consume: privateConsumption(), AllTypes: true})
    243: 	if err != nil {

  internal/core/ledgerstore/bodies.go:460:19
    459: func (s *Store) newestListing(after, through uint64, d ledger.Digest) (uint64, error) {
    460: 	r, err := ledger.OpenReader(s.logDir, ledger.ReadOptions{
    461: 		Colony: s.colony, After: after, Through: through,

  internal/core/ledgerstore/collect.go:268:19
    267: 	}
    268: 	r, err := ledger.OpenReader(s.logDir, ledger.ReadOptions{
    269: 		Colony: s.colony, After: after, Through: through,

  internal/core/ledgerstore/commands.go:311:19
    310: 	s.coldScans.Add(1)
    311: 	r, err := ledger.OpenReader(s.logDir, ledger.ReadOptions{
    312: 		Colony: s.colony, After: first - 1, Through: through,

  internal/core/ledgerstore/store.go:497:19
    496: 	}
    497: 	r, err := ledger.OpenReader(s.logDir, ledger.ReadOptions{
    498: 		Colony: s.colony, Through: s.chain.Seq,

  internal/core/workspace/activation_replay.go:316:24
    315: 	}
    316: 	reader, err := ledger.OpenReader(s.store.LogDir(), ledger.ReadOptions{Colony: s.store.Colony(), After: committed.First - 1, Through: committed.Last, Consume: workspaceConsumption(), AllTypes: true})
    317: 	if err == nil {

  internal/core/workspace/service.go:185:24
    184: 	s.engine = newCaptureEngine(s.git, colony)
    185: 	reader, err := ledger.OpenReader(store.LogDir(), ledger.ReadOptions{Colony: store.Colony(), Through: store.Durable(), Consume: workspaceConsumption(), AllTypes: true})
    186: 	if err != nil {

  internal/undercurrent/graph/service.go:418:24
    417: 	}
    418: 	reader, err := ledger.OpenReader(s.opts.LogDir, ledger.ReadOptions{Colony: s.opts.Colony, After: s.replay.through, Through: mark, Consume: graphConsumption(), AllTypes: true})
    419: 	if err != nil {

## agents.readCommittedRange

Found 7 reference(s):

  internal/core/agents/replay.go:279:19
    278: // successful reader close. A Submit receipt is a range, not decoded effects.
    279: func (s *Service) readCommittedRange(ctx context.Context, first, last uint64) (ledger.Commit, error) {
    280: 	if first == 0 || last < first {

  internal/core/agents/review_execute.go:123:21
    122: 		var accepted ledger.Commit
    123: 		accepted, err = s.readCommittedRange(context.Background(), committed.First, committed.Last)
    124: 		if err == nil {

  internal/core/agents/scoped_execute.go:343:21
    342: 		var accepted ledger.Commit
    343: 		accepted, err = s.readCommittedRange(context.Background(), committed.First, committed.Last)
    344: 		if err == nil {

## agents.scan

Found 32 reference(s):

  internal/core/agents/replay.go:241:19
    240: }
    241: func (s *Service) scan(ctx context.Context, after, through uint64, visit func(ledger.Commit) error) (err error) {
    242: 	r, err := ledger.OpenReader(s.store.LogDir(), ledger.ReadOptions{Colony: s.store.Colony(), After: after, Through: through, Consume: privateConsumption(), AllTypes: true})

  internal/core/agents/integrity.go:72:11
    71: 	var current uint64
    72: 	err := s.scan(ctx, 0, through, func(c ledger.Commit) error {
    73: 		g, scoped, _, _, _, err := decodeFamily(draftsOf(c), c.First)

  internal/core/agents/integrity.go:165:11
    164: 	// Reports are collected per scope to retain sorted-scope/occurrence order.
    165: 	err := s.scan(ctx, 0, s.p.through, func(c ledger.Commit) error {
    166: 		g, scoped, _, _, _, err := decodeFamily(draftsOf(c), c.First)

  internal/core/agents/paid_read.go:44:11
    43: 	found := false
    44: 	err := s.scan(ctx, a.sequence-2, s.p.through, func(c ledger.Commit) error {
    45: 		_, _, _, g, _, err := decodeFamily(draftsOf(c), c.First)

  internal/core/agents/paid_settlement.go:275:11
    274: 		var receipt PaidReceipt
    275: 		err = s.scan(ctx, sequence-3, sequence, func(c ledger.Commit) error {
    276: 			_, _, _, g, _, e := decodeFamily(draftsOf(c), c.First)

  internal/core/agents/paid_state.go:149:11
    148: 	found := false
    149: 	err := s.scan(ctx, 0, through, func(c ledger.Commit) error {
    150: 		for _, r := range c.Records {

  internal/core/agents/paid_state.go:180:11
    179: 	routes := map[uuid.UUID]ledger.Profile{}
    180: 	err := s.scan(ctx, 0, through, func(c ledger.Commit) error {
    181: 		_, _, _, g, _, err := decodeFamily(draftsOf(c), c.First)

  internal/core/agents/paid_state.go:220:11
    219: 	routes := map[uuid.UUID]ledger.Profile{}
    220: 	err := s.scan(ctx, 0, through, func(c ledger.Commit) error {
    221: 		_, _, _, g, _, err := decodeFamily(draftsOf(c), c.First)

  internal/core/agents/registration_query.go:65:11
    64: 	}
    65: 	err := s.scan(ctx, 0, through, func(c ledger.Commit) error {
    66: 		_, _, _, _, g, err := decodeFamily(draftsOf(c), c.First)

  internal/core/agents/replay.go:267:11
    266: 	}
    267: 	err := s.scan(ctx, s.p.through, through, func(c ledger.Commit) error {
    268: 		_, err := s.acceptCommitLocked(ctx, c, nil)

  internal/core/agents/replay.go:284:11
    283: 	var accepted ledger.Commit
    284: 	err := s.scan(ctx, first-1, last, func(c ledger.Commit) error {
    285: 		if accepted.First != 0 || c.First != first || c.Last != last {

  internal/core/agents/replay.go:477:11
    476: 	var found commandMatch
    477: 	err := s.scan(ctx, after, through, func(c ledger.Commit) error {
    478: 		for _, r := range c.Records {

  internal/core/agents/review_sources.go:55:10
    54: 	done := errors.New("agents: source batch complete")
    55: 	err = s.scan(ctx, first-1, through, func(c ledger.Commit) error {
    56: 		for _, record := range c.Records {

  internal/core/agents/review_state.go:23:11
    22: 	found := false
    23: 	err := s.scan(ctx, 0, through, func(c ledger.Commit) error {
    24: 		_, scoped, g, _, _, err := decodeFamily(draftsOf(c), c.First)

  internal/core/agents/scoped_budget_history.go:28:11
    27: 	}
    28: 	err := s.scan(ctx, 0, s.p.through, func(commit ledger.Commit) error {
    29: 		for _, record := range commit.Records {

  internal/core/agents/scoped_state.go:82:11
    81: 	found := false
    82: 	err := s.scan(ctx, 0, through, func(commit ledger.Commit) error {
    83: 		for _, record := range commit.Records {

  internal/core/agents/scoped_state.go:124:11
    123: 	found := false
    124: 	err := s.scan(ctx, 0, through, func(commit ledger.Commit) error {
    125: 		for _, record := range commit.Records {

  internal/core/agents/scoped_state.go:168:11
    167: 	found := false
    168: 	err := s.scan(ctx, 0, through, func(commit ledger.Commit) error {
    169: 		for _, record := range commit.Records {

  internal/core/agents/scoped_state.go:237:10
    236: 	idUnused, contextUnused = true, true
    237: 	err = s.scan(ctx, 0, through, func(commit ledger.Commit) error {
    238: 		for _, record := range commit.Records {

  internal/core/agents/scoped_state.go:314:12
    313: 		found := false
    314: 		err := s.scan(ctx, 0, through, func(commit ledger.Commit) error {
    315: 			for _, record := range commit.Records {

  internal/core/agents/scoped_state.go:356:11
    355: 	var id uuid.UUID
    356: 	err := s.scan(ctx, 0, through, func(commit ledger.Commit) error {
    357: 		for _, record := range commit.Records {

## ledger.Reader.Next

Found 25 reference(s):

  contract/ledger/reader.go:154:18
    153: // Through. Errors are final.
    154: func (r *Reader) Next() (Commit, error) {
    155: 	if r.err != nil {

  internal/core/agents/replay.go:251:15
    250: 		}
    251: 		c, err := r.Next()
    252: 		if errors.Is(err, io.EOF) {

  internal/core/ledgerstore/bodies.go:470:15
    469: 	for {
    470: 		c, err := r.Next()
    471: 		if err == io.EOF {

  internal/core/ledgerstore/collect.go:281:15
    280: 		}
    281: 		c, err := r.Next()
    282: 		if err == io.EOF {

  internal/core/ledgerstore/commands.go:323:15
    322: 		}
    323: 		c, err := r.Next()
    324: 		if errors.Is(err, io.EOF) {

  internal/core/ledgerstore/store.go:509:15
    508: 	for {
    509: 		c, err := r.Next()
    510: 		if errors.Is(err, io.EOF) {

  internal/core/workspace/activation_replay.go:319:24
    318: 		var commit ledger.Commit
    319: 		commit, err = reader.Next()
    320: 		if err == nil {

  internal/core/workspace/service.go:194:25
    193: 		}
    194: 		commit, err := reader.Next()
    195: 		if errors.Is(err, io.EOF) {

  internal/undercurrent/graph/service.go:429:25
    428: 		}
    429: 		commit, err := reader.Next()
    430: 		if errors.Is(err, io.EOF) {

## ledger.Reader.Close

Found 27 reference(s):

  contract/ledger/reader.go:216:18
    215: // wrapping os.ErrClosed, unless it had already failed or reached the end.
    216: func (r *Reader) Close() error {
    217: 	r.s.close()

  internal/core/agents/replay.go:246:42
    245: 	}
    246: 	defer func() { err = errors.Join(err, r.Close()) }()
    247: 	for {

  internal/core/ledgerstore/bodies.go:467:10
    466: 	}
    467: 	defer r.Close()
    468: 	var newest uint64

  internal/core/ledgerstore/collect.go:276:10
    275: 	}
    276: 	defer r.Close()
    277: 	for {

  internal/core/ledgerstore/commands.go:318:10
    317: 	}
    318: 	defer r.Close()
    319: 	for {

  internal/core/ledgerstore/store.go:506:10
    505: 	}
    506: 	defer r.Close()
    507: 	seg := 0 // the segment that holds the commit being replayed

  internal/core/workspace/activation_replay.go:323:33
    322: 		}
    323: 		err = errors.Join(err, reader.Close())
    324: 	}

  internal/core/workspace/service.go:189:15
    188: 	}
    189: 	defer reader.Close()
    190: 	for {

  internal/undercurrent/graph/service.go:422:15
    421: 	}
    422: 	defer reader.Close()
    423: 	next := s.replay.clone()

## agents.refreshLocked

Found 27 reference(s):

  internal/core/agents/replay.go:263:19
    262: }
    263: func (s *Service) refreshLocked(ctx context.Context, through uint64) error {
    264: 	if through == s.p.through {

  internal/core/agents/commands.go:30:14
    29: 	}
    30: 	if err := s.refreshLocked(ctx, s.store.Durable()); err != nil {
    31: 		return submissionIDs{}, err

  internal/core/agents/commands.go:126:14
    125: 	}
    126: 	if err := s.refreshLocked(ctx, s.store.Durable()); err != nil {
    127: 		return commandMatch{}, err

  internal/core/agents/commands.go:150:14
    149: 	}
    150: 	if err := s.refreshLocked(ctx, s.store.Durable()); err != nil {
    151: 		return m, err

  internal/core/agents/commands.go:179:14
    178: 	}
    179: 	if err := s.refreshLocked(ctx, s.store.Durable()); err != nil {
    180: 		return err

  internal/core/agents/commands.go:357:14
    356: 	// including workspace records, rather than jumping a guessed cursor.
    357: 	if err := s.refreshLocked(context.Background(), max(s.p.through, committed.Last)); err != nil {
    358: 		s.mu.Unlock()

  internal/core/agents/paid_live.go:118:11
    117: 	}
    118: 	return s.refreshLocked(ctx, s.store.Durable())
    119: }

  internal/core/agents/paid_live.go:130:14
    129: 	}
    130: 	if err := s.refreshLocked(ctx, s.store.Durable()); err != nil {
    131: 		return match, err

  internal/core/agents/paid_live.go:150:12
    149: 	}
    150: 	if e := s.refreshLocked(ctx, s.store.Durable()); e != nil {
    151: 		return match, e

  internal/core/agents/paid_live.go:244:10
    243: 	}
    244: 	err = s.refreshLocked(context.Background(), max(s.p.through, committed.Last))
    245: 	if err == nil && committed.Duplicate {

  internal/core/agents/paid_read.go:74:15
    73: 		}
    74: 		if err := s.refreshLocked(ctx, s.store.Durable()); err != nil {
    75: 			return err

  internal/core/agents/read.go:27:11
    26: 	if err == nil {
    27: 		err = s.refreshLocked(ctx, s.store.Durable())
    28: 	}

  internal/core/agents/read.go:238:14
    237: 	}
    238: 	if err := s.refreshLocked(ctx, s.store.Durable()); err != nil {
    239: 		return ScratchBinding{}, err

  internal/core/agents/registration_commands.go:116:14
    115: 	}
    116: 	if err := s.refreshLocked(ctx, s.store.Durable()); err != nil {
    117: 		return err

  internal/core/agents/registration_commands.go:264:10
    263: 	// Caller cancellation cannot undo a committed transition or skip its readback.
    264: 	err = s.refreshLocked(context.Background(), max(s.p.through, committed.Last))
    265: 	var actual commandMatch

  internal/core/agents/review_execute.go:140:11
    139: 	} else {
    140: 		err = s.refreshLocked(context.Background(), max(s.p.through, committed.Last))
    141: 		if err == nil {

  internal/core/agents/review_execute.go:264:14
    263: 	}
    264: 	if err := s.refreshLocked(ctx, s.store.Durable()); err != nil {
    265: 		return err

  internal/core/agents/scoped_execute.go:148:11
    147: 	if err == nil {
    148: 		err = s.refreshLocked(ctx, s.store.Durable())
    149: 	}

  internal/core/agents/scoped_execute.go:348:11
    347: 	} else {
    348: 		err = s.refreshLocked(context.Background(), max(s.p.through, committed.Last))
    349: 		if err == nil {

  internal/core/agents/scoped_query.go:25:11
    24: 	if err == nil {
    25: 		err = s.refreshLocked(ctx, s.store.Durable())
    26: 	}

  internal/core/agents/scoped_receipt_query.go:51:14
    50: 	}
    51: 	if err := s.refreshLocked(ctx, s.store.Durable()); err != nil {
    52: 		return ScopedReceipt{}, err

  internal/core/agents/scoped_submit.go:87:14
    86: 	}
    87: 	if err := s.refreshLocked(ctx, s.store.Durable()); err != nil {
    88: 		return err

  internal/core/agents/service.go:170:14
    169: 	s := &Service{store: store, colony: colony, limits: limits, deps: deps, p: newProjection(), history: newHistoryIndex(), gates: map[scopeKey]*scopeGate{}}
    170: 	if err := s.refreshLocked(ctx, store.Durable()); err != nil {
    171: 		return nil, report, err

## agents.acceptCommitLocked

Found 3 reference(s):

  internal/core/agents/replay.go:303:19
    302: // It never turns that single occurrence into a global command-search proof.
    303: func (s *Service) acceptCommitLocked(ctx context.Context, c ledger.Commit, expected *scopedInput) (commandMatch, error) {
    304: 	d := draftsOf(c)

  internal/core/agents/replay.go:268:15
    267: 	err := s.scan(ctx, s.p.through, through, func(c ledger.Commit) error {
    268: 		_, err := s.acceptCommitLocked(ctx, c, nil)
    269: 		return err

  internal/core/agents/scoped_execute.go:345:20
    344: 		if err == nil {
    345: 			actual, err = s.acceptCommitLocked(context.Background(), accepted, &input)
    346: 		}

## ledgerstore.Store.Submit

Found 69 reference(s):

  internal/core/ledgerstore/commands.go:160:17
    159: // from reading the log also means that nothing was written.
    160: func (s *Store) Submit(ctx context.Context, command ledger.Draft, drafts []ledger.Draft) (Receipt, error) {
    161: 	cmd, err := s.checkCommand(command)

  internal/core/agents/commands.go:344:28
    343: 	}
    344: 	committed, err := s.store.Submit(ctx, drafts[0], drafts[1:])
    345: 	if err != nil {

  internal/core/agents/paid_live.go:231:28
    230: 	}
    231: 	committed, err := s.store.Submit(ctx, drafts[0], drafts[1:])
    232: 	if err != nil {

  internal/core/agents/registration_commands.go:249:28
    248: 	}
    249: 	committed, err := s.store.Submit(ctx, drafts[0], drafts[1:])
    250: 	if err != nil {

  internal/core/agents/review_execute.go:104:28
    103: 	}
    104: 	committed, err := s.store.Submit(ctx, drafts[0], drafts[1:])
    105: 	if err != nil {

  internal/core/agents/scoped_execute.go:326:28
    325: 	}
    326: 	committed, err := s.store.Submit(ctx, drafts[0], drafts[1:])
    327: 	if err != nil {

## ledgerstore.Store.Close

Found 110 reference(s):

  internal/core/ledgerstore/store.go:849:17
    848: // its producers' contexts first.
    849: func (s *Store) Close() error {
    850: 	s.turn <- struct{}{}

  internal/core/ledgerstore/bodies.go:397:10
    396: 	}
    397: 	defer f.Close()
    398: 	// One byte more than the listed size shows a body that grew.

## ledgerstore.Store.Recover

Found 6 reference(s):

  internal/core/ledgerstore/store.go:785:17
    784: // throughout.
    785: func (s *Store) Recover() error {
    786: 	s.turn <- struct{}{}

