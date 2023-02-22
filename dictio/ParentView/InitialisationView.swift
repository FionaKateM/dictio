//
//  LoadingView.swift
//  dictio
//
//  Created by Fiona Kate Morgan on 13/02/2023.
//

import SwiftUI
import GameKit

// Initialisation View is the loading screen presented on opening the app
// This authenticates the player with GameKit and if they are not already logged in, asks them to do so
// No information, other than a loading animation and a button to log into Game Center, will be on this screen

struct InitialisationView: View {
    @State var localPlayer = GKLocalPlayer.local
    @State var playerAuthenticated = false
    @Environment(\.managedObjectContext) var moc
    
    @FetchRequest(sortDescriptors: []) var games: FetchedResults<Game>
    @FetchRequest(sortDescriptors: []) var playerData: FetchedResults<Player>
    
    var body: some View {
        if !playerAuthenticated {
            Text("Loading your Game Center profile")
                .onAppear() {
                    Task {
                        authenticateUser()
                        checkCoreData()
                    }
                }
        } else {
            SessionView(sessionSettings: SessionSettings(appState: .home, player: localPlayer, gameSettings: nil, playedGames: convertFetchedResultsGames(), playerData: convertFetchedResultsPlayerData()))
        }
    }
    
    
    func authenticateUser() {
        localPlayer.authenticateHandler = { vc, error in
            guard error == nil else {
                print(error?.localizedDescription ?? "")
                return
            }
            //            GKAccessPoint.shared.isActive = localPlayer.isAuthenticated
            playerAuthenticated = true
        }
    }
    
    func checkCoreData() {
        if playerData.count == 0 {
            // no player data, needs to be created
            let player = Player(context: moc)
            
            player.coins = 5
            player.lastLogin = Date.now
            
            try? moc.save()
        }
    }
    
    func convertFetchedResultsGames() -> [Game] {
        var gamesArray: [Game] = []
        for game in games {
            gamesArray.append(game)
        }
        return gamesArray
    }
    
    func convertFetchedResultsPlayerData() -> Player {
        if playerData.count > 0 {
            return playerData[0]
        } else {
            let player = Player(context: moc)
            
            player.coins = 10
            player.lastLogin = Date.now
            
            return player
        }
    }
    
}

