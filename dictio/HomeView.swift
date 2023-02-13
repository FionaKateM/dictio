//
//  HomeView.swift
//  dictio
//
//  Created by Fiona Kate Morgan on 12/02/2023.
//

import SwiftUI
import GameKit

struct HomeView: View {
    
    let localPlayer = GKLocalPlayer.local
    func authenticateUser() {
        localPlayer.authenticateHandler = { vc, error in
            guard error == nil else {
                print(error?.localizedDescription ?? "")
                return
            }
            GKAccessPoint.shared.isActive = localPlayer.isAuthenticated
        }
    }
    
    @State var selectedWord: String = ""
    var body: some View {
        NavigationView {
            VStack {
                Spacer()
                VStack {
                    TextField("TEST: Enter word to play", text: $selectedWord)
                    Spacer()
                    VStack {
                        NavigationLink(destination: GameView(settings: initialiseGame(id: "\(Date.now.formatted(date: .numeric, time: .omitted))"))) {
                            Text("Play Daily Game")
                        }
                        Text(Date.now.formatted(date: .numeric, time: .omitted))
                    }
                    .padding()
                    NavigationLink(destination: GameView(settings: initialiseGame(id: nil))) {
                        Text("Play Practice Game")
                    }
                    .padding()
                    NavigationLink(destination: GameView(settings: initialiseGame(id: selectedWord.lowercased()))) {
                        Text("Play Practice Game with selected word")
                    }
                    Spacer()
                    NavigationLink(destination: LeaderboardView()) {
                        Text("Leaderboard for test")
                    }
                    Spacer()
                }
                Spacer()
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .onAppear {
            authenticateUser()
//            print(loadAchievements())
        }
    }
}



