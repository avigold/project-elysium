import SwiftUI

struct ArtBadgeView: View {
    let artKey: String

    private var resolvedKey: String {
        artKey.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
    }

    var body: some View {
        let shape = RoundedRectangle(cornerRadius: 6, style: .continuous)

        ZStack {
            shape
                .fill(backgroundFill)
                .overlay(
                    shape.strokeBorder(.primary.opacity(0.15), lineWidth: 1)
                )

            if NSImage(named: resolvedKey) != nil {
                Image(resolvedKey)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 44, height: 44)
                    .clipped()
                    .mask(shape)
            } else {
                VStack(spacing: 4) {
                    Image(systemName: symbolName)
                        .font(.system(size: 18, weight: .semibold))
                    Text(shortLabel)
                        .font(.caption2)
                        .fontWeight(.semibold)
                }
                .foregroundStyle(.primary.opacity(0.85))
            }
        }
        .frame(width: 44, height: 44)
        .accessibilityLabel(Text("Card art \(resolvedKey)"))
    }

    private var shortLabel: String {
        if resolvedKey.isEmpty { return "ART" }
        return String(resolvedKey.prefix(4)).uppercased()
    }

    private var symbolName: String {
        switch resolvedKey {
        case "laurel": return "leaf"
        case "column": return "building.columns"
        case "mask": return "theatermasks"
        case "owl": return "bird"
        case "helm": return "shield.lefthalf.filled"
        default: return "photo"
        }
    }

    private var backgroundFill: some ShapeStyle {
        switch resolvedKey {
        case "laurel": return AnyShapeStyle(Color.elysiumPaper.opacity(0.22))
        case "column": return AnyShapeStyle(Color.elysiumPaper.opacity(0.20))
        case "mask": return AnyShapeStyle(Color.elysiumPaper.opacity(0.18))
        case "owl": return AnyShapeStyle(Color.elysiumPaper.opacity(0.20))
        case "helm": return AnyShapeStyle(Color.elysiumPaper.opacity(0.19))
        default: return AnyShapeStyle(.secondary.opacity(0.15))
        }
    }
}
