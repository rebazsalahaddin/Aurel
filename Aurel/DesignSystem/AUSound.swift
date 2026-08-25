import AVFoundation

// MARK: - Feedback sounds (IMPROVEMENT_PLAN.md §2.6)
//
// "Soft and sparse" (the Settings copy). Four authored sounds, synthesized
// to in-memory WAV at runtime — quiet sine partials with soft envelopes —
// played through data-based `AVAudioPlayer`. No recorded assets, nothing
// fabricated: these are UI feedback, not course audio. Gated by Settings →
// Sound (`SwitchPrefs.sound`) and silenced while the TTS speaker talks.
//
// Deliberately engine-free: an AVAudioEngine graph was tried first and its
// IO-node teardown can RPC-abort the process when the audio server is
// wedged (crash reports 2026-08-22 18:29/18:30 — `AURemoteIO::Cleanup` →
// `_ReportRPCTimeout` → abort, reached from `mainMixerNode` at launch).
// AVAudioPlayer owns no graph, constructs lazily, and every failure path
// fails soft (`try?` / a false return), so a bad audio server can cost a
// sound — never the app. No audio API is touched at launch at all.

@MainActor
final class AUSound {
    static let shared = AUSound()

    enum Kind {
        /// Correct verdict — a two-note chime that leans upward.
        case correct
        /// Miss verdict — one low, muted thud.
        case miss
        /// Lesson complete — a three-note arpeggio.
        case complete
        /// Streak milestone — a single warm bell.
        case milestone
    }

    /// The Settings gate — AppRouter writes this whenever `sw.sound`
    /// changes (and once at load from the persisted preference).
    var isEnabled = true

    /// Set by `Speaker` while TTS is talking — feedback sounds never
    /// speak over the voice.
    var isDucked = false

    /// Test-visible: how many sounds passed the gates since launch.
    private(set) var playCount = 0

    /// One player per kind, built lazily on first play. When construction
    /// fails (audio server unavailable — unit-test hosts, wedged sims),
    /// the kind is latched off for the session instead of retrying.
    private var players: [Kind: AVAudioPlayer] = [:]
    private var unavailable: Set<Kind> = []

    private static let sampleRate: Double = 44_100

    func correct() { play(.correct) }
    func miss() { play(.miss) }
    func complete() { play(.complete) }
    func milestone() { play(.milestone) }

    private func play(_ kind: Kind) {
        guard isEnabled, !isDucked else { return }
        playCount += 1
        guard let player = player(for: kind) else { return }
        player.currentTime = 0
        player.play()
    }

    private func player(for kind: Kind) -> AVAudioPlayer? {
        if let cached = players[kind] { return cached }
        guard !unavailable.contains(kind) else { return nil }
        guard
            let data = Self.wavData(for: kind),
            let player = try? AVAudioPlayer(
                data: data, fileTypeHint: AVFileType.wav.rawValue)
        else {
            unavailable.insert(kind)  // fail soft, once
            return nil
        }
        player.volume = 0.9
        player.prepareToPlay()
        players[kind] = player
        return player
    }
}

// MARK: Synthesis — quiet sine partials with soft envelopes → Int16 WAV.

extension AUSound {
    private struct Note {
        let frequency: Double
        let start: Double
        let duration: Double
        let amplitude: Float
        /// Exponential decay rate (higher = faster fade).
        let decay: Double
    }

    private static func notes(for kind: Kind) -> (notes: [Note], total: Double) {
        switch kind {
        case .correct:
            // C5 into E5 — two notes, unhurried.
            return (
                [
                    Note(frequency: 523.25, start: 0, duration: 0.10, amplitude: 0.16, decay: 18),
                    Note(
                        frequency: 659.25, start: 0.09, duration: 0.12, amplitude: 0.14, decay: 16),
                ], 0.23
            )
        case .miss:
            // One low thud — muted on purpose, never a buzzer.
            return (
                [Note(frequency: 138.59, start: 0, duration: 0.16, amplitude: 0.18, decay: 22)],
                0.18
            )
        case .complete:
            // C5 · E5 · G5.
            return (
                [
                    Note(frequency: 523.25, start: 0, duration: 0.11, amplitude: 0.15, decay: 15),
                    Note(
                        frequency: 659.25, start: 0.10, duration: 0.11, amplitude: 0.14, decay: 15),
                    Note(
                        frequency: 783.99, start: 0.20, duration: 0.16, amplitude: 0.15, decay: 13),
                ], 0.38
            )
        case .milestone:
            // A warm bell: the fundamental plus one inharmonic partial.
            return (
                [
                    Note(frequency: 440, start: 0, duration: 0.70, amplitude: 0.11, decay: 5),
                    Note(
                        frequency: 440 * 2.756, start: 0, duration: 0.45, amplitude: 0.04, decay: 8),
                ], 0.75
            )
        }
    }

    /// Render one kind as mono Int16 PCM inside a canonical 44-byte WAV
    /// header — directly playable by `AVAudioPlayer(data:)`.
    private static func wavData(for kind: Kind) -> Data? {
        let (notes, total) = notes(for: kind)
        let frameCount = Int(total * sampleRate)
        guard frameCount > 0 else { return nil }

        // Samples
        var samples = [Int16](repeating: 0, count: frameCount)
        let attack: Double = 0.008
        for frame in 0..<frameCount {
            let t = Double(frame) / sampleRate
            var value: Double = 0
            for note in notes {
                let local = t - note.start
                guard local >= 0, local <= note.duration else { continue }
                let rampUp: Double = min(1, local / attack)
                let fade: Double = exp(-note.decay * local)
                let phase: Double = 2 * Double.pi * note.frequency * local
                value += Double(note.amplitude) * rampUp * fade * sin(phase)
            }
            samples[frame] = Int16(max(-1, min(1, value)) * Double(Int16.max))
        }

        // Canonical WAV header (mono, 16-bit, 44.1 kHz).
        let byteRate = UInt32(sampleRate) * 2
        let dataLen = UInt32(frameCount * 2)
        var wav = Data(capacity: 44 + frameCount * 2)
        func append<T>(_ value: T) {
            withUnsafeBytes(of: value) { wav.append(contentsOf: $0) }
        }
        wav.append(contentsOf: Array("RIFF".utf8))
        append(UInt32(36 + dataLen))  // chunk size
        wav.append(contentsOf: Array("WAVE".utf8))
        wav.append(contentsOf: Array("fmt ".utf8))
        append(UInt32(16))  // fmt chunk size
        append(UInt16(1))  // PCM
        append(UInt16(1))  // mono
        append(UInt32(sampleRate))
        append(byteRate)
        append(UInt16(2))  // block align
        append(UInt16(16))  // bits per sample
        wav.append(contentsOf: Array("data".utf8))
        append(dataLen)
        samples.withUnsafeBytes { wav.append(contentsOf: $0) }
        return wav
    }
}
