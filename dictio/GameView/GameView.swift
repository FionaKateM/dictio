//
//  GameView.swift
//  dictio
//
//  Created by Fiona Kate Morgan on 11/02/2023.
//

import SwiftUI

// This is presented when the session settings app state is set to 'game'
// it presents either the active game, or the game end screen which includes the leaderboard

struct GameView: View {
    
    @StateObject var settings: GameSettings
    @EnvironmentObject var sessionSettings: SessionSettings
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var body: some View {
        VStack {
            ActiveGameView()
        }
        .environmentObject(settings)
        .navigationBarBackButtonHidden(true)
        .alert("Score: \(settings.score)", isPresented: $settings.gameEnded) {
            Button("OK", action: dismissAlert)
        }
    }
    
    func dismissAlert() {
        presentationMode.wrappedValue.dismiss()
    }
    
}


