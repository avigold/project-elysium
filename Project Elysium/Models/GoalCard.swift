import Foundation
import SwiftUI

final class GoalCard: ObservableObject, Identifiable, Codable {
    enum Zone: String, Codable {
        case stack
        case hand
        case battlefield
        case elysium
    }

    enum CodingKeys: CodingKey {
        case id, title, details, acceptanceCriteria, energyCost, artKey, zone
    }

    @Published var id: UUID
    @Published var title: String
    @Published var details: String
    @Published var acceptanceCriteria: [String]
    /// Keyed by energy type (stable). Values are explicit quantities.
    @Published var energyCost: [EnergyType: Int]
    /// A lightweight art selector; map this to bundled assets later.
    @Published var artKey: String
    @Published var zone: Zone

    init(
        id: UUID = UUID(),
        title: String = "",
        details: String = "",
        acceptanceCriteria: [String] = [],
        energyCost: [EnergyType: Int] = [:],
        artKey: String = "laurel",
        zone: Zone = .stack
    ) {
        self.id = id
        self.title = title
        self.details = details
        self.acceptanceCriteria = acceptanceCriteria
        self.energyCost = energyCost
        self.artKey = artKey
        self.zone = zone
    }

    // MARK: Codable (manual because of @Published)
    required init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        id = try c.decode(UUID.self, forKey: .id)
        title = try c.decode(String.self, forKey: .title)
        details = try c.decode(String.self, forKey: .details)
        acceptanceCriteria = try c.decode([String].self, forKey: .acceptanceCriteria)
        energyCost = try c.decode([EnergyType: Int].self, forKey: .energyCost)
        artKey = try c.decode(String.self, forKey: .artKey)
        zone = try c.decode(Zone.self, forKey: .zone)
    }

    func encode(to encoder: Encoder) throws {
        var c = encoder.container(keyedBy: CodingKeys.self)
        try c.encode(id, forKey: .id)
        try c.encode(title, forKey: .title)
        try c.encode(details, forKey: .details)
        try c.encode(acceptanceCriteria, forKey: .acceptanceCriteria)
        try c.encode(energyCost, forKey: .energyCost)
        try c.encode(artKey, forKey: .artKey)
        try c.encode(zone, forKey: .zone)
    }

    func castingCostString() -> String {
        // Deterministic order
        let ordered: [EnergyType] = [.soma, .nous, .eros, .thumos, .schole]
        var out = ""
        for t in ordered {
            let n = max(0, energyCost[t] ?? 0)
            if n > 0 { out += String(repeating: t.glyph, count: n) }
        }
        return out.isEmpty ? "—" : out
    }
    
    func copy() -> GoalCard {
        GoalCard(
            title: title,
            details: details,
            acceptanceCriteria: acceptanceCriteria,
            energyCost: energyCost,
            artKey: artKey,
            zone: zone
        )
    }
}
