import SwiftUI

struct MenuView: View {
    @StateObject private var game = GameStoreModel()
    @StateObject private var deckStore = DeckStoreModel.shared

    var body: some View {
        NavigationStack {
            ZStack {
                menuBackground
                    .ignoresSafeArea()

                VStack(spacing: 22) {
                    header

                    VStack(spacing: 14) {
                        NavigationLink {
                            DeckBuilderView()
                        } label: {
                            MenuCardButton(
                                title: "Stack Builder",
                                subtitle: "Create and tune goal cards.",
                                systemImage: "square.stack.3d.up"
                            )
                        }
                        .buttonStyle(.plain)

                        NavigationLink {
                            BattlefieldView(game: game, deckStore: deckStore)
                        } label: {
                            MenuCardButton(
                                title: "Battlefield",
                                subtitle: "Cast goals and bind energy.",
                                systemImage: "rectangle.3.offgrid"
                            )
                        }
                        .buttonStyle(.plain)
                    }
                    .frame(maxWidth: 520)

                    footer
                }
                .padding(32)
                .frame(minWidth: 760, minHeight: 520)
            }
        }
    }

    private var header: some View {
        VStack(spacing: 10) {
            Text("Project Elysium")
                .font(.system(size: 40, weight: .semibold, design: .serif))
                .foregroundStyle(.primary)

            Text("A card-based workload system.")
                .font(.system(size: 15, weight: .regular))
                .foregroundStyle(.secondary)
        }
        .padding(.bottom, 4)
    }

    private var footer: some View {
        HStack(spacing: 10) {
            Image(systemName: "laurel.leading")
                .foregroundStyle(.secondary)
            Text("Conquer Energy • Gain Wisdom • Get Paper")
                .font(.system(size: 12, weight: .medium))
                .foregroundStyle(.secondary)
            Image(systemName: "laurel.trailing")
                .foregroundStyle(.secondary)
        }
        .padding(.top, 6)
        .opacity(0.95)
    }

    private var menuBackground: some View {
        ZStack {
            LinearGradient(
                colors: [
                    Color("elysiumPaperDeep").opacity(0.95),
                    Color("elysiumPaper").opacity(0.92)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )

            RadialGradient(
                colors: [
                    Color.white.opacity(0.18),
                    Color.white.opacity(0.00)
                ],
                center: .top,
                startRadius: 80,
                endRadius: 900
            )
            .blendMode(.screen)
            .opacity(0.55)

            RadialGradient(
                colors: [
                    Color.black.opacity(0.00),
                    Color.black.opacity(0.18)
                ],
                center: .center,
                startRadius: 260,
                endRadius: 1200
            )
        }
    }
}

private struct MenuCardButton: View {
    let title: String
    let subtitle: String
    let systemImage: String

    @Environment(\.isEnabled) private var isEnabled
    @State private var isHovering: Bool = false

    var body: some View {
        HStack(spacing: 16) {
            ZStack {
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .fill(Color.elysiumBronze.opacity(0.18))
                    .overlay(
                        RoundedRectangle(cornerRadius: 16, style: .continuous)
                            .stroke(Color.elysiumBronze.opacity(0.40), lineWidth: 1)
                    )

                Image(systemName: systemImage)
                    .font(.system(size: 22, weight: .semibold))
                    .foregroundColor(Color.elysiumInk.opacity(0.92))
            }
            .frame(width: 52, height: 52)

            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.system(size: 18, weight: .semibold, design: .serif))
                    .foregroundColor(Color.elysiumInk.opacity(isEnabled ? 0.92 : 0.55))

                Text(subtitle)
                    .font(.system(size: 13, weight: .regular))
                    .foregroundColor(Color.elysiumInk.opacity(isEnabled ? 0.62 : 0.40))
            }

            Spacer(minLength: 12)

            Image(systemName: "chevron.right")
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(Color.elysiumInk.opacity(0.45))
        }
        .padding(.horizontal, 18)
        .padding(.vertical, 16)
        .background(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(Color.elysiumPaper.opacity(isHovering ? 0.42 : 0.34))
                .overlay(
                    RoundedRectangle(cornerRadius: 20, style: .continuous)
                        .stroke(Color.elysiumBronze.opacity(isHovering ? 0.55 : 0.38), lineWidth: 1)
                )
        )
        .shadow(color: .black.opacity(isHovering ? 0.18 : 0.12), radius: 18, x: 0, y: 14)
        .scaleEffect(isHovering ? 1.01 : 1.0)
        .onHover { isHovering = $0 }
        .animation(.spring(response: 0.20, dampingFraction: 0.86), value: isHovering)
        .contentShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
    }
}
