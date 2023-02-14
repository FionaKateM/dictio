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
    
    @State var selectedWord: String = ""
    @State var numberOfLetters: String = "4"
    var body: some View {
        NavigationView {
            VStack {
                Spacer()
                VStack {
                    Spacer()
                    
                    Button("Play daily game") {
                        sessionSettings.gameSettings = initialiseGame(date: "\(Date.now.formatted(date: .numeric, time: .omitted))", testWord: nil, wordLength: nil)
                        sessionSettings.appState = .game
                    }
                    Button("Play practice game") {
                        sessionSettings.gameSettings = initialiseGame(date: nil, testWord: nil, wordLength: nil)
                        sessionSettings.appState = .game
                    }
                    Spacer()
                    VStack {
                        TextField("TEST: Enter word to play", text: $selectedWord)
                        Button("Play specific game") {
                            sessionSettings.gameSettings = initialiseGame(date: nil, testWord: selectedWord.lowercased(), wordLength: nil)
                            sessionSettings.appState = .game
                        }
                    }
                    VStack {
                        TextField("TEST: number of letters", text: $numberOfLetters)
                        Button("Play specific game") {
                            if let num = Int(numberOfLetters) {
                                sessionSettings.gameSettings = initialiseGame(date: nil, testWord: nil, wordLength: num)
                                sessionSettings.appState = .game
                            }
                        }
                    }
                }
                
            }
        }
        
        
        
    }
}
