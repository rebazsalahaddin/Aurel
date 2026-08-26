import Foundation
import SwiftUI
import UIKit

// MARK: - Karaoke text (audio-upgrade phase, Enhancement doc §3)
//
// "During audio playback, highlight the exact spoken word" — the read-along
// partner of the recorded voices. Spoken words carry the accent, the word
// currently being voiced gets a soft accent pill, and the unspoken remainder
// of an active line dims so the eye is pulled forward. The state comes from
// `VoicePlayback` (`spokenLineText` matching + `spokenRange`), which reports
// exact synthesizer ranges on the TTS path and proportional ones on the
// recorded path.
//
// Motion (§2.5): everything degrades to a crossfade under Reduce Motion, and
// the word pill/underline disappear entirely — color-only, still legible.

/// The per-word karaoke coloring of one line — a pure function of
/// (text, spoken range), split out so it is unit-testable without audio.
struct KaraokeWords: Equatable {
    enum WordState: Equatable {
        /// Ahead of the voice.
        case unspoken
        /// Fully voiced already.
        case spoken
        /// The word being voiced right now — the reading cursor.
        case active
    }

    struct Word: Equatable {
        let location: Int
        let length: Int
        let state: WordState

        static func == (lhs: Word, rhs: Word) -> Bool {
            lhs.location == rhs.location && lhs.length == rhs.length
                && lhs.state == rhs.state
        }
    }

    let words: [Word]

    /// Splits `text` into words (Foundation word boundaries — punctuation
    /// stays attached as authored) and grades each against the spoken UTF-16
    /// range. A nil or empty range leaves every word unspoken.
    static func build(text: String, spoken: NSRange?) -> KaraokeWords {
        let ns = text as NSString
        guard let spoken, spoken.length > 0 else {
            return KaraokeWords(words: [])
        }
        let spokenEnd = min(spoken.location + spoken.length, ns.length)

        var out: [Word] = []
        ns.enumerateSubstrings(
            in: NSRange(location: 0, length: ns.length),
            options: [.byWords, .localized]
        ) { _, range, _, _ in
            let end = range.location + range.length
            let state: WordState
            if spokenEnd <= range.location {
                state = .unspoken
            } else if end <= spokenEnd {
                state = .spoken
            } else {
                state = .active
            }
            out.append(Word(location: range.location, length: range.length, state: state))
        }
        return KaraokeWords(words: out)
    }
}

/// One line of learner-visible text that highlights along with the audio.
/// The caller keeps owning typography (`.font`, `.auLine`, alignment) — this
/// view only renders the karaoke colors, so it drops in where `Text` stood.
struct KaraokeText: View {
    let text: String
    /// True while this line is the one being spoken (`VoicePlayback.isSpoken`).
    var isSpoken: Bool
    /// The spoken UTF-16 range within `text` (nil → nothing highlighted).
    var spokenRange: NSRange?
    /// The line's normal ink.
    var base: Color = .auText
    /// The highlight ink for spoken words.
    var accent: Color = .auAccent

    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    private var attributed: AttributedString {
        let paragraph = NSMutableAttributedString(
            string: text,
            attributes: [.foregroundColor: UIColor(base)]
        )
        guard isSpoken else {
            return AttributedString(paragraph)
        }

        let dimmed = UIColor(base.opacity(0.55))
        let accentUI = UIColor(accent)
        for word in KaraokeWords.build(text: text, spoken: spokenRange).words {
            let range = NSRange(location: word.location, length: word.length)
            switch word.state {
            case .unspoken:
                paragraph.addAttribute(.foregroundColor, value: dimmed, range: range)
            case .spoken:
                paragraph.addAttribute(.foregroundColor, value: accentUI, range: range)
            case .active:
                // The reading cursor — accent ink, plus (motion permitting) a
                // soft pill so it also reads without color discrimination.
                paragraph.addAttribute(.foregroundColor, value: accentUI, range: range)
                if !reduceMotion {
                    paragraph.addAttribute(
                        .backgroundColor, value: UIColor(accent.opacity(0.16)), range: range)
                    paragraph.addAttribute(
                        .underlineStyle, value: NSUnderlineStyle.single.rawValue, range: range)
                }
            }
        }
        return AttributedString(paragraph)
    }

    var body: some View {
        Text(attributed)
            .animation(
                AUMotion.animation(.easeInOut(duration: 0.25), reduceMotion: reduceMotion),
                value: attributed)
            .accessibilityValue(isSpoken ? "Speaking" : "")
    }
}
