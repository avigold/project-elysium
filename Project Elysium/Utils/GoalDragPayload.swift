import SwiftUI

struct GoalDragPayload: Transferable, Codable, Hashable {
    let goalId: UUID

    static var transferRepresentation: some TransferRepresentation {
        CodableRepresentation(contentType: .data)
    }
}
