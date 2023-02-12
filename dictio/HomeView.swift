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
    var body: some View {
        NavigationView {
            VStack {
                NavigationLink(destination: GameView(settings: initialiseGame(id: "\(Date.now.formatted(date: .numeric, time: .omitted))"))) {
                    Text("Play Daily Game")
                }
//                NavigationLink(destination: DailyWordsArrage()) {
//                    Text("Get words")
//                }
//                Button("Get daily word") {
//                    let id = "\(Date.now.formatted(date: .numeric, time: .omitted))"
//                    print("daily word: \(getDailyWord(id: id))")
//                    
//                }
                
                Text(Date.now.formatted(date: .numeric, time: .omitted))
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .onAppear {
            authenticateUser()
//            print(loadAchievements())
        }
    }
}



