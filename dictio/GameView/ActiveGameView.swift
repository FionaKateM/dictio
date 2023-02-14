//
//  ActiveGuessView.swift
//  dictio
//
//  Created by Fiona Kate Morgan on 13/02/2023.
//

import SwiftUI

struct ActiveGameView: View {
    
    @EnvironmentObject var settings: GameSettings
    @FocusState private var wordInFocus: Bool
    
    var body: some View {
        ZStack {
            TextField("", text: $settings.enteredWord.animation())
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
                Text("\(settings.score) guesses")
            }
            
            
        }
        .onAppear() {
            wordInFocus = true
        }
        
    }
    
    func checkWord() {
        // check word exists
        if !settings.allValidWords.contains(settings.enteredWord.lowercased()) {
            // not a valid word
            // add shake annimation
            settings.enteredWordState = .invalidWord
            
            // check if answer is correct
        } else if settings.correctWord.word.lowercased() == settings.enteredWord.lowercased() {
            print("correct word")
            settings.score += 1
            settings.visualisedWords.append(settings.enteredWord.lowercased())
            settings.visualisedWords.sort()
            settings.wordLocation.append(settings.enteredWord.lowercased())
            settings.wordLocation.sort()
            settings.enteredWordState = .correct
            Task {
                    await endGame()
                }
            // check if word has already been guessed
        } else if settings.visualisedWords.contains(settings.enteredWord.lowercased()) {
            print("word already guessed")
            // word has already been guessed
            wordInFocus = true
            settings.enteredWordState = .invalidOutsideBoundaries
            // valid word and not yet guessed - not correct
        } else {
            print("word added to visualised words: \(settings.enteredWord)")
            settings.score += 1
            print("all valid words")
            guard let correctWordIndex = settings.allValidWords.firstIndex(of: settings.correctWord.word.lowercased()), let enteredWordIndex = settings.allValidWords.firstIndex(of: settings.enteredWord.lowercased()) else {
                print("can't find entered or correct word index")
                return
            }
            
            if correctWordIndex > enteredWordIndex {
                // new bottom boundary
                settings.enteredWordState = .newBottomBoundary
                settings.wordBoundaries.0 = settings.enteredWord
                
                // removes all entries up to and including the entered word
                settings.allValidWords.removeFirst(enteredWordIndex+1)
                
            } else if correctWordIndex < enteredWordIndex {
                // new top boundary
                settings.enteredWordState = .newBottomBoundary
                settings.wordBoundaries.1 = settings.enteredWord
                
                // removes all entries beyond, and including the entered word
                settings.allValidWords.removeLast(settings.allValidWords.count-enteredWordIndex)
            } else {
                print("correct word index: \(correctWordIndex), entered word index: \(enteredWordIndex)")
            }
            
            
            settings.visualisedWords.append(settings.enteredWord.lowercased())
            settings.visualisedWords.sort()
            settings.wordLocation.append(settings.enteredWord.lowercased())
            settings.wordLocation.sort()
            settings.enteredWord = ""
            settings.enteredLetters = resetEnteredLetters()
            wordInFocus = true
            
            // top or bottom boundary
        }
        
    }
    
    func endGame() async {
        await leaderboard(score: settings.score, word: settings.correctWord.word, isDaily: false)
    }
}

struct EnterWord: View {
    
    @EnvironmentObject var settings: GameSettings
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
            Text("\(settings.wordBoundaries.0)")
                .padding()
                .frame(width: combinedBoxWidth, height: boxSize)
                .foregroundColor(.white)
                .background(.gray)
                .clipShape(RoundedRectangle(cornerSize: cornerSize))
                .opacity(topBoxOpacity)
                .textCase(.lowercase)
            ZStack {
                // combined box
                Text("\(settings.enteredWord)")
                    .padding()
                    .frame(width: combinedBoxWidth, height: boxSize)
                    .foregroundColor(.white)
                    .background(combinedBoxColor)
                    .clipShape(RoundedRectangle(cornerSize: cornerSize))
                    .opacity(combinedBoxOpacity)
                    .textCase(.lowercase)
                
                // split box
                HStack {
                    ForEach((0..<settings.correctWord.word.count), id: \.self) {x in
                        Text("\(settings.enteredLetters[x])")
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
            Text("\(settings.wordBoundaries.1)")
                .padding()
                .frame(width: combinedBoxWidth, height: boxSize)
                .foregroundColor(.white)
                .background(.gray)
                .clipShape(RoundedRectangle(cornerSize: cornerSize))
                .opacity(bottomBoxOpacity)
                .textCase(.lowercase)
        }
        .onAppear() {
            let letterCount = CGFloat(settings.correctWord.word.count)
            combinedBoxWidth = ((letterCount)*boxSize) + ((letterCount)*splitBoxSpace)
        }
        
        .onChange(of: settings.enteredWordState) { newState in
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
        .onChange(of: settings.enteredWord) { newWord in
            if newWord.count > settings.correctWord.word.count {
                settings.enteredWord = String(settings.enteredWord.prefix(settings.correctWord.word.count))
            }
            let array = Array(newWord)
            for x in 0..<settings.correctWord.word.count {
                if x < array.count {
                    settings.enteredLetters[x] = String(array[x])
                } else {
                    settings.enteredLetters[x] = ""
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
            splitBoxSize = combinedBoxWidth/(CGFloat(settings.correctWord.word.count))
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

