import SwiftUI

struct ScaledCardPreview: View {
    @ObservedObject var card: GoalCard
    let scale: CGFloat

    var body: some View {
        CardPreviewView(card: card)
            .scaleEffect(scale, anchor: .topLeading)
            .frame(
                width: 310 * scale,
                height: 430 * scale,
                alignment: .topLeading
            )
    }
}
