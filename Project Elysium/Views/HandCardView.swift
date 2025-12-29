import SwiftUI

struct HandCardView: View {
    @ObservedObject var card: GoalCard

    var body: some View {
        ScaledCardPreview(card: card, scale: 0.44) // tune: 0.42–0.48
            .draggable(GoalDragPayload(goalId: card.id))
    }
}
