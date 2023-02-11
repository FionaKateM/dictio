//
//  GameComponentViews.swift
//  dictio
//
//  Created by Fiona Kate Morgan on 11/02/2023.
//

import SwiftUI

struct GuessedWordView: View {
    @EnvironmentObject var settings: GameSettings
    @FocusState private var wordInFocus: Bool
    
    var alphabet = ["a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z"]
    
    var body: some View {
        ZStack {
            TextField("", text: $settings.enteredWord)
                .accentColor(.clear)
                .foregroundColor(.clear)
                .keyboardType(.alphabet)
                .disableAutocorrection(true)
                .focused($wordInFocus)
                .onSubmit {
                    wordInFocus = true
                    checkWord()
                }
                
            HStack {
                ForEach((0..<settings.correctWord.word.count), id: \.self) {x in
                    if settings.enteredLetters[x] == "" {
                        Rectangle()
                            .fill(.gray)
                            .frame(width: 20, height: 20)
                    } else {
                        Text("\(settings.enteredLetters[x])")
                    }
                    
                }
            }
        }
        .onChange(of: settings.enteredWord) { newWord in
            print("new word: \(newWord)")
            print("correct word: \(settings.correctWord.word)")
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
        .onAppear {
            wordInFocus = true
        }
    }
    
    func checkWord() {
        
        // check word exists
        if !settings.words.contains(settings.enteredWord.lowercased()) {
            // not a valid word
            // add shake annimation
            wordInFocus = true
            print("not a valid word: \(settings.enteredWord)")
           
            
            // check if answer is correct
        } else if settings.correctWord.word.lowercased() == settings.enteredWord.lowercased() {
            print("correct word")
            settings.visualisedWords.append(settings.enteredWord.lowercased())
            settings.visualisedWords.sort()
            settings.wordLocation.append(settings.enteredWord.lowercased())
            settings.wordLocation.sort()
            updateVisuals()
            settings.gameEnded = true
            
            // check if word has already been guessed
        } else if settings.visualisedWords.contains(settings.enteredWord.lowercased()) {
            print("word already guessed")
            // word has already been guessed
            wordInFocus = true
            
            // valid word and not yet guessed - not correct
        } else {
            print("word added to visualisaed words: \(settings.enteredWord)")
            settings.score += 1
            settings.visualisedWords.append(settings.enteredWord.lowercased())
            settings.visualisedWords.sort()
            settings.wordLocation.append(settings.enteredWord.lowercased())
            settings.wordLocation.sort()
            updateVisuals()
            settings.enteredWord = ""
            settings.enteredLetters = resetEnteredLetters()
            wordInFocus = true
        }
    }
    
    func updateVisuals() {
        
        // at this point the checking of the word is complete, and we are tidying up the 'visualised words' array
        
        // get the indices needed
        guard let correctWordIndex = settings.wordLocation.firstIndex(of: settings.correctWord.word.lowercased()) else {
            print("cannot find winning word in wordLocation array")
            return
        }
        
        // remove elipses
        if let elipsesIndex = settings.visualisedWords.firstIndex(of: "...") {
            settings.visualisedWords.remove(at: elipsesIndex)
        }
        
        
        // Only contain letters that don't have words guessed yet
        var temporaryArray = alphabet
        
        // remove alphabet from visualised words list
        settings.visualisedWords = Array(Set(settings.visualisedWords).subtracting(Set(alphabet)))
        
        // for each word in the guessed list, remove the first letter from the temporary array
        for word in settings.visualisedWords {
            if let index = temporaryArray.firstIndex(of:String(word.prefix(1))) {
                temporaryArray.remove(at: index)
            }
        }
        
        // combine any left over letters with the visualised words array
        if temporaryArray.count > 0 {
            settings.visualisedWords.append(contentsOf: temporaryArray)
        }
        settings.visualisedWords.sort()
        
        // check if new elipses are needed
        var minWord = ""
        var maxWord = ""
        
        // look for location of correct word
        if correctWordIndex > 0 {
            minWord = settings.wordLocation[correctWordIndex-1]
        }
        if correctWordIndex < settings.wordLocation.count-1 {
            maxWord = settings.wordLocation[correctWordIndex+1]
        }
        
        
        if let minWordLocation = settings.visualisedWords.firstIndex(of: minWord) {
            settings.colourIndices.0 = minWordLocation
        }
        
        if let maxWordLocation = settings.visualisedWords.firstIndex(of: maxWord) {
            settings.colourIndices.1 = maxWordLocation
        }
        
        if let index = settings.visualisedWords.firstIndex(of: settings.correctWord.word.lowercased()) {
            settings.colourIndices.0 = index
            settings.colourIndices.1 = index
        }
        
        if settings.colourIndices.1 - settings.colourIndices.0 == 1 {
            settings.visualisedWords.insert("...", at: settings.colourIndices.0 + 1)
            settings.colourIndices.1 += 1
        }
        
        // sort scroll location
//        if let enteredWordIndex = settings.visualisedWords.firstIndex(of: settings.enteredWord.lowercased()) {
//            // if the entered word falls outside the current min or max guess then scroll to show the word entered
//            if (enteredWordIndex < settings.colourIndices.0) || (enteredWordIndex > settings.colourIndices.1) || (settings.colourIndices.1 - settings.colourIndices.0 >= 5) {
////                $settings.scrollLocation = enteredWordIndex
//            } else {
////                $settings.scrollLocation = ((settings.colourIndices.1 + settings.colourIndices.0)/2) + 10
//            }
//        }
    }
}

struct AlphabetView: View {
    @EnvironmentObject var settings: GameSettings
    @FocusState private var scrollLocation: Bool
    
    var body: some View {
        ScrollViewReader { proxy in
            HStack {
                List(settings.visualisedWords, id: \.self) { word in
                    if let index = settings.visualisedWords.firstIndex(of: word) {
                        if word == settings.correctWord.word {
                            Text(word)
                                .id(index)
                                .foregroundColor(.green)
                                .bold()
                            
                        } else {
                            Text(word)
                                .id(index)
                                .foregroundColor((index < settings.colourIndices.0 || index > settings.colourIndices.1) ? .gray : .black)
                        }
                    }
                }
                .padding()
                .onChange(of: scrollLocation) { newValue in
                    proxy.scrollTo(newValue, anchor: .center)
                }
            }
        }
    }
}


