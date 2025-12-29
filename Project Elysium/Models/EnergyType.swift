enum EnergyType: String, CaseIterable, Identifiable, Codable {
    case soma      // Σ
    case nous      // Ν
    case eros      // Ε
    case thumos    // Θ
    case schole    // Χ

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .soma: return "Soma"
        case .nous: return "Nous"
        case .eros: return "Eros"
        case .thumos: return "Thumos"
        case .schole: return "Scholē"
        }
    }

    /// Greek-letter glyph used on cards and in casting costs
    var glyph: String {
        switch self {
        case .soma: return "Σ"
        case .nous: return "Ν"
        case .eros: return "Ε"
        case .thumos: return "Θ"
        case .schole: return "Χ"
        }
    }
}
