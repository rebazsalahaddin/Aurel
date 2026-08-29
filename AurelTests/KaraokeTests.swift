import XCTest

@testable import Aurel

/// Phase 4 (karaoke): word-grading of the spoken range, and the playback
/// state rows match against — the two pieces that decide which word lights
/// up while the recorded voices speak.
final class KaraokeTests: XCTestCase {
    // MARK: KaraokeWords.build — pure grading

    private func states(_ text: String, _ spoken: NSRange?) -> [KaraokeWords.WordState] {
        KaraokeWords.build(text: text, spoken: spoken).words.map(\.state)
    }

    func testNilOrEmptyRangeGradesNothing() {
        XCTAssertTrue(KaraokeWords.build(text: "Hello there", spoken: nil).words.isEmpty)
        XCTAssertTrue(
            KaraokeWords.build(text: "Hello there", spoken: NSRange(location: 0, length: 0))
                .words.isEmpty)
    }

    func testPartialRangeGradesSpokenActiveUnspoken() {
        // "Hello there my friend" — spoken through "there"'s first letters.
        let states = states("Hello there my friend", NSRange(location: 0, length: 8))
        XCTAssertEqual(states, [.spoken, .active, .unspoken, .unspoken])
    }

    func testBoundaryBetweenWordsHasNoActiveWord() {
        // The range ends exactly where "there" begins — nothing is being
        // voiced at that instant, so no word claims the cursor.
        let states = states("Hello there", NSRange(location: 0, length: 6))
        XCTAssertEqual(states, [.spoken, .unspoken])
    }

    func testFullRangeSpeaksEveryWord() {
        let states = states("Nice to meet you!", NSRange(location: 0, length: 999))
        XCTAssertEqual(states, [.spoken, .spoken, .spoken, .spoken])
    }

    func testPunctuationStaysWithItsWord() {
        // Grading must use Foundation word boundaries so "Hi," is one unit
        // (comma included), and the cursor can land mid-word.
        let words = KaraokeWords.build(
            text: "Hi, meet me", spoken: NSRange(location: 0, length: 6)
        ).words
        XCTAssertEqual(words.count, 3)
        XCTAssertEqual(words.map(\.state), [.spoken, .active, .unspoken])
    }

    // MARK: VoicePlayback — the state karaoke rows match on

    /// The shipped Chapter-1 pilot supplies a real catalog take: playing it
    /// must expose its authored identity (asset + line) for row matching.
    @MainActor
    func testRecordedTakeExposesSpokenLineForMatching() throws {
        let playback = VoicePlayback(catalog: AudioCatalog(bundle: .main))
        defer { playback.stop() }

        let asset = try XCTUnwrap(
            playback.catalog.asset("A1-C01-AUD043"),
            "pilot asset A1-C01-AUD043 missing from the bundle")
        let line = try XCTUnwrap(asset.lines.first)

        playback.speak(audioID: asset.id, text: line.text, slow: false, lineIndex: nil)
        XCTAssertEqual(playback.spokenLineText, line.text)
        XCTAssertEqual(playback.spokenSpeaker, line.speaker)
        XCTAssertEqual(playback.spokenAssetID, asset.id)
        XCTAssertEqual(playback.spokenLine, 0)
        // Identity matching keys on the asset + aligned line (speaker
        // narrows same-text rows)…
        XCTAssertTrue(
            playback.isSpoken(audioID: asset.id, text: line.text, speaker: line.speaker))
        XCTAssertFalse(
            playback.isSpoken(audioID: asset.id, text: line.text, speaker: "NOT-A-SPEAKER"))
        // …never on a different asset…
        XCTAssertFalse(playback.isSpoken(audioID: "A1-C01-AUD999", text: line.text))
        // …and the recorded path never degrades to raw text equality, so
        // equal texts elsewhere can't light up.
        XCTAssertFalse(playback.isSpoken(text: line.text))
    }

