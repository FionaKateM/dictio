//
//  SessionView.swift
//  dictio
//
//  Created by Fiona Kate Morgan on 14/02/2023.
//

import SwiftUI
import CoreData

// Session View is the main view controlling between active game, home, profile and data screens
// Session View contains the session variables
// Session settings are loaded by Initialisation View and passed through in the transition

struct SessionView: View {
    
    @StateObject var sessionSettings: SessionSettings
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(sortDescriptors: []) var games: FetchedResults<Game>
    
    @State var newPlayer = false
    
    var body: some View {
        NavigationView {
            switch sessionSettings.appState {
            case .home:
                HomeView()
                    .navigationBarHidden(true)
            case .game:
                if let gameSettings = sessionSettings.gameSettings {
                    GameView(gameSettings: gameSettings)
                        .navigationBarHidden(true)
                } else {
                    Text("game view cannot load")
                        .navigationBarHidden(true)
                }
            case .stats:
                StatsView()
                    .navigationBarHidden(true)
            case .profile:
                ProfileView()
                    .navigationBarHidden(true)
            case .coins:
                CoinsView()
                    .navigationBarHidden(true)
            }
        }
        .onAppear(){
            if sessionSettings.playedGames.count == 0 {
                // no played games have been loaded (or the player has played no games)
                // try loading core data
                for game in games {
                    sessionSettings.playedGames.append(game)
                }

                // if no core data then set newPlayer to true
                if games.count == 0 {
                    newPlayer = true
                }
            }
            
            if newPlayer {
                // offer explanation on how to play
                print("new player")
            }
        }
        .environmentObject(sessionSettings)
    }
}


