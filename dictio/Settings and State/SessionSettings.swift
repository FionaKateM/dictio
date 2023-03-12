//
//  SessionSettings.swift
//  dictio
//
//  Created by Fiona Kate Morgan on 14/02/2023.
//

import Foundation
import GameKit
import CoreData
// Stored in SessionView
// Initialised in InitialisationView

class SessionSettings: ObservableObject {
    @Published var appState: SessionState
    @Published var player: GKLocalPlayer
    @Published var gameSettings: GameSettings?
    @Published var playedGames: [GKSavedGame]
    @Published var playerData: Player
    
    init(appState: SessionState, player: GKLocalPlayer, gameSettings: GameSettings?, playedGames: [GKSavedGame], playerData: Player) {
        self.appState = appState
        self.player = player
        self.gameSettings = gameSettings
        self.playedGames = playedGames
        self.playerData = playerData
    }
    
    func increaseCoinsBy(amount: Int16) {
        playerData.coins += amount
    }
    
    func loadPlayedGamesData() async -> [GameData] {
        var dataForGames: [GameData] = []
        for game in playedGames {
            do {
                let data = try await loadDataFor(game: game)
                if let gameData = await decodeGame(data: data) {
                    dataForGames.append(gameData)
                    if dataForGames.count == playedGames.count {
                        return dataForGames
                    }
                }
            }
            catch {
                return dataForGames
            }

        }
        return dataForGames
    }
}

