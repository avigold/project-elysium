import SwiftUI

@main
struct ProjectElysiumApp: App {
    @StateObject private var vm: GameViewModel = GameViewModel()

    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(vm)
        }
    }
}
