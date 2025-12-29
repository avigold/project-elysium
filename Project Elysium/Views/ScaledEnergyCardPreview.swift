import SwiftUI

struct ScaledEnergyCardPreview: View {
    let energy: EnergyCard
    let scale: CGFloat

    var body: some View {
        EnergyCardPreviewView(energy: energy)
            .scaleEffect(scale, anchor: .topLeading)
            .frame(
                width: 310 * scale,
                height: 430 * scale,
                alignment: .topLeading
            )
    }
}
