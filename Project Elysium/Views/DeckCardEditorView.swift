import SwiftUI

struct DeckCardEditorView: View {
    @ObservedObject var card: GoalCard
    let onChange: () -> Void

    @State private var newCriterionText: String = ""

    private let artOptions: [(key: String, label: String, symbol: String)] = [
        ("laurel", "Laurel", "leaf"),
        ("column", "Column", "building.columns"),
        ("mask", "Mask", "theatermasks"),
        ("owl", "Owl", "bird"),
        ("helm", "Helm", "shield.lefthalf.filled")
    ]

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 14) {
                topLine

                ElysiumSection(title: "Card") {
                    VStack(alignment: .leading, spacing: 10) {
                        TextField("Title", text: $card.title)
                            .textFieldStyle(.roundedBorder)
                        TextField("Description", text: $card.details, axis: .vertical)
                            .lineLimit(4, reservesSpace: true)
                            .textFieldStyle(.roundedBorder)
                    }
                    .padding(8)
                }
                .groupBoxStyle(.automatic)

                ElysiumSection(title: "Casting Cost") {
                    VStack(alignment: .leading, spacing: 10) {
                        HStack {
                            Text("Cost:")
                            Text(card.castingCostString())
                                .font(.title3)
                                .monospaced()
                            Spacer()
                        }

                        ForEach(EnergyType.allCases) { t in
                            EnergyPillStepper(
                                glyph: t.glyph,
                                label: t.displayName,
                                value: Binding(
                                    get: { card.energyCost[t] ?? 0 },
                                    set: { v in
                                        card.energyCost[t] = max(0, v)
                                    }
                                ),
                                range: 0...9,
                                onChange: onChange
                            )
                        }
                    }
                    .padding(8)
                }
                .groupBoxStyle(.automatic)

                ElysiumSection(title: "Acceptance Criteria") {
                    VStack(alignment: .leading, spacing: 8) {
                        ForEach(Array(card.acceptanceCriteria.enumerated()), id: \.offset) { idx, item in
                            HStack {
                                TextField(
                                    "Criterion",
                                    text: Binding(
                                        get: { item },
                                        set: { v in
                                            guard idx < card.acceptanceCriteria.count else { return }
                                            card.acceptanceCriteria[idx] = v
                                            onChange()
                                        }
                                    )
                                )
                                .textFieldStyle(.roundedBorder)

                                Button(role: .destructive) {
                                    guard idx < card.acceptanceCriteria.count else { return }
                                    card.acceptanceCriteria.remove(at: idx)
                                    onChange()
                                } label: {
                                    Image(systemName: "minus.circle")
                                }
                                .buttonStyle(.borderless)
                            }
                        }

                        HStack {
                            TextField("Add criterion", text: $newCriterionText)
                                .textFieldStyle(.roundedBorder)
                            Button {
                                let trimmed = newCriterionText.trimmingCharacters(in: .whitespacesAndNewlines)
                                guard !trimmed.isEmpty else { return }
                                card.acceptanceCriteria.append(trimmed)
                                newCriterionText = ""
                                onChange()
                            } label: {
                                Image(systemName: "plus.circle")
                            }
                            .buttonStyle(.borderless)
                        }
                    }
                    .padding(8)
                }
                .groupBoxStyle(.automatic)

                ElysiumSection(title: "Art") {
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 140), spacing: 10)], spacing: 10) {
                        ForEach(artOptions, id: \.key) { opt in
                            Button {
                                card.artKey = opt.key
                                onChange()
                            } label: {
                                HStack(spacing: 10) {
                                    Image(systemName: opt.symbol)
                                        .font(.title3)
                                    Text(opt.label)
                                    Spacer()
                                    if card.artKey == opt.key {
                                        Image(systemName: "checkmark.circle.fill")
                                    }
                                }
                                .padding(10)
                                .elysiumSurface(cornerRadius: 12, strokeOpacity: 0.14)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .padding(8)
                }

                Spacer(minLength: 8)
            }
            .groupBoxStyle(.automatic)
        }
        .foregroundStyle(Color.elysiumInk.opacity(0.92))
        .onChange(of: card.title) { _ in onChange() }
        .onChange(of: card.details) { _ in onChange() }
        .navigationTitle(card.title.isEmpty ? "Goal" : card.title)
    }

    private var topLine: some View {
        HStack {
            Text("Stack card editor")
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundColor(Color.white)
            Spacer()
        }
    }
    
    private func energyHint(for t: EnergyType) -> String {
        switch t {
        case .soma:   return "Body: strength, stamina, physical execution."
        case .nous:   return "Mind: focus, thinking, deep work."
        case .eros:   return "Connection: emotional bandwidth, relationships, desire."
        case .thumos: return "Drive: resolve, courage, confrontation, will."
        case .schole: return "Leisure: time, space, recovery, unhurried attention."
        }
    }
}