    /// Line-scoped playback (a single conversation turn) keeps the ABSOLUTE
    /// catalog line index, so identity matching still resolves.
    @MainActor
    func testLineScopedPlaybackKeepsAbsoluteLineIndex() throws {
        let playback = VoicePlayback(catalog: AudioCatalog(bundle: .main))
        defer { playback.stop() }

        let asset = try XCTUnwrap(playback.catalog.asset("A1-C01-AUD043"))
        XCTAssertTrue(asset.lines.indices.contains(1), "pilot asset needs two lines")
        playback.speak(
            audioID: asset.id, text: asset.lines[1].text, slow: false, lineIndex: 1)
        XCTAssertEqual(playback.spokenLine, 1)
        XCTAssertEqual(playback.spokenLineText, asset.lines[1].text)
        XCTAssertTrue(
            playback.isSpoken(
                audioID: asset.id, text: asset.lines[1].text, speaker: asset.lines[1].speaker))
        XCTAssertFalse(
            playback.isSpoken(
                audioID: asset.id, text: asset.lines[0].text, speaker: asset.lines[0].speaker))
    }

    /// The TTS fallback still karaoke-enables: its text is relayed verbatim
    /// (the synthesizer's exact ranges arrive asynchronously and are only
    /// copied while it speaks).
    @MainActor
    func testFallbackRelaysSpokenText() {
        let playback = VoicePlayback(catalog: AudioCatalog(bundle: .main))
        defer { playback.stop() }

        playback.speak(audioID: nil, text: "Hello", slow: false)
        XCTAssertEqual(playback.spokenLineText, "Hello")
        XCTAssertNil(playback.spokenSpeaker)
        XCTAssertTrue(playback.isSpoken(text: "Hello"))
    }

    @MainActor
    func testPauseKeepsSpokenLineAndResumeContinues() throws {
        let playback = VoicePlayback(catalog: AudioCatalog(bundle: .main))
        defer { playback.stop() }

        let asset = try XCTUnwrap(playback.catalog.asset("A1-C01-AUD043"))
        playback.speak(audioID: asset.id, text: asset.lines[0].text, slow: false, lineIndex: 0)
        XCTAssertTrue(playback.speaking)
        XCTAssertFalse(playback.paused)

        playback.pause()
        XCTAssertTrue(playback.paused)
        XCTAssertTrue(playback.speaking)
        XCTAssertEqual(playback.spokenLine, 0)
        XCTAssertEqual(playback.spokenAssetID, asset.id)

        playback.resume()
        XCTAssertFalse(playback.paused)
        XCTAssertTrue(playback.speaking)
        XCTAssertEqual(playback.spokenLine, 0)
    }

    @MainActor
    func testStopClearsKaraokeState() {
        let playback = VoicePlayback(catalog: AudioCatalog(bundle: .main))
        playback.speak(audioID: nil, text: "Hello", slow: false)
        playback.stop()
        XCTAssertNil(playback.spokenLineText)
        XCTAssertNil(playback.spokenRange)
        XCTAssertNil(playback.spokenAssetID)
        XCTAssertEqual(playback.spokenLine, -1)
        XCTAssertFalse(playback.isSpoken(text: "Hello"))
    }

    /// Word-model cards must play the bundled take, not system TTS. The old
    /// matcher treated “Hello. … Hello.” as too long for “hello” and spoke
    /// the system voice instead.
    @MainActor
    func testWordModelCardUsesRecordedTakeNotTTS() throws {
        let playback = VoicePlayback(catalog: AudioCatalog(bundle: .main))
        defer { playback.stop() }

        playback.speak(audioID: "A1-C01-AUD002", text: "hello", slow: false)
        XCTAssertEqual(playback.spokenAssetID, "A1-C01-AUD002")
        XCTAssertNotNil(playback.spokenLineText)
        XCTAssertNotEqual(playback.spokenLineText, "hello")

        playback.speak(audioID: "A1-C01-AUD003", text: "hi", slow: false)
        XCTAssertEqual(playback.spokenAssetID, "A1-C01-AUD003")
    }

