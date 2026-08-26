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
    /// must expose its authored text + speaker for row matching.
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
        // Speaker-voiced takes match text *and* speaker…
        XCTAssertTrue(playback.isSpoken(text: line.text, speaker: line.speaker))
        XCTAssertFalse(playback.isSpoken(text: line.text, speaker: "NOT-$A-SPEAKER"))
        // …and never a different line's text.
        XCTAssertFalse(playback.isSpoken(text: "definitely not the spoken line"))
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
    }

    @MainActor
    func testStopClearsKaraokeState() {
        let playback = VoicePlayback(catalog: AudioCatalog(bundle: .main))
        playback.speak(audioID: nil, text: "Hello", slow: false)
        playback.stop()
        XCTAssertNil(playback.spokenLineText)
        XCTAssertNil(playback.spokenRange)
        XCTAssertFalse(playback.isSpoken(text: "Hello"))
    }
}
