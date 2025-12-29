import SwiftUI

struct BoundBadge: View {
    var body: some View {
        Capsule()
            .fill(.thinMaterial)
            .overlay(Capsule().strokeBorder(.primary.opacity(0.12), lineWidth: 1))
            .overlay(
                HStack(spacing: 6) {
                    Image(systemName: "link")
                    Text("Bound")
                }
                .font(.caption2)
                .foregroundStyle(.secondary)
                .padding(.horizontal, 10)
                .padding(.vertical, 6)
            )
    }
}
