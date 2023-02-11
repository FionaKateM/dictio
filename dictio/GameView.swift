//
//  GameView.swift
//  dictio
//
//  Created by Fiona Kate Morgan on 11/02/2023.
//

import SwiftUI

struct GameView: View {
    
    @State var correctWord: Word
    var alphabet = ["a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z"]
    @State private var enteredWord = ""
    @State var words: [String] = []
    @State var wordColour = Color.black
    @State var visualisedWords: [String] = []
    @State var wordLocation: [String] = []
    @FocusState private var wordInFocus: Bool
    // min, max, location of correct word
    @State var colourIndices = (0, 26, 500)
    @State var scrollLocation = 0
    
    @State var enteredLetters: [String] = ["", "", "", "", "", "", "", "", "", "", "", "", ""]
    @FocusState var focusedLetter: Focusable?
    
    
    @State var gameEnded = false
    
    // aim is to have the lowest score, so this increases by 1 each time an incorrect guess is entered
    @State var score = 0
    
    var body: some View {
        ScrollViewReader { proxy in
            VStack {
                ZStack {
                    TextField("", text: $enteredWord)
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
                        ForEach((0..<correctWord.word.count), id: \.self) {x in
                            if enteredLetters[x] == "" {
                                Rectangle()
                                    .fill(.gray)
                                    .frame(width: 20, height: 20)
                            } else {
                                Text("\(enteredLetters[x])")
                            }
                            
                        }
                    }
                }
                
                HStack {
                    List(visualisedWords, id: \.self) { word in
                        if let index = visualisedWords.firstIndex(of: word) {
                            if word == correctWord.word {
                                Text(word)
                                    .id(index + 10)
                                    .foregroundColor(.green)
                                    .bold()
                                
                            } else {
                                Text(word)
                                    .id(index + 10)
                                    .foregroundColor((index < colourIndices.0 || index > colourIndices.1) ? .gray : .black)
                            }
                        }
                    }.padding()
                }
            }
            .alert(isPresented: $gameEnded) {
                Alert(title: Text("Score: \(score)"), message: Text("Game ended"), dismissButton: .default(Text("OK")))
            }
            .onAppear {
                wordInFocus = true
                if words.count == 0 {
                    words.append(contentsOf: getWordsOf(length: correctWord.word.count))
                    words = words.sorted()
                    enteredLetters = resetEnteredLetters()
                    setTextFocus()
                    print("correct word is: \(correctWord.word)")
                }
                
                if visualisedWords.count == 0 {
                    visualisedWords.append(contentsOf: alphabet)
                    visualisedWords.sort()
                }
                
                if !wordLocation.contains(correctWord.word.lowercased()) {
                    wordLocation.append(correctWord.word.lowercased())
                    wordLocation.sort()
                    colourIndices.2 = wordLocation.firstIndex(of: correctWord.word.lowercased()) ?? 500
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.75) {
                    self.wordInFocus = true
                }
            }
            .onChange(of: scrollLocation) { newValue in
                proxy.scrollTo(newValue, anchor: .center)
            }
            .onChange(of: enteredWord) { newWord in
                if newWord.count > correctWord.word.count {
                    enteredWord = String(enteredWord.prefix(correctWord.word.count))
                }
//                for x in 0..<newWord.count {
//                    enteredLetters[x] = String(Array(newWord)[x])
//                }
                let array = Array(newWord)
                for x in 0..<correctWord.word.count {
                    if x < array.count {
                        enteredLetters[x] = String(array[x])
                    } else {
                        enteredLetters[x] = ""
                    }
                    
//                    enteredLetters[x] = Array(newWord[x])
                }
            }
            //            .onChange(of: enteredLetters) { newValue in
            //                for index in (0..<enteredLetters.count) {
            //                    if enteredLetters[index].count > 1 {
            //                        // multiple letters entered in single box, move next letter to next box
            //                        enteredLetters[index] = String(enteredLetters[index].prefix(1))
            //                    }
            //                }
            //                enteredWord = enteredLetters.joined(separator: "")
            //                setTextFocus()
            //            }
        }
    }
    
    func checkWord() {
        
        // check word exists
        if !words.contains(enteredWord.lowercased()) {
            // not a valid word
            // add shake annimation
            //            wordInFocus = true
            setTextFocus()
            
            // check if answer is correct
        } else if correctWord.word.lowercased() == enteredWord.lowercased() {
            visualisedWords.append(enteredWord.lowercased())
            visualisedWords.sort()
            wordLocation.append(enteredWord.lowercased())
            wordLocation.sort()
            updateVisuals()
            endGame()
            
            // check if word has already been guessed
        } else if visualisedWords.contains(enteredWord.lowercased()) {
            // word has already been guessed
            //            wordInFocus = true
            setTextFocus()
            
            // valid word and not yet guessed - not correct
        } else {
            score += 1
            visualisedWords.append(enteredWord.lowercased())
            visualisedWords.sort()
            wordLocation.append(enteredWord.lowercased())
            wordLocation.sort()
            updateVisuals()
            enteredWord = ""
            enteredLetters = resetEnteredLetters()
            setTextFocus()
            //            wordInFocus = true
        }
    }
    
    func updateVisuals() {
        
        // at this point the checking of the word is complete, and we are tidying up the 'visualised words' array
        
        // get the indices needed
        guard let correctWordIndex = wordLocation.firstIndex(of: correctWord.word.lowercased()) else {
            print("cannot find winning word in wordLocation array")
            return
        }
        
        // remove elipses
        if let elipsesIndex = visualisedWords.firstIndex(of: "...") {
            visualisedWords.remove(at: elipsesIndex)
        }
        
        
        // Only contain letters that don't have words guessed yet
        var temporaryArray = alphabet
        
        // remove alphabet from visualised words list
        visualisedWords = Array(Set(visualisedWords).subtracting(Set(alphabet)))
        
        // for each word in the guessed list, remove the first letter from the temporary array
        for word in visualisedWords {
            if let index = temporaryArray.firstIndex(of:String(word.prefix(1))) {
                temporaryArray.remove(at: index)
            }
        }
        
        // combine any left over letters with the visualised words array
        if temporaryArray.count > 0 {
            visualisedWords.append(contentsOf: temporaryArray)
        }
        visualisedWords.sort()
        
        // check if new elipses are needed
        var minWord = ""
        var maxWord = ""
        
        // look for location of correct word
        if correctWordIndex > 0 {
            minWord = wordLocation[correctWordIndex-1]
        }
        if correctWordIndex < wordLocation.count-1 {
            maxWord = wordLocation[correctWordIndex+1]
        }
        
        
        if let minWordLocation = visualisedWords.firstIndex(of: minWord) {
            colourIndices.0 = minWordLocation
        }
        
        if let maxWordLocation = visualisedWords.firstIndex(of: maxWord) {
            colourIndices.1 = maxWordLocation
        }
        
        if let index = visualisedWords.firstIndex(of: correctWord.word.lowercased()) {
            colourIndices.0 = index
            colourIndices.1 = index
        }
        
        if colourIndices.1 - colourIndices.0 == 1 {
            visualisedWords.insert("...", at: colourIndices.0 + 1)
            colourIndices.1 += 1
        }
        
        // sort scroll location
        if let enteredWordIndex = visualisedWords.firstIndex(of: enteredWord.lowercased()) {
            // if the entered word falls outside the current min or max guess then scroll to show the word entered
            if (enteredWordIndex < colourIndices.0) || (enteredWordIndex > colourIndices.1) || (colourIndices.1 - colourIndices.0 >= 5) {
                scrollLocation = enteredWordIndex + 10
            } else {
                scrollLocation = ((colourIndices.1 + colourIndices.0)/2) + 10
            }
        }
    }
    
    func endGame() {
        print("game ended")
        gameEnded = true
    }
    
    func setTextFocus() {
        // can't move focus manually
        // focus is always on first value that is empty
        // when letter is entered, move to next focus
        // if letter is entered in final box, don't change
        wordInFocus = true
//        for index in 0..<correctWord.word.count {
//            if enteredLetters[index].count == 0 {
//                focusedLetter = .row(id: index)
//                return
//            } else if index + 1 == correctWord.word.count {
//                print("focus on final letter")
//                focusedLetter = .row(id: correctWord.word.count - 1)
//                return
//            }
//        }
//
        // if enter is pressed then focus is set to 0
        
    }
    
    enum Focusable: Hashable {
        case none
        case row(id: Int)
    }
    
    struct Reminder: Identifiable {
        var id: String = UUID().uuidString
        var title: String
    }
    
    
}

// word exists
// check if it is in 'words' array
// word already been said
// check if it is in 'visualised words' array
// add word to visualised words
// append to visualised words array
// append to word location array
// remove elipses
// remove elipses from 'visualised words' array
// remove un-needed alphabet letters
// for each word with length more than 1 in visualised words array, find out first letter then remove that from the array if it exists
// discover new location of min and max
// look at the word either side of the winning word in the 'word location' array and find their positions in 'visualised words' array.
// if max - min == 1 then add elipses and update max += 1


