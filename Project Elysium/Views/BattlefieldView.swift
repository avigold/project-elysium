import SwiftUI

struct BattlefieldView: View {
    @ObservedObject var game: GameStoreModel
    @ObservedObject var deckStore: DeckStoreModel

    @State private var flatMode: Bool = false

    // Camera
    @State private var tiltX: Double = 18
    @State private var yawZ: Double = -0.0
    @State private var perspective: CGFloat = 0.38
    @State private var tableScale: CGFloat = 1.00
    @State private var tableOffsetY: CGFloat = 0

    // Layout in “table space” (origin + lane start)
    @State private var originXFrac: CGFloat = 0.50
    @State private var originYFrac: CGFloat = 0.45
    @State private var laneLeftInset: CGFloat = 40

    // Lane Y offsets (relative to origin in table space)
    @State private var battlefieldY: CGFloat = -300
    @State private var energyY: CGFloat = -550
    @State private var handY: CGFloat = 0

    // Card scales
    @State private var handScale: CGFloat = 0.52
    @State private var energyScale: CGFloat = 1
    @State private var battlefieldScale: CGFloat = 0.46

    // Battlefield layout
    @State private var battlefieldCols: Int = 3
    @State private var battlefieldGapX: CGFloat = 26
    @State private var battlefieldGapY: CGFloat = 22

    var body: some View {
        GeometryReader { geo in
            ZStack {
                tableBackground
                    .ignoresSafeArea()

                // One plane coordinate system.
                ZStack {
                    battlefieldPlane(in: geo.size)
                    energyPlane(in: geo.size)
                    handPlane(in: geo.size)
                }
                .frame(width: geo.size.width, height: geo.size.height)
                .offset(y: tableOffsetY)
                .if(!flatMode) { view in
                    view.tableCamera(
                        tiltX: tiltX,
                        yawZ: yawZ,
                        perspective: perspective,
                        scale: tableScale
                    )
                }
                .contentShape(Rectangle())
                .dropDestination(for: GoalDragPayload.self) { items, _ in
                    guard let payload = items.first else { return false }
                    return game.attemptCast(payload.goalId)
                }

                // Optional on-screen controls (kept minimal): hide once tuned.
                // tweakHud
                //     .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                //     .padding(12)
                //     .opacity(0.90)
            }
        }
        .navigationTitle("Gameplay")
        .toolbar {
            Button("Reset") {
                game.newGame(from: deckStore.cards)
            }
        }
        .onAppear {
            if game.state.goals.isEmpty {
                game.newGame(from: deckStore.cards)
            }
        }
    }

    // MARK: - Background

    private var tableBackground: some View {
        ZStack {
            Image("table_background")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
                .overlay(Color.black.opacity(0.35))

            RadialGradient(
                colors: [
                    Color.white.opacity(0.10),
                    Color.white.opacity(0.00)
                ],
                center: .center,
                startRadius: 140,
                endRadius: 980
            )
            .blendMode(.screen)
            .opacity(0.35)

            RadialGradient(
                colors: [
                    Color.black.opacity(0.00),
                    Color.black.opacity(0.70)
                ],
                center: .center,
                startRadius: 260,
                endRadius: 1100
            )
        }
    }

    // MARK: - Layout helpers

    private func origin(in size: CGSize) -> CGPoint {
        CGPoint(
            x: size.width * originXFrac,
            y: size.height * originYFrac
        )
    }

    private func laneX(in size: CGSize) -> CGFloat {
        origin(in: size).x - (size.width * 0.5) + laneLeftInset
    }

    private func laneY(_ offset: CGFloat, in size: CGSize) -> CGFloat {
        origin(in: size).y + offset
    }

    // MARK: - Battlefield lane

    private func battlefieldPlane(in size: CGSize) -> some View {
        let x0 = laneX(in: size)
        let y0 = laneY(battlefieldY, in: size)
        let goals = orderedBattlefieldGoals()

        return ZStack(alignment: .topLeading) {
            if !goals.isEmpty {
                battlefieldGrid(goals: goals)
                    .offset(x: x0, y: y0)
            }
        }
    }

    private func battlefieldGrid(goals: [GoalCard]) -> some View {
        let cardW = 310 * battlefieldScale
        let cardH = 430 * battlefieldScale
        let cols = max(1, battlefieldCols)

        return ZStack(alignment: .topLeading) {
            ForEach(Array(goals.enumerated()), id: \.element.id) { idx, g in
                let col = idx % cols
                let row = idx / cols

                BattlefieldCardView(
                    card: g,
                    scale: battlefieldScale,
                    criteriaDone: game.state.criteriaDone[g.id] ?? [],
                    onToggleCriterion: { i, done in
                        game.setCriterion(goalId: g.id, index: i, done: done)
                    }
                )
                .cardShadow()
                .offset(
                    x: CGFloat(col) * (cardW + battlefieldGapX),
                    y: CGFloat(row) * (cardH + battlefieldGapY)
                )
            }
        }
    }

    // MARK: - Energy lane

