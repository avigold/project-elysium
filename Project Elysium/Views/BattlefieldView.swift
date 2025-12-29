import SwiftUI

struct BattlefieldView: View {
    var body: some View {
        VStack(spacing: 0) {
            ZStack {
                RoundedRectangle(cornerRadius: 18)
                    .fill(.ultraThinMaterial)
                VStack(spacing: 10) {
                    Text("Battlefield")
                        .font(.title2)
                        .fontWeight(.semibold)
                    Text("Next: drag goals from Hand → Battlefield, tap energy cards, snap-to-lanes placement.")
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 18)
                }
                .padding(18)
            }
            .padding(16)
            .frame(maxWidth: .infinity, maxHeight: .infinity)

            Divider()

            ZStack {
                RoundedRectangle(cornerRadius: 14)
                    .fill(.thinMaterial)
                HStack {
                    Text("Hand")
                        .font(.headline)
                    Spacer()
                    Text("Max 7")
                        .foregroundStyle(.secondary)
                }
                .padding(.horizontal, 16)
            }
            .padding(16)
            .frame(height: 110)
        }
        .navigationTitle("Gameplay")
    }
}
