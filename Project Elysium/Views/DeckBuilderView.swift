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
                    }
                    .onMove(perform: moveCards)
                }
                .listStyle(.sidebar)
            }
            .padding(8)
        } detail: {
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
        .navigationTitle("Stack Builder")
        .onChange(of: store.selectedCardID) { _ in store.save() }
    }

    private var header: some View {
        HStack(spacing: 8) {
            Button(action: store.addNewCard) { Label("Add", systemImage: "plus") }
            Button(action: store.duplicateSelected) { Label("Duplicate", systemImage: "doc.on.doc") }
                .disabled(store.selectedCardID == nil)
            Button(role: .destructive, action: store.deleteSelected) { Label("Delete", systemImage: "trash") }
                .disabled(store.selectedCardID == nil)
        }
    }

    private func moveCards(from offsets: IndexSet, to destination: Int) {
        store.cards.move(fromOffsets: offsets, toOffset: destination)
        store.save()
    }
}
