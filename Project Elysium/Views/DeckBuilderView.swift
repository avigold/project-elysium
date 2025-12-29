import SwiftUI

struct DeckBuilderView: View {
    @ObservedObject private var store: DeckStoreModel = .shared

    var body: some View {
        NavigationSplitView {
            VStack(spacing: 8) {
                header

                List(selection: $store.selectedCardID) {
                    ForEach(store.cards) { card in
                        DeckListRowView(card: card)
                            .tag(card.id)
                            .listRowBackground(
                                                 store.selectedCardID == card.id
                                                 ? Color.elysiumPaperDeep.opacity(1)
                                                 : Color.clear
                                             )
                    }
                    .onMove(perform: moveCards)
                }
                .listStyle(.sidebar)
            }
            .padding(8)
            .background(sidebarMarbleBackground)
        } detail: {
            Group {
                if let card = store.selectedCard {
                    HStack(spacing: 16) {
                        DeckCardEditorView(card: card, onChange: store.save)
                            .frame(minWidth: 520)
                            .layoutPriority(1)

                        Divider()

                        CardPreviewView(card: card)
                            .frame(width: 320)
                    }
                    .padding(16)
                } else {
                    ContentUnavailableView("No goal selected", systemImage: "square.stack.3d.down.right")
                        .padding()
                }
            }
        }
        .elysiumSlabBackground()
        .foregroundColor(Color.elysiumInk)
        .navigationTitle("Stack Builder")
        .onChange(of: store.selectedCardID) { _ in store.save() }
    }

    private var header: some View {
        HStack(spacing: 10) {
            Button(action: store.addNewCard) { Label("Add", systemImage: "plus") }
                .buttonStyle(.borderedProminent)

            Button(action: store.duplicateSelected) { Label("Duplicate", systemImage: "doc.on.doc") }
                .buttonStyle(.borderless)
                .disabled(store.selectedCardID == nil)

            Button(role: .destructive, action: store.deleteSelected) { Label("Delete", systemImage: "trash") }
                .buttonStyle(.borderless)
                .disabled(store.selectedCardID == nil)

            Spacer()
        }
        .controlSize(.large)
        .padding(10)
        .elysiumSurface(cornerRadius: 14, strokeOpacity: 0.12)
    }

    private var sidebarMarbleBackground: some View {
        ZStack {
            // Base parchment/marble
            LinearGradient(
                colors: [
                    Color.elysiumPaperDeep.opacity(0.92),
                    Color.elysiumPaper.opacity(0.86),
                    Color.elysiumPaperDeep.opacity(0.90)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )

            LinearGradient(
                colors: [
                    Color.elysiumInk.opacity(0.08),
                    Color.clear,
                    Color.elysiumInk.opacity(0.05)
                ],
                startPoint: .top,
                endPoint: .bottom
            )
        }
        .ignoresSafeArea()
    }

    private func moveCards(from offsets: IndexSet, to destination: Int) {
        store.cards.move(fromOffsets: offsets, toOffset: destination)
        store.save()
    }
}
