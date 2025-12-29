import Foundation
import SwiftUI

@MainActor
final class GameViewModel: ObservableObject {
    @Published private(set) var state: GameState

    init(store: SaveStore = .shared) {
        self.state = store.load()
        self.store = store
    }

    private let store: SaveStore

    func persist() {
        store.save(state)
    }

    // MARK: - Derived collections

    var stack: [GoalCard] { state.goals.filter { $0.zone == .stack } }
    var hand: [GoalCard] { state.goals.filter { $0.zone == .hand } }
    var battlefield: [GoalCard] { state.goals.filter { $0.zone == .battlefield } }
    var elysium: [GoalCard] { state.goals.filter { $0.zone == .elysium } }

    // MARK: - Core actions

    func addGoalToStack(title: String, details: String, cost: EnergyCost, art: String?) {
        let goal: GoalCard = GoalCard(title: title, details: details, energyCost: cost.amounts, artKey: art ?? "laurel", zone: .stack)
        state.goals.append(goal)
        persist()
    }

    func drawUpToHandSize(_ max: Int = 7) {
        guard hand.count < max else { return }
        let needed: Int = max - hand.count
        let candidates: [GoalCard] = stack

        guard !candidates.isEmpty else { return }

        // Stack is user-sortable; for now draw from top = first element
        let drawn: [GoalCard] = Array(candidates.prefix(needed))
        for g in drawn {
            moveGoal(g.id, to: .hand)
        }
        persist()
    }

    func moveGoal(_ id: UUID, to zone: GoalCard.Zone) {
        guard let idx: Int = state.goals.firstIndex(where: { $0.id == id }) else { return }
        state.goals[idx].zone = zone

        if zone == .battlefield {
            if !state.battlefieldGoalOrder.contains(id) {
                state.battlefieldGoalOrder.append(id)
            }
        }
        if zone == .elysium {
            state.battlefieldGoalOrder.removeAll { $0 == id }
        }
    }

    // Casting a goal: bind/tap energies, move to battlefield, then redraw
    func castGoalFromHand(_ goalId: UUID) -> Bool {
        guard let goal: GoalCard = state.goals.first(where: { $0.id == goalId }),
              goal.zone == .hand else { return false }

        let plan: [(EnergyType, Int)] = EnergyType.allCases.map { type in
            (type, max(0, goal.energyCost[type] ?? 0))
        }
        var energiesToTap: [UUID] = []

        for (type, needed) in plan {
            guard needed > 0 else { continue }
            let available: [EnergyCard] = state.energies.filter { $0.type == type && $0.isTapped == false }
            guard available.count >= needed else { return false }
            energiesToTap.append(contentsOf: available.prefix(needed).map(\.id))
        }

        for eId in energiesToTap {
            guard let eIdx: Int = state.energies.firstIndex(where: { $0.id == eId }) else { continue }
            state.energies[eIdx].isTapped = true
            state.energies[eIdx].boundGoalId = goalId
        }

        moveGoal(goalId, to: .battlefield)
        drawUpToHandSize(7)
        persist()
        return true
    }

    func toggleTapEnergy(_ energyId: UUID) {
        guard let idx: Int = state.energies.firstIndex(where: { $0.id == energyId }) else { return }

        // Bound energies remain tapped until the bound goal is completed and moved to Elysium.
        if state.energies[idx].boundGoalId != nil { return }

        state.energies[idx].isTapped.toggle()
        persist()
    }

    func completeGoal(_ goalId: UUID) {
        guard let gIdx: Int = state.goals.firstIndex(where: { $0.id == goalId }) else { return }
        let goal = state.goals[gIdx]
        
        // release energies bound to this goal
        for eIdx in state.energies.indices {
            if state.energies[eIdx].boundGoalId == goalId {
                state.energies[eIdx].isTapped = false
                state.energies[eIdx].boundGoalId = nil
            }
        }

        persist()
    }
}
