import Foundation

struct GameState: Codable {
    var goals: [GoalCard]
    var energies: [EnergyCard]

    /// Sorting rules you control for snap placement (simple version now)
    var battlefieldGoalOrder: [UUID]

    static func freshDefault() -> GameState {
        // 5 energy cards, one per type
        let energies: [EnergyCard] = EnergyType.allCases.map { EnergyCard(type: $0) }

        // Start with empty deck/hand; we’ll add deckbuilder first
        return GameState(goals: [], energies: energies, battlefieldGoalOrder: [])
    }
}
