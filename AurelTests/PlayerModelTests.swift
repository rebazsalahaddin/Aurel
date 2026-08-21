import XCTest

@testable import Aurel

/// Player item-gate mechanics (S0-002 regression).
///
/// `itemCanGo` ports `v.canGo` (CourseScreen.dc.html:1489–1490) with the
/// order-item override at line 1590 (`if (itemOrder) { v.canGo =
/// v.tileCorrect }`) that the original port dropped — order-kind items inside
/// non-quiet practice screens then gated on `done`, which only `pick()` sets,
/// and the lesson could never be completed.
@MainActor
final class PlayerModelTests: XCTestCase {
    private func model(atScreen screenId: String) throws -> PlayerModel {
        let store = CourseDecodingTests.store
        let pos = try XCTUnwrap(
            store.flat.firstIndex { $0.screen.id == screenId },
            "\(screenId) not found in the course")
        return PlayerModel(course: store, start: pos)
    }

    /// C1-L2 S14 — first order item (PR-G012, tiles ["I'm","Maya","."]):
    /// Go-on must be gated until the tiles are ordered correctly.
    func testOrderItemGatesGoOnUntilCorrect() throws {
        let m = try model(atScreen: "S14")
        let orderIdx = try XCTUnwrap(
            m.items.firstIndex { $0.kind == "order" }, "S14 must carry an order item")
        m.i = orderIdx
        let tiles = m.tileTask.tiles
        XCTAssertFalse(tiles.isEmpty, "order item must have tiles")

        // Fresh item: gated.
        XCTAssertFalse(m.itemCanGo, "fresh order item must gate Go-on")

        // Complete every tile but in the wrong order: still gated.
        for k in stride(from: tiles.count - 1, through: 0, by: -1) { m.toggleTile(k) }
        XCTAssertTrue(m.tileComplete)
        if tiles.reversed() != m.tileTask.key {
            XCTAssertFalse(m.tileCorrect)
            XCTAssertFalse(m.itemCanGo, "a wrong ordering must keep Go-on gated")
        }

        // Correct order (indexes of the key tiles): enabled.
        m.order = m.tileTask.key.compactMap { key in tiles.firstIndex(of: key) }
        XCTAssertTrue(m.tileCorrect, "key \(m.tileTask.key) over tiles \(tiles)")
        XCTAssertTrue(m.itemCanGo, "the correct ordering must enable Go-on (S0-002)")
    }

    /// Option items keep the authored gate: `done || quiet` — and the retry
    /// ladder still reveals after three wrong picks (repeats count; S14's
    /// items carry only two distinct distractors).
    func testOptionItemGateMatchesAuthoredRule() throws {
        let m = try model(atScreen: "S14")
        let idx = try XCTUnwrap(
            m.items.firstIndex { ($0.kind == nil || $0.kind != "order") && !$0.opts.isEmpty },
            "S14 must carry an option item")
        m.i = idx
        guard let item = m.item else {
            return XCTFail("item vanished")
        }
        let opts = item.opts
        XCTAssertFalse(m.isQuiet, "S14 is a practice screen — not quiet")
        XCTAssertFalse(m.itemCanGo, "fresh option item must gate Go-on")

        // Miss the same distractor three times: the ladder reveals.
        let key = item.key?.single
        guard let distractor = opts.first(where: { $0.text != key && $0.id != key }) else {
            return XCTFail("no distractor found")
        }
        for _ in 0..<3 { m.pick(distractor, item: item) }
        XCTAssertEqual(m.wrong, 3)
        XCTAssertTrue(m.done, "third miss reveals")
        XCTAssertTrue(m.itemCanGo, "revealed item must let the learner go on")
    }

    /// Quiz screens stay quiet for option items, but order items follow the
    /// tile rule everywhere — line 1590's override is unconditional
    /// (`if (itemOrder) { v.canGo = v.tileCorrect }`).
    func testQuizOrderItemFollowsTileRule() throws {
        let m = try model(atScreen: "S33")  // C1-L4 quiz: QZ-CN002/QZ-WR001
        let orderIdx = try XCTUnwrap(
            m.items.firstIndex { $0.kind == "order" }, "S33 must carry an order item")
        m.i = orderIdx
        XCTAssertTrue(m.isQuiet, "quiz screens are quiet")
        XCTAssertFalse(m.itemCanGo, "fresh order item gates Go-on even in a quiz")

        let tiles = m.tileTask.tiles
        m.order = m.tileTask.key.compactMap { key in tiles.firstIndex(of: key) }
        XCTAssertTrue(m.tileCorrect)
        XCTAssertTrue(m.itemCanGo, "the correct ordering enables Go-on in a quiz too")
    }

    /// Every order item inside a practice screen must have a correct ordering
    /// that enables Go-on — the property that makes every lesson completable.
    func testEveryPracticeOrderItemIsCompletable() throws {
        let store = CourseDecodingTests.store
        for f in store.flat {
            guard case .practice = f.screen.payload else { continue }
            let pos = try XCTUnwrap(
                store.flat.firstIndex { $0.screen.id == f.screen.id })
            let m = PlayerModel(course: store, start: pos)
            for (idx, it) in m.items.enumerated() where it.kind == "order" {
                m.i = idx
                let tiles = m.tileTask.tiles
                m.order = m.tileTask.key.compactMap { key in tiles.firstIndex(of: key) }
                XCTAssertTrue(
                    m.tileCorrect,
                    "\(f.screen.id) · \(it.id): key \(m.tileTask.key) "
                        + "unreachable over tiles \(tiles)")
                XCTAssertTrue(m.itemCanGo, "\(f.screen.id) · \(it.id) must be passable")
            }
        }
    }
}
