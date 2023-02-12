//
//  GameCenterHandlers.swift
//  dictio
//
//  Created by Fiona Kate Morgan on 12/02/2023.
//

import GameKit


func leaderboard(score: Int) async {
    Task{
        try await GKLeaderboard.submitScore(
            score,
            context: 0,
            player: GKLocalPlayer.local,
            leaderboardIDs: ["daily"]
        )
    }
//    calculateAchievements()
}
