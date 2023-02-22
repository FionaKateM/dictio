//
//  HomeView.swift
//  dictio
//
//  Created by Fiona Kate Morgan on 12/02/2023.
//

import SwiftUI
import GameKit

// Home View is the view active when there is no game in play (dictated by the session settings app state variable
// Home View can present the home screen (with buttons to initialise the game), profile view and stats view

struct HomeView: View {
    
    @EnvironmentObject var sessionSettings: SessionSettings
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(sortDescriptors: []) var games: FetchedResults<Game>
    
    @State var selectedWord: String = ""
    @State var numberOfLetters: String = ""
    
    @State var dailyGameDisabled = false
    @State var practiceGameDisabled = false
    
    var body: some View {
        VStack {
            
            // Top bar
            
            HStack() {
                Spacer()
                Button {
                    sessionSettings.appState = .profile
                } label: {
                    Image(systemName: "person.circle")
                    
                }
                .padding()
                Button {
                    sessionSettings.appState = .coins
                } label: {
                    Text("\(sessionSettings.coins)")
                        .padding()
                        .foregroundColor(.white)
                        .background(.blue)
                        .clipShape(Circle())
                }
            }
            .padding()
            
            Spacer()
            
            // Gameplay
            
            VStack {
                Spacer()
                
                VStack {
                    Button("Play daily game") {
                        playDailyGame()
                    }
                    .disabled(dailyGameDisabled)
                    Text("\(Date.now.formatted(date: .numeric, time: .omitted))")
                }
                .padding()
                .onAppear() {
                    checkIfDailyGamePlayed()
                    checkIfPracticeAllowed()
                }
                
                VStack {
                    Button("Play practice game") {
                        playPracticeGame()
                    }
                    .disabled(practiceGameDisabled)
                }
                .padding()
                
                Spacer()
                
            }
            
        }
        
        
        
    }
    func checkIfDailyGamePlayed() {
        // check whether they have already played the daily game and reject
        let dailyWord = getDailyWord(date: "\(Date.now.formatted(date: .numeric, time: .omitted))")
        
        if sessionSettings.playedGames.filter({ $0.correctWord == dailyWord?.word}).count > 0 {
            // daily word already played
            dailyGameDisabled = true
        }
    }
    
    func checkIfPracticeAllowed() {
        if sessionSettings.coins > 0 {
            practiceGameDisabled = false
        } else {
            practiceGameDisabled = true
        }
    }
    
    func playDailyGame() {
        
        
        
        
        
        // initialise the game with the daily word
        sessionSettings.gameSettings = initialiseGame(date: "\(Date.now.formatted(date: .numeric, time: .omitted))")
        
        // add 1 to coins for playing a daily game
        sessionSettings.coins += 1

        dailyGameDisabled = true
        sessionSettings.appState = .game
    }
    
    func playPracticeGame() {
        if sessionSettings.coins >= 1 {
            sessionSettings.coins -= 1
            sessionSettings.gameSettings = initialiseGame(date: nil)
            sessionSettings.appState = .game
        } else {
            return
        }
    }
}
