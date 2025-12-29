import SwiftUI

struct ArtBadgeView: View {
    let artKey: String

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 6, style: .continuous)
                .fill(backgroundFill)
                .overlay(
                    RoundedRectangle(cornerRadius: 6, style: .continuous)
                        .strokeBorder(.primary.opacity(0.15), lineWidth: 1)
                )

            VStack(spacing: 4) {
                Image(systemName: symbolName)
                    .font(.system(size: 18, weight: .semibold))
                Text(shortLabel)
                    .font(.caption2)
                    .fontWeight(.semibold)
            }
            .foregroundStyle(.primary.opacity(0.85))
        }
        .frame(width: 44, height: 44)
        .accessibilityLabel(Text("Card art \(artKey)"))
    }

    private var shortLabel: String {
        let trimmed = artKey.trimmingCharacters(in: .whitespacesAndNewlines)
        if trimmed.isEmpty { return "Art" }
        return String(trimmed.prefix(4)).uppercased()
    }

    private var symbolName: String {
        switch artKey.lowercased() {
        case "athena": return "shield.lefthalf.filled"
        case "ares": return "flame"
        case "apollo": return "sun.max"
        case "poseidon": return "drop"
        case "hades": return "moon.stars"
        case "hermes": return "wind"
        case "zeus": return "bolt"
        default: return "photo"
        }
    }

    private var backgroundFill: some ShapeStyle {
        switch artKey.lowercased() {
        case "athena": return AnyShapeStyle(.blue.opacity(0.20))
        case "ares": return AnyShapeStyle(.red.opacity(0.20))
        case "apollo": return AnyShapeStyle(.yellow.opacity(0.20))
        case "poseidon": return AnyShapeStyle(.cyan.opacity(0.20))
        case "hades": return AnyShapeStyle(.purple.opacity(0.20))
        case "hermes": return AnyShapeStyle(.mint.opacity(0.20))
        case "zeus": return AnyShapeStyle(.orange.opacity(0.20))
        default: return AnyShapeStyle(.secondary.opacity(0.15))
        }
    }
}

struct ArtBadgeView_Previews: PreviewProvider {
    static var previews: some View {
        HStack(spacing: 12) {
            ArtBadgeView(artKey: "Athena")
            ArtBadgeView(artKey: "Ares")
            ArtBadgeView(artKey: "Apollo")
            ArtBadgeView(artKey: "Poseidon")
            ArtBadgeView(artKey: "Hades")
            ArtBadgeView(artKey: "Hermes")
            ArtBadgeView(artKey: "Zeus")
            ArtBadgeView(artKey: "Unknown")
        }
        .padding()
        .previewLayout(.sizeThatFits)
    }
}
