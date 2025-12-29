import SwiftUI

struct ElysiumSurface: ViewModifier {
    var cornerRadius: CGFloat = 12
    var strokeOpacity: Double = 0.18

    func body(content: Content) -> some View {
        content
            .background(
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                    // Lighter + more opaque so text reads as "active"
                    .fill(Color.elysiumPaper.opacity(0.55))
                    .overlay(
                        RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                            .strokeBorder(Color.elysiumInk.opacity(max(strokeOpacity, 0.14)), lineWidth: 1)
                    )
                    // Very subtle highlight to lift it off the slab
                    .shadow(color: Color.white.opacity(0.08), radius: 0, x: 0, y: 1)
            )
    }
}

extension View {
    func elysiumSurface(cornerRadius: CGFloat = 12, strokeOpacity: Double = 0.18) -> some View {
        modifier(ElysiumSurface(cornerRadius: cornerRadius, strokeOpacity: strokeOpacity))
    }
}

extension Color {
    static let elysiumPaper = Color(red: 0.97, green: 0.94, blue: 0.86)  // warm parchment
    static let elysiumInk = Color(red: 0.16, green: 0.17,blue: 0.18) // warm dark brown
    static let elysiumBronze = Color(red: 0.74, green: 0.62, blue: 0.40) // accents
    static let elysiumPaperDeep = Color(red: 0.90, green: 0.86, blue: 0.76) // slightly darker
}