    private func energyPlane(in size: CGSize) -> some View {
        let x0 = laneX(in: size)
        let y0 = laneY(energyY, in: size)

        return ZStack(alignment: .topLeading) {
            HStack(spacing: 18) {
                ForEach(game.state.energies) { e in
                    EnergyPermanentView(
                        energy: e,
                        onTap: { game.toggleTap(e.id) }
                    )
                    .scaleEffect(energyScale, anchor: .topLeading)
                    .frame(
                        width: 150 * energyScale,
                        height: 430 * energyScale,
                        alignment: .topLeading
                    )
                    .cardShadow()
                }
            }
            .offset(x: x0, y: y0)
        }
    }

    // MARK: - Hand lane

    private func handPlane(in size: CGSize) -> some View {
        let x0 = laneX(in: size)
        let y0 = laneY(handY, in: size)
        let hand = game.state.goals.filter { $0.zone == .hand }

        return ZStack(alignment: .topLeading) {
            HStack(spacing: 18) {
                ForEach(hand) { g in
                    ScaledCardPreview(card: g, scale: handScale)
                        .draggable(GoalDragPayload(goalId: g.id))
                        .cardShadow()
                }
            }
            .offset(x: x0, y: y0)
        }
    }

    // MARK: - Tuning HUD (optional)

    private var tweakHud: some View {
        VStack(alignment: .leading, spacing: 8) {
            Toggle("Flat", isOn: $flatMode)
                .toggleStyle(.switch)
                .font(.caption)

            VStack(alignment: .leading, spacing: 6) {
                slider("Origin Y", value: $originYFrac, range: 0.45...0.85)
                slider("Lane Left", value: $laneLeftInset, range: 40...240)
                slider("Hand Y", value: $handY, range: 80...360)
                slider("Energy Y", value: $energyY, range: -160...200)
                slider("Battle Y", value: $battlefieldY, range: -520...0)
            }
            .font(.caption2)

            VStack(alignment: .leading, spacing: 6) {
                sliderD("Tilt X", value: $tiltX, range: 0...35)
                sliderD("Yaw Z", value: $yawZ, range: -12...12)
                slider("Perspective", value: $perspective, range: 0.20...0.90)
                slider("Scale", value: $tableScale, range: 0.90...1.40)
                slider("Offset Y", value: $tableOffsetY, range: -120...180)
            }
            .font(.caption2)
        }
        .padding(10)
        .background(.ultraThinMaterial)
        .clipShape(
            RoundedRectangle(cornerRadius: 12, style: .continuous)
        )
    }

    private func slider(
        _ label: String,
        value: Binding<CGFloat>,
        range: ClosedRange<CGFloat>
    ) -> some View {
        VStack(alignment: .leading, spacing: 2) {
            HStack {
                Text(label)
                Spacer()
                Text(String(format: "%.2f", Double(value.wrappedValue)))
                    .foregroundStyle(.secondary)
            }
            Slider(value: value, in: range)
        }
        .frame(width: 240)
    }

    private func sliderD(
        _ label: String,
        value: Binding<Double>,
        range: ClosedRange<Double>
    ) -> some View {
        VStack(alignment: .leading, spacing: 2) {
            HStack {
                Text(label)
                Spacer()
                Text(String(format: "%.1f", value.wrappedValue))
                    .foregroundStyle(.secondary)
            }
            Slider(value: value, in: range)
        }
        .frame(width: 240)
    }

    // MARK: - Helpers

    private func orderedBattlefieldGoals() -> [GoalCard] {
        let battlefield = game.state.goals.filter { $0.zone == .battlefield }
        let byId = Dictionary(
            uniqueKeysWithValues: battlefield.map { ($0.id, $0) }
        )

        let ordered = game.state.battlefieldGoalOrder.compactMap { byId[$0] }
        let orderedIds = Set(ordered.map(\.id))

        let extras = battlefield
            .filter { !orderedIds.contains($0.id) }
            .sorted { $0.title < $1.title }

        return ordered + extras
    }
}

// MARK: - Camera modifier

private struct TableCamera: ViewModifier {
    let tiltX: Double
    let yawZ: Double
    let perspective: CGFloat
    let scale: CGFloat

    func body(content: Content) -> some View {
        content
            .rotation3DEffect(
                .degrees(tiltX),
                axis: (x: 1, y: 0, z: 0),
                perspective: perspective
            )
            .rotationEffect(.degrees(yawZ))
            .scaleEffect(scale, anchor: .center)
    }
}

// MARK: - Shadow

private extension View {
    func cardShadow() -> some View {
        shadow(
            color: .black.opacity(0.35),
            radius: 18,
            x: 0,
            y: 14
        )
    }
}

// MARK: - Conditional modifier

private extension View {
    @ViewBuilder
    func `if`<Content: View>(
        _ condition: Bool,
        transform: (Self) -> Content
    ) -> some View {
        if condition {
            transform(self)
        } else {
            self
        }
    }
}

private extension View {
    func tableCamera(
        tiltX: Double,
        yawZ: Double,
        perspective: CGFloat,
        scale: CGFloat
    ) -> some View {
        modifier(
            TableCamera(
                tiltX: tiltX,
                yawZ: yawZ,
                perspective: perspective,
                scale: scale
            )
        )
    }
}
