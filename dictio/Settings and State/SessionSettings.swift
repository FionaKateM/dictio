//
//  SessionSettings.swift
//  dictio
//
//  Created by Fiona Kate Morgan on 14/02/2023.
//

import Foundation
import GameKit

// Stored in SessionView
// Initialised in InitialisationView

class SessionSettings: ObservableObject {
    @Published var appState: SessionState
    @Published var player: GKLocalPlayer
    @Published var gameSettings: GameSettings?
    @Published var coins: Int
    @Published var playedGames: [Game]
    
    init(appState: SessionState, player: GKLocalPlayer, gameSettings: GameSettings?, coins: Int, playedGames: [Game]) {
        self.appState = appState
        self.player = player
        self.gameSettings = gameSettings
        self.coins = coins
        self.playedGames = playedGames
    }
}

