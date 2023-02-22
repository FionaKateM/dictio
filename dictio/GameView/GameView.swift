//
//  ActiveGuessView.swift
//  dictio
//
//  Created by Fiona Kate Morgan on 13/02/2023.
//

import SwiftUI

struct GameView: View {
    
    @StateObject var gameSettings: GameSettings
    @EnvironmentObject var sessionSettings: SessionSettings
    @FocusState private var wordInFocus: Bool
    @Environment(\.managedObjectContext) var moc
    
    var body: some View {
        VStack {
            if gameSettings.gameState == .game {
                ZStack {
                    TextField("", text: $gameSettings.enteredWord.animation())
                        .accentColor(.clear)
                        .foregroundColor(.clear)
                        .keyboardType(.alphabet)
                        .disableAutocorrection(true)
                        .autocorrectionDisabled(true)
                        .focused($wordInFocus)
                        .onSubmit {
                            wordInFocus = true
                            checkWord()
                        }
                    VStack {
                        EnterWord()
                            .padding()
                        Text("\(gameSettings.score) guesses")
                    }.onAppear() {
                        wordInFocus = true
                    }
                    
                }
            } else if gameSettings.gameState == .ended {
                EndGameView()
            }
        }
        .environmentObject(gameSettings)
    }
    
    func checkWord() {
        // check word exists
        if !gameSettings.allValidWords.contains(gameSettings.enteredWord.lowercased()) {
            // not a valid word
            // add shake annimation
            gameSettings.enteredWordState = .invalidWord
            
            // check if answer is correct
        } else if gameSettings.correctWord.word.lowercased() == gameSettings.enteredWord.lowercased() {
            print("correct word")
            gameSettings.score += 1
            gameSettings.allGuessedWords.append(gameSettings.enteredWord.lowercased())
            gameSettings.enteredWordState = .correct
            Task {
                await endGame()
            }
        } else {
            gameSettings.score += 1
            print("all valid words")
            guard let correctWordIndex = gameSettings.allValidWords.firstIndex(of: gameSettings.correctWord.word.lowercased()), let enteredWordIndex = gameSettings.allValidWords.firstIndex(of: gameSettings.enteredWord.lowercased()) else {
                print("can't find entered or correct word index")
                return
            }
            
            if correctWordIndex > enteredWordIndex {
                // new bottom boundary
                gameSettings.enteredWordState = .newBottomBoundary
                gameSettings.wordBoundaries.0 = gameSettings.enteredWord
                
                // removes all entries up to and including the entered word
                gameSettings.allValidWords.removeFirst(enteredWordIndex+1)
                
            } else if correctWordIndex < enteredWordIndex {
                // new top boundary
                gameSettings.enteredWordState = .newBottomBoundary
                gameSettings.wordBoundaries.1 = gameSettings.enteredWord
                
                // removes all entries beyond, and including the entered word
                gameSettings.allValidWords.removeLast(gameSettings.allValidWords.count-enteredWordIndex)
            } else {
                print("correct word index: \(correctWordIndex), entered word index: \(enteredWordIndex)")
            }
            gameSettings.allGuessedWords.append(gameSettings.enteredWord.lowercased())
            gameSettings.enteredWord = ""
            gameSettings.enteredLetters = resetEnteredLetters()
            wordInFocus = true
            // top or bottom boundary
        }
        
    }
    
    func endGame() async {
        // save data
        saveGame()
        
        await leaderboard(score: gameSettings.score, word: gameSettings.correctWord.word, isDaily: gameSettings.correctWord.id != nil)
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                gameSettings.gameState = .ended
            }
        
        
    }
    
    func resetEnteredLetters() -> [String] {

        return ["", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", ""]
    }
    
    func saveGame() {
        let game = Game(context: moc)
        print("save data")
        
        // Get guesses from array and turn into ordered set
        let mutableSet: NSMutableOrderedSet = []
        for guess in gameSettings.allGuessedWords {
            print("guess is ok")
            let guessedWord = Guess(context: moc)
            guessedWord.guess = guess
            mutableSet.add(guessedWord)
            print("guessed word: \(guess)")
        }
        game.guesses = mutableSet
        
        // timestamps
        game.ended = Date.now
        game.started = gameSettings.started
        
        
        if let dailyID = gameSettings.correctWord.id {
            game.dailyGameID = Int16(dailyID)
        }
        
        game.correctWord = gameSettings.correctWord.word

        try? moc.save()
    }
}

struct EnterWord: View {
    
    @EnvironmentObject var gameSettings: GameSettings
    @FocusState private var wordInFocus: Bool
    
    // box positions and sizes
    @State var cornerSize = CGSize(width: 10, height: 10)
    private var boxSize: CGFloat = 40
    private var boxSpace: CGFloat = 20
    
    @State var splitBoxSize: CGFloat = 40
    @State var splitBoxSpace: CGFloat = 20
    @State var splitBoxOpacity: Double = 100
    
