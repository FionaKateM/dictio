//
//  SessionView.swift
//  dictio
//
//  Created by Fiona Kate Morgan on 14/02/2023.
//

import SwiftUI
import CoreData
import GameKit

// Session View is the main view controlling between active game, home, profile and data screens
// Session View contains the session variables
// Session settings are loaded by Initialisation View and passed through in the transition

struct SessionView: View {
    
    @StateObject var sessionSettings: SessionSettings
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @Environment(\.managedObjectContext) var moc
    
    
    @State var newPlayer = false
    
    var body: some View {
        VStack {
            switch sessionSettings.appState {
            case .home:
                HomeView()
                    .navigationBarHidden(true)
            case .game:
                if let gameSettings = sessionSettings.gameSettings {
                    GameView(gameSettings: gameSettings)
                } else {
                    Text("game view cannot load")
                }
            case .stats:
                StatsView()
            case .profile:
                ProfileView()
            case .coins:
                CoinsView()
            case .temp:
                DailyWordsArrange()
                
            }
        }
        .environmentObject(sessionSettings)
        .onChange(of: sessionSettings.playerData.coins) { _ in
            updatePlayerData()
        }
        .onAppear() {
            print("session games: \(sessionSettings.playedGames)")
        }
    }
    
    func updatePlayerData() {
        print("saving data")
        let player = Player(context: moc)
        
        player.coins = sessionSettings.playerData.coins
        player.lastLogin = Date.now
        
        try? moc.save()
    }
    
}


