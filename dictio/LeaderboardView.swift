//
//  LeaderboardView.swift
//  dictio
//
//  Created by Fiona Kate Morgan on 13/02/2023.
//

import SwiftUI
import GameKit

struct LeaderboardView: View {
    @State var leaderboardEntries: [GKLeaderboard.Entry] = []
    var body: some View {
        VStack {
            Text("lemon leaderboard")
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
                await loadLeaderboard(word: "lemon")
            }
        }
    }
    
    func loadLeaderboard(word: String) async {
        
        //    playersList.removeAll()
        print("leaderboards")
        Task{
            var playersListTemp : [GKLeaderboard.Entry] = []
            let leaderboards = try await GKLeaderboard.loadLeaderboards(IDs: [word])
            
            if let leaderboard = leaderboards.filter ({ $0.baseLeaderboardID == word }).first {
                let allPlayers = try await leaderboard.loadEntries(for: .global, timeScope: .allTime, range: NSRange(1...5))
                
                if allPlayers.1.count > 0 {
                    for player in allPlayers.1 {
                                            print("name: \(player.player.displayName), score: \(player.score)")
                        playersListTemp.append(player)
                    }
                    
                    playersListTemp.sort{
                        $0.score < $1.score
                    }
                }
            }
            //        playersList = playersListTemp
            if playersListTemp.count > 0 {
                print("players list temp contains entries")
                leaderboardEntries = playersListTemp
            }
        }
    }
}

