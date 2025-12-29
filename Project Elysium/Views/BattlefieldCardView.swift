import SwiftUI

struct BattlefieldCardView: View {
    @ObservedObject var card: GoalCard

    /// Scale applied to the canonical 310×430 CardPreviewView layout.
    let scale: CGFloat

    /// Indices of acceptance criteria that are currently done for this in-game card instance.
    let criteriaDone: Set<Int>

    /// Called when a criterion row is toggled.
    let onToggleCriterion: (_ index: Int, _ done: Bool) -> Void

    var body: some View {
        ZStack(alignment: .topLeading) {
            ScaledCardPreview(card: card, scale: scale)

            // Visual checkmarks aligned to acceptance rows (approx; tune constants once).
            criteriaMarksOverlay
                .frame(width: 310 * scale, height: 430 * scale, alignment: .topLeading)

            // Transparent hit targets over acceptance rows.
            criteriaHitOverlay
                .frame(width: 310 * scale, height: 430 * scale, alignment: .topLeading)
        }
        .frame(width: 310 * scale, height: 430 * scale, alignment: .topLeading)
    }

    private var criteriaMarksOverlay: some View {
        GeometryReader { geo in
            let w = geo.size.width

            // Anchor where the acceptance list starts inside CardPreviewView.
            // Tune once in the simulator if needed.
            let boxTop: CGFloat = 262 * scale

            // Distance between each acceptance row.
            let rowHeight: CGFloat = 18 * scale

            // X position for the checkmark icon (left side of acceptance rows).
            let x: CGFloat = min(34 * scale, w * 0.16)

            ForEach(Array(card.acceptanceCriteria.enumerated()), id: \.offset) { idx, _ in
                if criteriaDone.contains(idx) {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 12 * scale, weight: .semibold))
                        .foregroundStyle(.secondary)
                        .position(
                            x: x,
                            y: boxTop + (CGFloat(idx) * rowHeight) + (rowHeight / 2)
                        )
                }
            }
        }
        .allowsHitTesting(false)
    }

    private var criteriaHitOverlay: some View {
        GeometryReader { geo in
            let w = geo.size.width

            // Same anchors as marks overlay.
            let boxTop: CGFloat = 262 * scale
            let rowHeight: CGFloat = 18 * scale

            // Hit width roughly spans the acceptance text area.
            let leftInset: CGFloat = 22 * scale
            let rightInset: CGFloat = 22 * scale
            let hitWidth: CGFloat = max(0, w - leftInset - rightInset)

            VStack(alignment: .leading, spacing: 0) {
                ForEach(Array(card.acceptanceCriteria.enumerated()), id: \.offset) { idx, _ in
                    Button {
                        let isDone = criteriaDone.contains(idx)
                        onToggleCriterion(idx, !isDone)
                    } label: {
                        Rectangle()
                            .fill(Color.clear)
                            .contentShape(Rectangle())
                    }
                    .buttonStyle(.plain)
                    .frame(height: rowHeight)
                }
            }
            .frame(width: hitWidth, alignment: .leading)
            .position(
                x: w / 2,
                y: boxTop + (CGFloat(card.acceptanceCriteria.count) * rowHeight) / 2
            )
        }
        .allowsHitTesting(!card.acceptanceCriteria.isEmpty)
    }
}
