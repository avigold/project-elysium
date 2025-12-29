import SwiftUI

struct CardPreviewView: View {
    @ObservedObject var card: GoalCard

    var body: some View {
        ZStack {
            // “Stone tablet” frame (deliberately not a MTG frame)
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .fill(.ultraThickMaterial)
                .overlay(
                    RoundedRectangle(cornerRadius: 18, style: .continuous)
                        .strokeBorder(.primary.opacity(0.18), lineWidth: 1)
                )

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

    private var header: some View {
        HStack(alignment: .firstTextBaseline, spacing: 10) {
            Text(card.title.isEmpty ? "Untitled Goal" : card.title)
                .font(.system(size: 18, weight: .semibold, design: .serif))
                .lineLimit(1)

            Spacer(minLength: 8)

            Text(card.castingCostString())
                .font(.system(size: 16, weight: .semibold, design: .rounded))
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(
                    Capsule(style: .continuous).fill(.primary.opacity(0.08))
                )
        }
    }

    private var artPanel: some View {
        let shape = RoundedRectangle(cornerRadius: 14, style: .continuous)

        return ZStack {
            shape
                .fill(.primary.opacity(0.06))

            // Art image (fills panel, respects rounded corners)
            Image(card.artKey)                // e.g. "laurel"
                .resizable()
                .scaledToFill()
                .frame(height: 150)
                .clipped()
                .mask(shape)

            // Optional: keep your subtitle overlay (remove if you don’t want it)
            VStack(spacing: 8) {
                Spacer()
                Text(artSubtitle)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .padding(.bottom, 10)
            }
            .frame(height: 150)
            .mask(shape)

            // Border on top (same as before)
            shape
                .strokeBorder(.primary.opacity(0.12), lineWidth: 1)
        }
        .frame(height: 150)
    }

    private var rulesText: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("Text")
                .font(.caption)
                .foregroundStyle(.secondary)

            Text(card.details.isEmpty ? "—" : card.details)
                .font(.system(size: 13, weight: .regular, design: .serif))
                .foregroundStyle(.primary.opacity(0.92))
                .lineLimit(5)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(10)
        .background(
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .fill(.primary.opacity(0.05))
        )
    }

    private var criteria: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("Acceptance")
                .font(.caption)
                .foregroundStyle(.secondary)

            if card.acceptanceCriteria.isEmpty {
                Text("—")
                    .font(.system(size: 12, design: .monospaced))
                    .foregroundStyle(.secondary)
            } else {
                VStack(alignment: .leading, spacing: 4) {
                    ForEach(Array(card.acceptanceCriteria.enumerated()), id: \.offset) { idx, item in
                        HStack(alignment: .firstTextBaseline, spacing: 8) {
                            Text("\(idx + 1).")
                                .font(.system(size: 12, weight: .semibold, design: .monospaced))
                                .foregroundStyle(.secondary)

                            Text(item)
                                .font(.system(size: 12, design: .serif))
                                .lineLimit(2)
                        }
                    }
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(10)
        .background(
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .fill(.primary.opacity(0.05))
        )
    }

    private var footer: some View {
        HStack {
            Text("Project Elysium")
                .font(.caption2)
                .foregroundStyle(.secondary)

            Spacer()

            Text("Elysium • Goal")
                .font(.caption2)
                .foregroundStyle(.secondary)
        }
        .padding(.top, 2)
    }

    private var artSubtitle: String {
        let trimmed = card.artKey.trimmingCharacters(in: .whitespacesAndNewlines)
        return trimmed.isEmpty ? "Greek motif" : trimmed
    }
}