    /// Image-match Listen cues come from picture alt (“morning”), not the
    /// word-model script (“Good morning. … Good morning.”). That fragment
    /// must still play the bundled take, never system TTS.
    @MainActor
    func testGreetingImageMatchCueUsesRecordedTakeNotTTS() throws {
        let playback = VoicePlayback(catalog: AudioCatalog(bundle: .main))
        defer { playback.stop() }

        playback.speak(audioID: "A1-C01-AUD004", text: "morning", slow: false)
        XCTAssertEqual(playback.spokenAssetID, "A1-C01-AUD004")
        XCTAssertNotNil(playback.spokenLineText)

        playback.speak(audioID: "A1-C01-AUD006", text: "evening", slow: false)
        XCTAssertEqual(playback.spokenAssetID, "A1-C01-AUD006")

        playback.speak(audioID: "A1-C01-AUD005", text: "afternoon", slow: false)
        XCTAssertEqual(playback.spokenAssetID, "A1-C01-AUD005")
    }

    /// A Listen item whose cue is the answer, not the stimulus script, still
    /// plays the authored file instead of speaking the answer in a robot voice.
    @MainActor
    func testUnmatchedListenCueStillPlaysBundledTake() throws {
        let playback = VoicePlayback(catalog: AudioCatalog(bundle: .main))
        defer { playback.stop() }

        playback.speak(
            audioID: "A1-C01-AUD032", text: "I'm good, thank you!", slow: false)
        XCTAssertEqual(playback.spokenAssetID, "A1-C01-AUD032")
        XCTAssertNotNil(playback.spokenLineText)
    }

    /// Perceive intonation cards share a folded spelling; the question mark
    /// must still pick the asking clip, not the telling clip.
    @MainActor
    func testIntonationPairKeepsStatementAndQuestionClipsDistinct() throws {
        let catalog = AudioCatalog(bundle: .main)
        let asset = try XCTUnwrap(catalog.asset("A1-C01-AUD041"))
        XCTAssertEqual(
            VoicePlayback.selectTake(lines: asset.lines, requestedText: "You're Maya."),
            .line(index: 0, clip: .ellipsisSegment(index: 0, count: 6)))
        XCTAssertEqual(
            VoicePlayback.selectTake(lines: asset.lines, requestedText: "You're Maya?"),
            .line(index: 0, clip: .ellipsisSegment(index: 1, count: 6)))
    }

    // MARK: KaraokeTimeline — the dialogue timeline resolver

    private func line(_ speaker: String, _ text: String) -> AudioCatalog.Line {
        AudioCatalog.Line(
            file: "x.wav", speaker: speaker, voice: "V", text: text, dur: 1, wpm: nil)
    }

    /// Authored shape: learner (YOU) turns are never recorded, so they map to
    /// nil while the recorded neighbors keep their authored order.
    func testAlignSkipsLearnerTurnsAndKeepsAuthorOrder() {
        let lines = [
            line("ALEX", "Hello! … Good morning!"),
            line("NINA", "Good morning, Alex!"),
            line("NINA", "Welcome! … What's your name?"),
            line("NINA", "Maya! … How do you spell that?"),
            line("NINA", "Maya. … Thank you!"),
        ]
        let rows = [
            KaraokeTimeline.Row(speaker: "ALEX", text: "Hello! … Good morning!"),
            KaraokeTimeline.Row(speaker: "NINA", text: "Good morning, Alex!"),
            KaraokeTimeline.Row(speaker: "NINA", text: "Welcome! … What's your name?"),
            KaraokeTimeline.Row(speaker: "YOU", text: "Maya."),
            KaraokeTimeline.Row(speaker: "NINA", text: "Maya! … How do you spell that?"),
            KaraokeTimeline.Row(speaker: "YOU", text: "M … A … Y … A."),
            KaraokeTimeline.Row(speaker: "NINA", text: "Maya. … Thank you!"),
        ]
        XCTAssertEqual(
            KaraokeTimeline.align(rows: rows, lines: lines), [0, 1, 2, nil, 3, nil, 4])
    }

