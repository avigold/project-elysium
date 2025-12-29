import Foundation

final class GameStoreModel: ObservableObject {
    @Published var state: GameState = .freshDefault()

    func newGame(from deck: [GoalCard]) {
        state = GameState.newGame(from: deck)
    }

    func attemptCast(_ id: UUID) -> Bool {
        state.attemptCast(goalId: id)
    }

    func toggleTap(_ id: UUID) {
        state.toggleTapEnergy(id)
    }

    func setCriterion(goalId: UUID, index: Int, done: Bool) {
        state.setCriterionDone(goalId: goalId, index: index, done: done)
    }
}
