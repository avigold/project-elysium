import SwiftUI

struct ElysiumSlabBackground: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background(
                Rectangle()
                    .fill(Color.elysiumPaperDeep.opacity(0.40))
                    .overlay(
                        Rectangle()
                            .stroke(Color.elysiumInk.opacity(0.10), lineWidth: 1)
                    )
                    .ignoresSafeArea()
            )
    }
}

extension View {
    func elysiumSlabBackground() -> some View {
        modifier(ElysiumSlabBackground())
    }
}
