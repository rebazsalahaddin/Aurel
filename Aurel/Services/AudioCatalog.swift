import Foundation

// MARK: - The bundled audio catalog (audio-upgrade phase, Enhancement doc §2)
//
// `tools/generate-audio.mjs` synthesizes the authored AUDIO_STYLE_GUIDE
// scripts with the course's character→voice cast and writes, into the app
// bundle:
//
//   Audio/<ASSET>_L<n>.m4a        one file per scripted line
//   Audio/audio-catalog.json      asset → line files + speaker/voice/text/duration
//
// The app resolves its authored `aud` references ("AUD043") through this
// catalog and plays the bundled takes offline. A missing catalog or asset is
// never an error — call sites fall back to the TTS stand-in.

struct AudioCatalog {
    struct Line: Decodable, Hashable {
        let file: String
        let speaker: String
        let voice: String
        let text: String
        let dur: Double
        let wpm: Int?
    }

    struct Asset: Decodable, Hashable {
        let id: String
        let purpose: String
        let delivery: String
        let src: String?
        let lines: [Line]
        let text: String
        let duration: Double
        let aliasOf: String?
    }

    private let byId: [String: Asset]
    private let bundle: Bundle

    /// Loads from the main bundle; an absent or malformed catalog yields an
    /// empty catalog (every lookup misses → TTS fallback) — launch-safe by
    /// construction, and PH03's no-audio-APIs-at-launch rule is untouched
    /// because loading only decodes JSON.
    init(bundle: Bundle = .main) {
        self.bundle = bundle
        guard
            let url = bundle.url(forResource: "audio-catalog", withExtension: "json"),
            let data = try? Data(contentsOf: url),
            let decoded = try? JSONDecoder().decode(Assets.self, from: data)
        else {
            byId = [:]
            return
        }
        byId = Dictionary(decoded.assets.map { ($0.id, $0) }, uniquingKeysWith: { a, _ in a })
    }

    /// Data initializer keeps catalog decoding independently testable without
    /// requiring an app bundle fixture.
    init(data: Data, bundle: Bundle = .main) throws {
        self.bundle = bundle
        let decoded = try JSONDecoder().decode(Assets.self, from: data)
        byId = Dictionary(decoded.assets.map { ($0.id, $0) }, uniquingKeysWith: { a, _ in a })
    }

    private struct Assets: Decodable {
        let assets: [Asset]
    }

    var isEmpty: Bool { byId.isEmpty }
    var assets: [Asset] { byId.values.sorted { $0.id < $1.id } }

    /// Direct lookup by full asset id ("A1-C01-AUD043").
    func asset(_ id: String) -> Asset? {
        byId[id]
    }

    /// Chapter-scoped resolution of the course bank's short references:
    /// "AUD043" + chapter "A1-C01" → "A1-C01-AUD043".
    func asset(aud: String, chapter: String) -> Asset? {
        if aud.contains("-AUD") { return asset(aud) }
        return asset("\(chapter)-\(aud)")
    }

    /// The on-disk URL for one bundled line take (bundle-root resources).
    func url(for line: Line) -> URL? {
        let name = line.file.hasSuffix(".m4a") ? String(line.file.dropLast(4)) : line.file
        return bundle.url(forResource: name, withExtension: "m4a")
            ?? bundle.url(forResource: name, withExtension: "m4a", subdirectory: "Audio")
            ?? bundle.url(
                forResource: name, withExtension: "m4a", subdirectory: "Resources/Audio")
    }
}
