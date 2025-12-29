import SwiftUI

struct ElysiumSection<Content: View>: View {
    let title: String
    @ViewBuilder var content: Content

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(title)
                .font(.caption)
                .foregroundStyle(Color.elysiumInk.opacity(0.70))
            
            content
        }
        .padding(12)
        .elysiumSurface(cornerRadius: 14, strokeOpacity: 0.12) // keep your look
    }
}
