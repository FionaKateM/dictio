//
//  StatsView.swift
//  dictio
//
//  Created by Fiona Kate Morgan on 13/02/2023.
//

import SwiftUI

// Stats view is the overview of stats and can present specific to a single word, the daily game, or more broadly the overall performance of the player against their friends

struct StatsView: View {
    @EnvironmentObject var sessionSettings: SessionSettings
    
    var body: some View {
        VStack {
            StreakView()
            LeaderboardView()
        }
    }
}

struct StreakView: View {
    @EnvironmentObject var sessionSettings: SessionSettings
    @State var streakInt = 0
    var body: some View {
        Text("You have played for \(streakInt) successive days")
            .onAppear() {
                Task {
                    await calculateStreak()
                }
            }
    }
    
    func calculateStreak() async {
        let todaysID = await whatIsTodaysDailyID()
        let games = await sessionSettings.loadPlayedGamesData()
        var filtered = games.filter{$0.dailyID != nil}
        filtered.sort {
            $0.dailyID! > $1.dailyID!
        }
        
        for i in (1...todaysID).reversed() {
            if games.contains(where: {$0.dailyID == i}) {
                print("contains: \(i)")
                streakInt += 1
            } else if todaysID == i {
                print("has not played today's game yet")
            } else {
                print("does not contain: \(i)")
                break
            }
        }
    }
}