    @State var combinedBoxWidth: CGFloat = 110
    @State var combinedBoxYPosition = 200
    @State var combinedBoxOpacity: Double = 0
    @State var topBoxOpacity: Double = 100
    @State var bottomBoxOpacity: Double = 100
    
    @State var combinedBoxColor: Color = .blue
    
    var body: some View {
        VStack {
            Text("\(gameSettings.wordBoundaries.0)")
                .padding()
                .frame(width: combinedBoxWidth, height: boxSize)
                .foregroundColor(.white)
                .background(.gray)
                .clipShape(RoundedRectangle(cornerSize: cornerSize))
                .opacity(topBoxOpacity)
                .textCase(.lowercase)
            ZStack {
                // combined box
                Text("\(gameSettings.enteredWord)")
                    .padding()
                    .frame(width: combinedBoxWidth, height: boxSize)
                    .foregroundColor(.white)
                    .background(combinedBoxColor)
                    .clipShape(RoundedRectangle(cornerSize: cornerSize))
                    .opacity(combinedBoxOpacity)
                    .textCase(.lowercase)
                
                // split box
                HStack {
                    ForEach((0..<gameSettings.correctWord.word.count), id: \.self) {x in
                        Text("\(gameSettings.enteredLetters[x])")
                            .frame(width: splitBoxSize, height: boxSize)
                            .foregroundColor(.white)
                            .background(combinedBoxColor)
                            .clipShape(RoundedRectangle(cornerSize: cornerSize))
                            .opacity(splitBoxOpacity)
                            .textCase(.lowercase)
                            .padding(.bottom, boxSpace)
                            .padding(.top, boxSpace)
                            .padding(.leading, splitBoxSpace/2)
                            .padding(.trailing, splitBoxSpace/2)
                    }
                    
                }
            }
            Text("\(gameSettings.wordBoundaries.1)")
                .padding()
                .frame(width: combinedBoxWidth, height: boxSize)
                .foregroundColor(.white)
                .background(.gray)
                .clipShape(RoundedRectangle(cornerSize: cornerSize))
                .opacity(bottomBoxOpacity)
                .textCase(.lowercase)
        }
        .onAppear() {
            let letterCount = CGFloat(gameSettings.correctWord.word.count)
            combinedBoxWidth = ((letterCount)*boxSize) + ((letterCount)*splitBoxSpace)
        }
        
        .onChange(of: gameSettings.enteredWordState) { newState in
            print("new entered word state: \(newState)")
            mergeTiles()
            switch newState {
            case .correct:
                print("correct")
                combinedBoxColor = .green
            case .invalidWord:
                print("invalid")
                shakeWord()
            case .invalidOutsideBoundaries:
                print("invalid outside boundaries")
                shakeWord()
            case .newBottomBoundary:
                replaceBottomBoundary()
                print("new bottom boundary")
            case .newTopBoundary:
                replaceTopBoundary()
                print("new top boundary")
            case .activeEntering:
                print("active entering")
            }
            
        }
        
        // this updates the array of letters to fill the boxes from the transparent entered word textfield
        .onChange(of: gameSettings.enteredWord) { newWord in
            if newWord.count > gameSettings.correctWord.word.count {
                gameSettings.enteredWord = String(gameSettings.enteredWord.prefix(gameSettings.correctWord.word.count))
            }
            let array = Array(newWord)
            for x in 0..<gameSettings.correctWord.word.count {
                if x < array.count {
                    gameSettings.enteredLetters[x] = String(array[x])
                } else {
                    gameSettings.enteredLetters[x] = ""
                }
            }
        }
    }
    
    func replaceTopBoundary() {
        // move merged tiles up
        // move top boundary up at the same time
        // make top boundary box transparent once off screen
        // replace temporary top boundary (merged tiles) with new top boundary by putting it in the right position and fading it from transparency whilst fading out the temporary box  (should not be noticable to player)
        splitTiles()
    }
    
    func replaceBottomBoundary() {
        // move merged tiles down
        // move bottom boundary down at the same time
        // make bottom boundary box transparent once off screen
        // replace temporary bottom boundary (merged tiles) with new bottom boundary by putting it in the right position and fading it from transparency whilst fading out the temporary box (should not be noticable to player)
        splitTiles()
    }
    
    func mergeTiles() {
        // widen middle split tiles until looks like one box
        // replace with single box through fading (should not be noticable to player)
        withAnimation {
            splitBoxSize = combinedBoxWidth/(CGFloat(gameSettings.correctWord.word.count))
            splitBoxSpace = -(boxSpace/2)
            combinedBoxOpacity = 100
            splitBoxOpacity = 0
        }
        // consider shadows / outlines
        
    }
    
    func splitTiles() {
        // replace box with separate boxes, but make it look like s single box (should not be noticable to player)
        // decrease the size of all boxes until they are split
        withAnimation {
            splitBoxSize = boxSize
            splitBoxSpace = boxSpace
            combinedBoxOpacity = 0
            splitBoxOpacity = 100
        }
    }
    
    func appearTiles() {
        
    }
    
    func shakeWord() {
        
        splitTiles()
    }
    
    func displayMessage() {
        
        
    }
    
    
}

