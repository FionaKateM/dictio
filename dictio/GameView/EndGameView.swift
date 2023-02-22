//
//  EndGameView.swift
//  dictio
//
//  Created by Fiona Kate Morgan on 14/02/2023.
//

import SwiftUI

struct EndGameView: View {
    
    @EnvironmentObject var gameSettings: GameSettings
    @Environment(\.managedObjectContext) var moc
    
    var body: some View {
        VStack {
            Spacer()
            Text("Well done")
                .padding()
            Text("You found the word \(gameSettings.correctWord.word) in \(gameSettings.allGuessedWords.count) guesses")
                .padding()
            LeaderboardView(leaderboardWord: (gameSettings.dailyID != nil) ? "daily" : gameSettings.correctWord.word)
        }
    }
}


