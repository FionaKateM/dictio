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
    
    @State var localPlayer = GKLocalPlayer.local
    
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
//                        .padding()
                        .frame(width: 20, height: 20)
                        .foregroundColor(.white)
                    
                }
                                .padding()
                Button {
                    sessionSettings.appState = .coins
                } label: {
                    ZStack {
                        Circle()
                            .fill(.white)
                            .frame(width: 20, height: 20)
                        Text("\(sessionSettings.playerData.coins)")
                            .foregroundColor(.blue)
                    }
                }
                .padding()
                Button {
                    sessionSettings.appState = .stats
                } label: {
                    Image(systemName: "chart.xyaxis.line")
//                        .padding()
                        .frame(width: 20, height: 20)
                        .foregroundColor(.white)
                    
                }
                .padding()
                
            }
            .padding()
            
            Spacer()
            
            // Gameplay
            
            VStack {
                Spacer()
                
                VStack {
                    Button("Play daily game") {
                        Task {
                            await playDailyGame()
                        }
                    }
                    .disabled(dailyGameDisabled)
                    .foregroundColor(dailyGameDisabled ? .gray : .white)
                    Text("\(Date.now.formatted(date: .numeric, time: .omitted))")
                        .foregroundColor(.gray)
                }
                .padding()
                .border(.white)
                .onAppear() {
                    Task {
                        await checkIfDailyGamePlayed()
                    }
                    checkIfPracticeAllowed()
                }
                
                VStack {
                    Button("Play practice game") {
                        Task {
                            await playPracticeGame()
                        }
                    }
                    .disabled(practiceGameDisabled)
                    .foregroundColor(practiceGameDisabled ? .gray : .white)
                }
                .padding()
                .border(.white)
                Spacer()
                
            }
            
            VStack {
                // temporary button
                
                Button("Delete saved game: blew") {
                    Task {
                        await deleteSavedGame(name: "blew")
                    }
                }
            }
        }
    }
    
    func deleteSavedGame(name: String) async {
        print("deleting game")
        try? await localPlayer.deleteSavedGames(withName: name)
    }
    
    func checkIfDailyGamePlayed() async {
        do {
            let g = try await self.fetchPlayedGames()
            sessionSettings.playedGames = g
            let date = formatDate(Date.now)
            print("checking if daily game played")
            // check whether they have already played the daily game and reject
            let dailyWord = await getDailyWord(date: date)
            for game in sessionSettings.playedGames {
                if game.name == dailyWord?.word {
                    // TODO: if word was played but not as daily game then they should be able to play it again but as a daily game, keeping their daily score on the leaderboard
                    print("daily game has been played")
                    dailyGameDisabled = true
                    return
                }
            }
        }
        catch {
            
        }
    }
    
    func fetchPlayedGames() async throws -> ([GKSavedGame]) {
        return try await localPlayer.fetchSavedGames()
    }
    
    func checkIfPracticeAllowed() {
        if sessionSettings.playerData.coins > 0 {
            practiceGameDisabled = false
        } else {
            practiceGameDisabled = true
        }
    }
    
    func playDailyGame() async {
        
        let date = formatDate(Date.now)
        print("date: \(date)")
        
        // initialise the game with the daily word
        sessionSettings.gameSettings = await initialiseGame(date: "\(date)")
        
        // add 1 to coins for playing a daily game
        sessionSettings.playerData.coins += 1
        
        dailyGameDisabled = true
        
        if let count = sessionSettings.gameSettings?.correctWord.word.count {
            if count > 0 {
                sessionSettings.appState = .game
            } else {
                print("Can't load daily game")
            }
        }
    }
    
    func playPracticeGame() async {
        if sessionSettings.playerData.coins >= 1 {
            sessionSettings.playerData.coins -= 1
            sessionSettings.gameSettings = await initialiseGame(date: nil)
            sessionSettings.appState = .game
        } else {
            return
        }
    }
    
    func playSpecificGame(word: String) {
        
        let correctWord = Word(word: word.lowercased(), definition: "xxx")
        //*** Game initialisation ***
        
        // gets all accepted words the same length as correct word
        let words = getWordsOf(length: correctWord.word.count)
        
        // sets the number of entered letters to the number of letters in the correct word
        var enteredLetters: [String] = []
        for _ in 0..<correctWord.word.count {
            enteredLetters.append("")
        }
        
        // initialises the gameSettings struct
        sessionSettings.gameSettings = GameSettings(score: 0, correctWord: correctWord, enteredWord: "", allWords: words, allValidWords: words, wordLocation: [correctWord.word], colourIndices: (0, 26, 500), enteredLetters: enteredLetters, gameState: .game, started: Date.now)
        
        sessionSettings.appState = .game
    }
}
