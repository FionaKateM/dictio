//
//  LeaderboardView.swift
//  dictio
//
//  Created by Fiona Kate Morgan on 13/02/2023.
//

import SwiftUI
import GameKit

// leaderboard View presents the leaderboard for a specific word or for the daily game
// It is either accessed by the player through the stats screen, or presented at the end of completing a game
// If a word is passed into the 'leaderboardWord' variable then it will present the leaderboard for that word, otherwise it will present the daily leaderboard

struct LeaderboardView: View {
    
    @State var leaderboardWord: String?
    @State var leaderboardEntries: [GKLeaderboard.Entry] = []
    
    var body: some View {
        VStack {
            Text("\(leaderboardWord ?? "daily") leaderboard")
            List((0..<leaderboardEntries.count), id: \.self) { i in
//            ForEach((0..<leaderboardEntries.count), id: \.self) {i in
                if let entry = leaderboardEntries[i] {
                    HStack {
                        Text("\(entry.player.displayName)")
                            .padding()
                            .frame(maxWidth: .infinity)
                            .foregroundColor(.white)
                            .background(.yellow)
                            .clipShape(RoundedRectangle(cornerSize: CGSize(width: 10, height: 10)))
                        Spacer()
                        Text("\(entry.score)")
                            .padding()
                            .foregroundColor(.white)
                            .background(.blue)
                            .clipShape(Circle())
                    }
                }
            }
        }
        .onAppear() {
            Task {
                await loadLeaderboard(word: leaderboardWord?.lowercased() ?? "daily")
            }
        }
    }
    
    func loadLeaderboard(word: String) async {
        Task{
            var playersListTemp : [GKLeaderboard.Entry] = []
            let leaderboards = try await GKLeaderboard.loadLeaderboards(IDs: [word])
            
            if let leaderboard = leaderboards.filter ({ $0.baseLeaderboardID == word }).first {
                let allPlayers = try await leaderboard.loadEntries(for: .global, timeScope: .allTime, range: NSRange(1...5))
                
                if allPlayers.1.count > 0 {
                    for player in allPlayers.1 {
                        playersListTemp.append(player)
                    }
                    
                    playersListTemp.sort{
                        $0.score < $1.score
                    }
                }
            }
            if playersListTemp.count > 0 {
                leaderboardEntries = playersListTemp
            }
        }
    }
}

