import Foundation

struct EnergyCard: Codable, Identifiable, Equatable {
    let id: UUID
    let type: EnergyType
    var isTapped: Bool
    var boundGoalId: UUID? // tapped until this goal reaches Elysium

    init(id: UUID = UUID(), type: EnergyType, isTapped: Bool = false, boundGoalId: UUID? = nil) {
        self.id = id
        self.type = type
        self.isTapped = isTapped
        self.boundGoalId = boundGoalId
    }
}
