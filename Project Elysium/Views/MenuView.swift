import SwiftUI

struct MenuView: View {
    var body: some View {
        VStack(spacing: 16) {
            Text("Project Elysium").font(.largeTitle)

            NavigationLink("Stack Building") { DeckBuilderView() }
            NavigationLink("Battlefield") { BattlefieldView() }
        }
        .padding(24)
        .frame(minWidth: 520, minHeight: 360)
    }
}
