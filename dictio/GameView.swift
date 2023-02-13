//
//  GameView.swift
//  dictio
//
//  Created by Fiona Kate Morgan on 11/02/2023.
//

import SwiftUI

struct GameView: View {
    
    @StateObject var settings: GameSettings
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var body: some View {
        VStack {
//            GuessedWordView()
//            AlphabetView()
            ActiveGuessView()
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


