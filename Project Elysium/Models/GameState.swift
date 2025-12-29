import Foundation

struct GameState: Codable {
    var goals: [GoalCard]
    var energies: [EnergyCard]

    /// Sorting rules you control for snap placement (simple version now)
    var battlefieldGoalOrder: [UUID]
    var criteriaDone: [UUID: Set<Int>] = [:]

    static func freshDefault() -> GameState {
        // 5 energy cards, one per type
        let energies: [EnergyCard] = EnergyType.allCases.map { EnergyCard(type: $0) }

        // Start with empty deck/hand; we’ll add deckbuilder first
        return GameState(goals: [], energies: energies, battlefieldGoalOrder: [])
    }
    
    mutating func drawToHand(target: Int) {
        while goals.filter({ $0.zone == .hand }).count < target,
              let idx = goals.firstIndex(where: { $0.zone == .stack }) {
            goals[idx].zone = .hand
        }
    }
    
    static func newGame(from deck: [GoalCard]) -> GameState {
        let energies = EnergyType.allCases.map { EnergyCard(type: $0) }

        // Deterministic order: whatever order deck already is in.
        let stack = deck.map { c -> GoalCard in
            let g = c.copy()
            g.zone = .stack
            return g
        }

        var gs = GameState(goals: stack, energies: energies, battlefieldGoalOrder: [])
        gs.drawToHand(target: 7)
        return gs
    }
    
    mutating func attemptCast(goalId: UUID) -> Bool {
        guard let gIdx = goals.firstIndex(where: { $0.id == goalId }) else { return false }
        guard goals[gIdx].zone == .hand else { return false }

        // Validate + allocate
        var allocation: [UUID] = []

        for type in [EnergyType.soma, .nous, .eros, .thumos, .schole] {
            let needed = max(0, goals[gIdx].energyCost[type] ?? 0)
            guard needed > 0 else { continue }

            let available = energies.filter { $0.type == type && !$0.isTapped && $0.boundGoalId == nil }
            if available.count < needed { return false }
            allocation.append(contentsOf: available.prefix(needed).map(\.id))
        }

        // Commit
        goals[gIdx].zone = .battlefield
        battlefieldGoalOrder.append(goals[gIdx].id)

        for eid in allocation {
            if let eIdx = energies.firstIndex(where: { $0.id == eid }) {
                energies[eIdx].isTapped = true
                energies[eIdx].boundGoalId = goals[gIdx].id
            }
        }

        drawToHand(target: 7)
        return true
    }
    
    mutating func toggleTapEnergy(_ energyId: UUID) {
        guard let idx = energies.firstIndex(where: { $0.id == energyId }) else { return }
        guard energies[idx].boundGoalId == nil else { return }
        energies[idx].isTapped.toggle()
    }
    
    mutating func setCriterionDone(goalId: UUID, index: Int, done: Bool) {
            var set = criteriaDone[goalId] ?? Set<Int>()
            if done { set.insert(index) } else { set.remove(index) }
            criteriaDone[goalId] = set

            if isGoalComplete(goalId: goalId) {
                completeGoal(goalId: goalId)
            }
        }

    func isGoalComplete(goalId: UUID) -> Bool {
        guard let g = goals.first(where: { $0.id == goalId }) else { return false }
        let done = criteriaDone[goalId] ?? []
        return !g.acceptanceCriteria.isEmpty && done.count == g.acceptanceCriteria.count
    }

    mutating func completeGoal(goalId: UUID) {
        guard let gIdx = goals.firstIndex(where: { $0.id == goalId }) else { return }
        guard goals[gIdx].zone == .battlefield else { return }

        goals[gIdx].zone = .elysium
        battlefieldGoalOrder.removeAll { $0 == goalId }

        for i in energies.indices where energies[i].boundGoalId == goalId {
            energies[i].boundGoalId = nil
            energies[i].isTapped = false
        }
    }
}
