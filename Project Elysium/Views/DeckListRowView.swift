import SwiftUI

struct DeckListRowView: View {
    @ObservedObject var card: GoalCard

    var body: some View {
        HStack(spacing: 10) {
            ArtBadgeView(artKey: card.artKey)
            VStack(alignment: .leading, spacing: 2) {
                Text(card.title.isEmpty ? "Untitled" : card.title)
                    .font(.headline)
                    .lineLimit(1)
                Text(card.castingCostString())
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            Spacer()
        }
        .padding(.vertical, 4)
    }
}
