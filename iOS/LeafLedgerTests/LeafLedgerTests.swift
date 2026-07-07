import XCTest
@testable import LeafLedger

@MainActor
final class LeafLedgerTests: XCTestCase {
    var store: LeafLedgerStore!

    override func setUp() {
        super.setUp()
        store = LeafLedgerStore()
    }

    func testSeedDataLoadedOnFreshInstall() {
        XCTAssertFalse(store.entries.isEmpty)
    }

    func testSeedCountIsBelowFreeLimit() {
        XCTAssertLessThan(LeafLedgerStore.seedData().count, LeafLedgerStore.freeLimit)
    }

    func testAddEntrySucceedsUnderLimit() {
        let before = store.entries.count
        let added = store.add(PlantEntry(name: "Test Entry", detail: "Detail", date: Date()))
        XCTAssertTrue(added)
        XCTAssertEqual(store.entries.count, before + 1)
    }

    func testAddEntryFailsAtLimit() {
        while store.canAddMore {
            store.add(PlantEntry(name: "Filler", detail: "x", date: Date()))
        }
        let added = store.add(PlantEntry(name: "Overflow", detail: "x", date: Date()))
        XCTAssertFalse(added)
        XCTAssertEqual(store.entries.count, LeafLedgerStore.freeLimit)
    }

    func testDeleteEntry() {
        let entry = PlantEntry(name: "ToDelete", detail: "x", date: Date())
        store.add(entry)
        let before = store.entries.count
        store.delete(entry)
        XCTAssertEqual(store.entries.count, before - 1)
    }

    func testUpdateEntry() {
        var entry = PlantEntry(name: "Original", detail: "x", date: Date())
        store.add(entry)
        entry.name = "Updated"
        store.update(entry)
        XCTAssertEqual(store.entries.first(where: { $0.id == entry.id })?.name, "Updated")
    }

    func testToggleFavorite() {
        let entry = PlantEntry(name: "Fav", detail: "x", date: Date())
        store.add(entry)
        store.toggleFavorite(entry)
        XCTAssertTrue(store.entries.first(where: { $0.id == entry.id })?.isFavorite ?? false)
    }

    func testCanAddMoreReflectsLimit() {
        XCTAssertTrue(store.canAddMore)
    }
}
