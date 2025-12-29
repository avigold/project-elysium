import SwiftUI

struct CardPreviewView: View {
    @ObservedObject var card: GoalCard

    var body: some View {
        ZStack {
            cardFrame

            VStack(spacing: 10) {
                header
                artPanel
                rulesText
                criteria
                Spacer(minLength: 0)
                footer
            }
            .padding(14)
        }
        .frame(width: 310, height: 430)
    }

    // MARK: - Frame (warmer, more “card-like”)

    private var cardFrame: some View {
        let shape = RoundedRectangle(cornerRadius: 20, style: .continuous)

        return ZStack {
            // Warm parchment base
            shape
                .fill(
                    LinearGradient(
                        colors: [
                            Color(red: 0.98, green: 0.95, blue: 0.88), // warm parchment
                            Color(red: 0.92, green: 0.86, blue: 0.74)  // deeper warm
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )

            // Subtle inner glow
            shape
                .strokeBorder(Color.white.opacity(0.35), lineWidth: 1)

            // Soft vignette to add depth
            shape
                .fill(
                    RadialGradient(
                        colors: [
                            Color.black.opacity(0.00),
                            Color.black.opacity(0.10)
                        ],
                        center: .center,
                        startRadius: 40,
                        endRadius: 260
                    )
                )
                .blendMode(.multiply)
                .opacity(0.65)

            // Outer border
            shape
                .strokeBorder(Color(red: 0.55, green: 0.45, blue: 0.30).opacity(0.45), lineWidth: 1)

        }
        .shadow(color: .black.opacity(0.20), radius: 14, x: 0, y: 10)
        .overlay(
            // A slightly darker “bevel” inset to sell the card edge
            shape
                .inset(by: 2)
                .stroke(
                    LinearGradient(
                        colors: [
                            Color.black.opacity(0.10),
                            Color.white.opacity(0.10)
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    ),
                    lineWidth: 1
                )
        )
        .clipShape(shape)
    }

    // MARK: - Header

    private var header: some View {
        HStack(alignment: .firstTextBaseline, spacing: 10) {
            Text(card.title.isEmpty ? "Untitled Goal" : card.title)
                .font(.system(size: 18, weight: .semibold, design: .serif))
                .foregroundStyle(Color(red: 0.20, green: 0.16, blue: 0.10))
                .lineLimit(1)

            Spacer(minLength: 8)

            Text(card.castingCostString())
                .font(.system(size: 16, weight: .semibold, design: .rounded))
                .foregroundStyle(Color(red: 0.20, green: 0.16, blue: 0.10).opacity(0.95))
                .padding(.horizontal, 10)
                .padding(.vertical, 5)
                .background(
                    Capsule(style: .continuous)
                        .fill(Color.white.opacity(0.35))
                        .overlay(
                            Capsule(style: .continuous)
                                .strokeBorder(Color(red: 0.55, green: 0.45, blue: 0.30).opacity(0.35), lineWidth: 1)
                        )
                )
        }
    }

    private var artPanel: some View {
        let shape = RoundedRectangle(cornerRadius: 14, style: .continuous)

        return ZStack {
            shape
                .fill(.primary.opacity(0.06))

            if let nsImage = NSImage(named: card.artKey) {
                Image(nsImage: nsImage)
                    .resizable()
                    .scaledToFill()
                    .frame(height: 150)
                    .clipped()
                    .mask(shape)
            } else {
                // Only show the fallback overlay when the asset is missing
                VStack(spacing: 8) {
                    Image(systemName: "photo")
                        .font(.system(size: 22, weight: .semibold))
                        .foregroundStyle(.secondary)

                    Text(artSubtitle)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .frame(height: 150)
                .mask(shape)
            }

            shape
                .strokeBorder(.primary.opacity(0.12), lineWidth: 1)
        }
        .frame(height: 150)
    }

    private var boxBackground: some View {
        RoundedRectangle(cornerRadius: 12, style: .continuous)
            .fill(Color.white.opacity(0.28))
            .overlay(
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .strokeBorder(Color(red: 0.55, green: 0.45, blue: 0.30).opacity(0.22), lineWidth: 1)
            )
    }

    private var rulesText: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("Text")
                .font(.caption)
                .foregroundStyle(Color(red: 0.25, green: 0.20, blue: 0.14).opacity(0.65))

            Text(card.details.isEmpty ? "—" : card.details)
                .font(.system(size: 13, weight: .regular, design: .serif))
                .foregroundStyle(Color(red: 0.20, green: 0.16, blue: 0.10).opacity(0.92))
                .lineLimit(5)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(10)
        .background(boxBackground)
    }

    private var criteria: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("Acceptance")
                .font(.caption)
                .foregroundStyle(Color(red: 0.25, green: 0.20, blue: 0.14).opacity(0.65))

            if card.acceptanceCriteria.isEmpty {
                Text("—")
                    .font(.system(size: 12, design: .monospaced))
                    .foregroundStyle(Color(red: 0.25, green: 0.20, blue: 0.14).opacity(0.55))
            } else {
                VStack(alignment: .leading, spacing: 4) {
                    ForEach(Array(card.acceptanceCriteria.enumerated()), id: \.offset) { idx, item in
                        HStack(alignment: .firstTextBaseline, spacing: 8) {
                            Text("\(idx + 1).")
                                .font(.system(size: 12, weight: .semibold, design: .monospaced))
                                .foregroundStyle(Color(red: 0.25, green: 0.20, blue: 0.14).opacity(0.55))

                            Text(item)
                                .font(.system(size: 12, design: .serif))
                                .foregroundStyle(Color(red: 0.20, green: 0.16, blue: 0.10).opacity(0.90))
                                .lineLimit(2)
                        }
                    }
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(10)
        .background(boxBackground)
    }

    // MARK: - Footer

    private var footer: some View {
        HStack {
            Text("Project Elysium")
                .font(.caption2)
                .foregroundStyle(Color(red: 0.25, green: 0.20, blue: 0.14).opacity(0.55))

            Spacer()

            Text("Elysium • Goal")
                .font(.caption2)
                .foregroundStyle(Color(red: 0.25, green: 0.20, blue: 0.14).opacity(0.55))
        }
        .padding(.top, 2)
    }

    private var artSubtitle: String {
        let trimmed = card.artKey.trimmingCharacters(in: .whitespacesAndNewlines)
        return trimmed.isEmpty ? "Greek motif" : trimmed
    }
}
