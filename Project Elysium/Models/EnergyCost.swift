import Foundation

struct EnergyCost: Codable, Equatable {
    /// Persist by type name, render by glyph.
    var amounts: [EnergyType: Int]

    init(_ amounts: [EnergyType: Int] = [:]) {
        self.amounts = amounts.filter { $0.value > 0 }
    }

    var total: Int {
        amounts.values.reduce(0, +)
    }

    /// Example: ΣΣΕΘΝ (order defined here)
    var glyphString: String {
        EnergyType.allCases.compactMap { type in
            let n: Int = amounts[type] ?? 0
            guard n > 0 else { return nil }
            return String(repeating: type.glyph, count: n)
        }.joined()
    }

    func requires(_ type: EnergyType) -> Int {
        amounts[type] ?? 0
    }
}
