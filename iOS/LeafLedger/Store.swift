import Foundation
import Combine

@MainActor
final class LeafLedgerStore: ObservableObject {
    @Published private(set) var entries: [PlantEntry] = []

    /// Free-tier cap. Deliberately set above the seed-data count so a fresh
    /// install never trips the paywall immediately.
    static let freeLimit = 15

    private let fileName = "leafledger_entries.json"

    private var fileURL: URL {
        let dir = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask)[0]
        if !FileManager.default.fileExists(atPath: dir.path) {
            try? FileManager.default.createDirectory(at: dir, withIntermediateDirectories: true)
        }
        return dir.appendingPathComponent(fileName)
    }

    init() {
        load()
    }

    var canAddMore: Bool {
        entries.count < Self.freeLimit
    }

    @discardableResult
    func add(_ entry: PlantEntry) -> Bool {
        guard canAddMore else { return false }
        entries.append(entry)
        save()
        return true
    }

    func update(_ entry: PlantEntry) {
        guard let idx = entries.firstIndex(where: { $0.id == entry.id }) else { return }
        entries[idx] = entry
        save()
    }

    func delete(at offsets: IndexSet) {
        entries.remove(atOffsets: offsets)
        save()
    }

    func delete(_ entry: PlantEntry) {
        entries.removeAll { $0.id == entry.id }
        save()
    }

    func toggleFavorite(_ entry: PlantEntry) {
        guard let idx = entries.firstIndex(where: { $0.id == entry.id }) else { return }
        entries[idx].isFavorite.toggle()
        save()
    }

    private func load() {
        if let data = try? Data(contentsOf: fileURL),
           let decoded = try? JSONDecoder().decode([PlantEntry].self, from: data) {
            entries = decoded
        } else {
            entries = Self.seedData()
            save()
        }
    }

    private func save() {
        guard let data = try? JSONEncoder().encode(entries) else { return }
        try? data.write(to: fileURL, options: .atomic)
    }

    static func seedData() -> [PlantEntry] {
        [
            PlantEntry(name: "Fernando", detail: "Boston Fern", date: Calendar.current.date(byAdding: .day, value: -3, to: Date()) ?? Date()),
            PlantEntry(name: "Monty", detail: "Monstera Deliciosa", date: Calendar.current.date(byAdding: .day, value: -6, to: Date()) ?? Date()),
            PlantEntry(name: "Sunny", detail: "Snake Plant", date: Calendar.current.date(byAdding: .day, value: -14, to: Date()) ?? Date())
        ]
    }
}
