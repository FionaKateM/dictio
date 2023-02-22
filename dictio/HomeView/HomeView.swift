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
                    
                    VStack {
                        Button("Play practice game") {
                            playPracticeGame()
                        }
                        .disabled(practiceGameDisabled)
                    }
                    .padding()
                    
                    Spacer()
                }
                
                // Temporary buttons
                
                VStack {
                    // button for saving data
                    Button("Save some data") {
                        let game = Game(context: moc)
//                        game.guesses = NSOrderedSet(array: ["guess", "guest", "test", "new"])
                        game.ended = Date.now
                        game.started = Date.now
                        game.dailyGameID = 5
                        game.correctWord = "new"
                        let guess1 = Guess(context: moc)
                        guess1.guess = "here"
                        let guess2 = Guess(context: moc)
                        guess2.guess = "some"
                        game.guesses = [guess1, guess2]
                        try? moc.save()
                    }
                    // button for printing data
                    Button("Print data") {
                        if games.count > 0 {
                            for game in games {
                                print("WORD: \(game.correctWord)")

                                for guess in game.guessArray {
                                    print("guess: \(guess.unwrappedGuess)")
                                }
                            }
                        }
                    }
                    // button for deleting all
                    Button("delete data") {
                        print("core data: \(games)")
                        for game in games {
                            moc.delete(game)
                        }
                    }
                }
                VStack {
                    
                    
                    VStack {
                        TextField("TEST: Enter word to play", text: $selectedWord)
                            .padding()
                        Button("Play specific game") {
                            sessionSettings.gameSettings = initialiseGame(date: nil, testWord: selectedWord.lowercased(), wordLength: nil)
                            sessionSettings.appState = .game
                        }
                    }
                    .padding()
                    VStack {
                        TextField("TEST: number of letters", text: $numberOfLetters)
                            .keyboardType(.numberPad)
                            .padding()
                        Button("Play specific number of letters game") {
                            if let num = Int(numberOfLetters) {
                                sessionSettings.gameSettings = initialiseGame(date: nil, testWord: nil, wordLength: num)
                                sessionSettings.appState = .game
                            }
                        }
                    }
                    .padding()
                    Button("Leaderboard") {
                        sessionSettings.appState = .stats
                    }
                    Spacer()
                }
                
            }
        
        
        
    }
    
    func playDailyGame() {
        
        // check whether they have already played the daily game and reject
        
        // initialise the game with the daily word
        sessionSettings.gameSettings = initialiseGame(date: "\(Date.now.formatted(date: .numeric, time: .omitted))", testWord: nil, wordLength: nil)
        
        // add 1 to coins for playing a daily game
        sessionSettings.coins += 1
        sessionSettings.appState = .game
    }
    
    func playPracticeGame() {
        if sessionSettings.coins >= 1 {
            sessionSettings.coins -= 1
            sessionSettings.gameSettings = initialiseGame(date: nil, testWord: nil, wordLength: nil)
            sessionSettings.appState = .game
        } else {
            return
        }
    }
}
