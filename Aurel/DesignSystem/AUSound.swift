import AVFoundation

// MARK: - Feedback sounds (IMPROVEMENT_PLAN.md §2.6)
//
// "Soft and sparse" (the Settings copy). Four authored sounds, synthesized
// on device at runtime — quiet sine partials with soft envelopes. No
// recorded assets, nothing fabricated: these are UI feedback, not course
// audio. Gated by Settings → Sound (`SwitchPrefs.sound`) and silenced while
// the TTS speaker is talking.

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
    /// changes (and once at launch from the persisted preference).
    var isEnabled = true

    /// Set by `Speaker` while TTS is talking — feedback sounds never
    /// speak over the voice.
    var isDucked = false

    /// Test-visible: how many sounds passed the gates since launch.
    private(set) var playCount = 0

    private var engine: AVAudioEngine?
    private var player: AVAudioPlayerNode?
    private var buffers: [Kind: AVAudioPCMBuffer] = [:]

    private static let sampleRate: Double = 44_100

    func correct() { play(.correct) }
    func miss() { play(.miss) }
    func complete() { play(.complete) }
    func milestone() { play(.milestone) }

    /// Starts the audio graph once (from RootView). If audio hardware is
    /// unavailable — unit tests, some simulators — sounds stay silently off
    /// and haptics alone carry the feedback; the play decisions are still
    /// counted so the gates remain testable.
    func activate() {
        guard engine == nil else { return }
        let e = AVAudioEngine()
        let p = AVAudioPlayerNode()
        e.attach(p)
        guard
            let format = AVAudioFormat(
                standardFormatWithSampleRate: Self.sampleRate, channels: 1)
        else { return }
        e.connect(p, to: e.mainMixerNode, format: format)
        do {
            try e.start()
            p.play()
            engine = e
            player = p
        } catch {
            // Leave engine nil — decisions still count, audio stays off.
        }
    }

    private func play(_ kind: Kind) {
        guard isEnabled, !isDucked else { return }
        playCount += 1
        guard let player, let buffer = buffer(for: kind) else { return }
        player.scheduleBuffer(buffer, completionHandler: nil)
    }

    private func buffer(for kind: Kind) -> AVAudioPCMBuffer? {
        if let cached = buffers[kind] { return cached }
        guard
            let format = AVAudioFormat(
                standardFormatWithSampleRate: Self.sampleRate, channels: 1),
            let rendered = Self.render(kind, format: format)
        else { return nil }
        buffers[kind] = rendered
        return rendered
    }

    // MARK: Synthesis — quiet sine partials with soft envelopes.

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
                    Note(frequency: 659.25, start: 0.09, duration: 0.12, amplitude: 0.14, decay: 16),
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
                    Note(frequency: 659.25, start: 0.10, duration: 0.11, amplitude: 0.14, decay: 15),
                    Note(frequency: 783.99, start: 0.20, duration: 0.16, amplitude: 0.15, decay: 13),
                ], 0.38
            )
        case .milestone:
            // A warm bell: the fundamental plus one inharmonic partial.
            return (
                [
                    Note(frequency: 440, start: 0, duration: 0.70, amplitude: 0.11, decay: 5),
                    Note(frequency: 440 * 2.756, start: 0, duration: 0.45, amplitude: 0.04, decay: 8),
                ], 0.75
            )
        }
    }

    private static func render(_ kind: Kind, format: AVAudioFormat) -> AVAudioPCMBuffer? {
        let (notes, total) = notes(for: kind)
        let frames = AVAudioFrameCount(total * format.sampleRate)
        guard frames > 0,
            let buffer = AVAudioPCMBuffer(pcmFormat: format, frameCapacity: frames),
            let channel = buffer.floatChannelData?[0]
        else { return nil }
        buffer.frameLength = frames
        let sr = format.sampleRate
        let attack: Double = 0.008
        for frame in 0..<Int(frames) {
            let t = Double(frame) / sr
            var sample: Float = 0
            for note in notes {
                let local = t - note.start
                guard local >= 0, local <= note.duration else { continue }
                // Explicit sub-expressions — the compound form defeats the
                // type-checker across the Float/Double boundary.
                let rampUp: Double = min(1, local / attack)
                let fade: Double = exp(-note.decay * local)
                let phase: Double = 2 * Double.pi * note.frequency * local
                sample += note.amplitude * Float(rampUp * fade * sin(phase))
            }
            channel[frame] = sample
        }
        return buffer
    }
}
