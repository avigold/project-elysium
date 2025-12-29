import SwiftUI

final class DeckStoreModel: ObservableObject {
    @Published var cards: [GoalCard] = []
    @Published var selectedCardID: UUID?

    static let shared: DeckStoreModel = DeckStoreModel()

    private let fileURL: URL

    init() {
        let fm = FileManager.default
        let base = fm.urls(for: .applicationSupportDirectory, in: .userDomainMask).first!
        let dir = base.appendingPathComponent("ProjectElysium", isDirectory: true)
        try? fm.createDirectory(at: dir, withIntermediateDirectories: true)
        fileURL = dir.appendingPathComponent("deck.json")

        load()
        if cards.isEmpty {
            seed()
            save()
        }
        if selectedCardID == nil {
            selectedCardID = cards.first?.id
        }
    }

    func load() {
        guard let data = try? Data(contentsOf: fileURL) else { return }
        guard let decoded = try? JSONDecoder().decode([GoalCard].self, from: data) else { return }
        cards = decoded
    }

    func save() {
        guard let data = try? JSONEncoder().encode(cards) else { return }
        try? data.write(to: fileURL, options: [.atomic])
    }

    func addNewCard() {
        let c = GoalCard(title: "New Goal", details: "")
        cards.insert(c, at: 0)
        selectedCardID = c.id
        save()
    }

    func deleteSelected() {
        guard let id = selectedCardID else { return }
        cards.removeAll { $0.id == id }
        selectedCardID = cards.first?.id
        save()
    }

    func duplicateSelected() {
        guard let card = selectedCard else { return }
        let copy = card.copy()
        cards.insert(copy, at: 0)
        selectedCardID = copy.id
        save()
    }

    var selectedCard: GoalCard? {
        guard let id = selectedCardID else { return nil }
        return cards.first(where: { $0.id == id })
    }

    private func seed() {
        cards = [
            GoalCard(
                title: "Deep work block",
                details: "One uninterrupted block.",
                acceptanceCriteria: ["Phone away", "Single task", "Deliverable produced"],
                energyCost: [.nous: 1, .schole: 1],
                artKey: "column"
            ),
            GoalCard(
                title: "Workout",
                details: "Strength session.",
                acceptanceCriteria: ["Warm-up", "Main lifts done", "Cool-down"],
                energyCost: [.soma: 2],
                artKey: "laurel"
            ),
            GoalCard(
                title: "Difficult conversation",
                details: "Address the hard thing.",
                acceptanceCriteria: ["Agenda written", "Conversation done", "Next steps captured"],
                energyCost: [.thumos: 1, .eros: 1],
                artKey: "mask"
            )
        ]
    }
}