    /// The authored duplicate (A1-C04-AUD036: AMARA says "Nice to meet you
    /// too!" twice) resolves in order — exactly one row can be active per
    /// take, where text equality used to light both.
    func testAlignResolvesDuplicateLinesInOrder() {
        let lines = [
            line("NINA", "Hello!"),
            line("AMARA", "Hi! I'm Amara."),
            line("AMARA", "Nice to meet you too!"),
            line("NINA", "And you?"),
            line("AMARA", "Nice to meet you too!"),
        ]
        let rows = [
            KaraokeTimeline.Row(speaker: "NINA", text: "Hello!"),
            KaraokeTimeline.Row(speaker: "AMARA", text: "Hi! I'm Amara."),
            KaraokeTimeline.Row(speaker: "AMARA", text: "Nice to meet you too!"),
            KaraokeTimeline.Row(speaker: "NINA", text: "And you?"),
            KaraokeTimeline.Row(speaker: "AMARA", text: "Nice to meet you too!"),
        ]
        XCTAssertEqual(KaraokeTimeline.align(rows: rows, lines: lines), [0, 1, 2, 3, 4])
    }

    /// Recordings carry TTS pacing the learner-facing rows do not — ellipsis
    /// pauses and inserted fragments ("Hmm — today:") still align because
    /// matching runs on normalized tokens in order.
    func testAlignMatchesTTSPacedScriptVariants() {
        let paced = line(
            "ALEX",
            "Okay! … You're my friend, and today — you're the badge… helper! "
                + "Hmm — today: you say hello. New people! New names!")
        let rows = [
            KaraokeTimeline.Row(
                speaker: "ALEX",
                text: "Okay! You're my friend, and today — you're the badge helper! "
                    + "You say hello. New people! New names!")
        ]
        XCTAssertEqual(KaraokeTimeline.align(rows: rows, lines: [paced]), [0])

        let dotted = line("GUIDE", "It is morning. … The Community House is open! … Ready?")
        let plain = [
            KaraokeTimeline.Row(
                speaker: "GUIDE", text: "It is morning. The Community House is open! Ready?")
        ]
        XCTAssertEqual(KaraokeTimeline.align(rows: plain, lines: [dotted]), [0])
    }

    /// An asset whose narration script differs from the dialogue on screen
    /// (A1-C04-AUD001 shape) highlights nothing — graceful, deterministic.
    func testAlignMapsNothingWhenAudioIsADifferentScript() {
        let lines = [line("GUIDE", "Look! … The map wall. … Six dots.")]
        let rows = [
            KaraokeTimeline.Row(speaker: "ALEX", text: "You're my friend! Look: one badge."),
            KaraokeTimeline.Row(speaker: "GUIDE", text: "Three steps, three lessons."),
        ]
        XCTAssertEqual(KaraokeTimeline.align(rows: rows, lines: lines), [nil, nil])
    }

    func testAlignHandlesEmptyAndMalformedInput() {
        XCTAssertEqual(KaraokeTimeline.align(rows: [], lines: []), [])
        XCTAssertEqual(
            KaraokeTimeline.align(
                rows: [KaraokeTimeline.Row(text: "")], lines: [line("A", "x")]),
            [nil])
        XCTAssertEqual(
            KaraokeTimeline.align(rows: [KaraokeTimeline.Row(text: "Hello")], lines: []),
            [nil])
    }

    // MARK: Playback lifecycle

    /// Navigating away must end the audio: karaoke state can never leak
    /// across screens (the old code kept the old queue playing).
    @MainActor
    func testGotoStopsPlaybackSoStateNeverLeaksAcrossScreens() throws {
        final class StopSpy: AudioPlaying {
            var stops = 0
            func speak(_ text: String, slow: Bool) {}
            func speak(audioID: String?, text: String, slow: Bool, lineIndex: Int?) {}
            func stop() { stops += 1 }
            var isSpeaking: Bool { false }
        }

        let store = CourseDecodingTests.store
        let start = try XCTUnwrap(store.flat.indices.first, "course must not be empty")
        let m = PlayerModel(course: store, start: start)
        let spy = StopSpy()
        m.speaker = spy
        m.goto(m.p + 1)
        XCTAssertGreaterThanOrEqual(spy.stops, 1, "goto must stop the speaker")
    }
}
