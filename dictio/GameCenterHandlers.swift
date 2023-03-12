//
//  GameCenterHandlers.swift
//  dictio
//
//  Created by Fiona Kate Morgan on 12/02/2023.
//

import GameKit



func leaderboard(score: Int, word: String, isDaily: Bool) async {
    if isDaily {
        Task{
            print("saving daily score")
            try await GKLeaderboard.submitScore(
                score,
                context: 0,
                player: GKLocalPlayer.local,
                leaderboardIDs: ["daily"]
            )
            
        }
    }
    
    Task{
        print("saving \(word.lowercased()) score")
        try await GKLeaderboard.submitScore(
            score,
            context: 0,
            player: GKLocalPlayer.local,
            leaderboardIDs: ["word.\(word.lowercased())"]
        )
    }
    
    //    calculateAchievements()
}


func saveGame(data: GameData) {
    // Get player
    let localPlayer = GKLocalPlayer.local
    if localPlayer.isAuthenticated, let save = try? JSONEncoder().encode(data) {
        // Save its game data
        localPlayer.saveGameData(save, withName: data.correctWord) { savedGame, error in
            if let error = error {
                print(error.localizedDescription)
            }
        }
    }
}

func loadDataFor(game: GKSavedGame) async throws -> (Data) {
    return try await game.loadData()
}

func decodeGame(data: Data) async -> GameData? {
    do {
        let gameData = try JSONDecoder().decode(GameData.self, from: data)
        return gameData
    } catch {
        return nil
    }
}

func whatIsTodaysDailyID() async -> Int {
    let word = await getDailyWord(date: formatDate(Date.now))
    print("word: \(word?.word), \(word?.id)")
    return (word?.id)!
}

func loadGameDataFor(playedGames: [GKSavedGame]) async -> [GameData] {
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
