import Foundation
import UniformTypeIdentifiers

struct DragPayload: Codable {
    let goalId: UUID
}

enum DragTypes {
    static let goalCardUTType: UTType = UTType(exportedAs: "com.projectelysium.goalcard")
}
