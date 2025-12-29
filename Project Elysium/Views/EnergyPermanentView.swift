import SwiftUI

struct EnergyPermanentView: View {
    let energy: EnergyCard
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            ZStack(alignment: .topTrailing) {
                ScaledEnergyCardPreview(energy: energy, scale: 0.34) // tune

                if energy.boundGoalId != nil {
                    Image(systemName: "link")
                        .font(.system(size: 10, weight: .semibold))
                        .foregroundStyle(.secondary)
                        .padding(6)
                }
            }
        }
        .buttonStyle(.plain)
        .disabled(energy.boundGoalId != nil)
        .rotationEffect(energy.isTapped ? .degrees(-90) : .degrees(0))
        .opacity(energy.boundGoalId != nil ? 0.75 : 1.0)
        .animation(.easeInOut(duration: 0.18), value: energy.isTapped)
        .animation(.easeInOut(duration: 0.18), value: energy.boundGoalId)
    }
}
