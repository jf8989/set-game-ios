import SwiftUI

@main
struct set_gameApp: App {
    @StateObject private var gameViewModel = SetGameViewModel()

    var body: some Scene {
        WindowGroup {
            SetGameView()
                .environmentObject(gameViewModel)
        }
    }
}
