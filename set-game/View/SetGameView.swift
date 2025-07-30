// View/SetGameView.swift

import SwiftUI

struct SetGameView: View {
    @StateObject private var viewModel = SetGameViewModel()

    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
            Button {
                viewModel.startGame()
            } label: {
                Text("go")
            }
        }
    }
}

#Preview {
    SetGameView()
}
