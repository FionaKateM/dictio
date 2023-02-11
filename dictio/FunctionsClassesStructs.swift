//
//  FunctionsClassesStructs.swift
//  dictio
//
//  Created by Fiona Kate Morgan on 11/02/2023.
//

import Foundation
import SwiftUI

func parse(json: Data) -> JSON? {
    if let parsed = try? JSON(data: json) {
        return parsed
    } else {
        print(json)
    }
    return nil
}



struct Word : Codable {
    var word: String
    var definition: String
}

struct Words : Codable {
    var words: [Word]
}


func getCorrectWords() -> [Word] {
    var correctWords: [Word] = []
    if let wordsURL = Bundle.main.url(forResource: "correct-words", withExtension: "json") {
//        print("here 1")
        if let data = try? Data(contentsOf: wordsURL) {
            // we're OK to parse!
//            print("here 2")
            if let json = parse(json: data) {
//                print("here 3")
                for item in json {
                    let word = Word(word: "\(item.1["word"].rawValue)", definition: "\(item.1["definition"].rawValue)")
//                    correctWords.append("\(item.1["word"].rawValue)")
                    correctWords.append(word)
//                    print(word)
                }
            }
        }
    }
    
    return correctWords
    
}

func getWordsOf(length: Int) -> [String] {
    var allWords: [String] = []
    
    if let wordsURL = Bundle.main.url(forResource: "\(length)-letter-words", withExtension: "json") {
        if let data = try? Data(contentsOf: wordsURL) {
            // we're OK to parse!
            if let json = parse(json: data) {
                for item in json {
                    if let word = item.1.dictionaryValue.first?.value.rawValue {
                        allWords = allWords + ["\(word)"]
                    }
                }
            }
        }
    }
    return allWords
}

func getAllWords() -> [String] {
    var allWords: [String] = []
    
    for i in 4...15 {
        allWords.append(contentsOf: getWordsOf(length: i))
    }
    
    return allWords.sorted()
}

func getWord() -> Word {
    let word = getCorrectWords().randomElement() ?? Word(word: "", definition: "")
    print("word got: \(word.word)")
    return word
}

func resetEnteredLetters() -> [String] {

    return ["", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", ""]
}

class GameSettings: ObservableObject {
    @Published var score = 0
    @Published var correctWord: Word = Word(word: "", definition: "")
    @Published var enteredWord = ""
    @Published var words: [String] = []
    @Published var visualisedWords: [String] = ["a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z"]
    @Published var wordLocation: [String] = []
    @Published var colourIndices = (0, 26, 500)
    @Published var enteredLetters: [String]
    @Published var gameEnded = false
    
    init(score: Int = 0, correctWord: Word, enteredWord: String = "", words: [String], wordLocation: [String], colourIndices: (Int, Int, Int) = (0, 26, 500), enteredLetters: [String], gameEnded: Bool = false) {
        self.score = 0
        self.correctWord = correctWord
        self.enteredWord = enteredWord
        self.words = words
        self.wordLocation = wordLocation
        self.colourIndices = colourIndices
        self.enteredLetters = enteredLetters
        self.gameEnded = gameEnded
    }
}

func initialiseGame() -> GameSettings {
    let correctWord = getWord()
    let words = getWordsOf(length: correctWord.word.count)
    var enteredLetters: [String] = []
    for _ in 0..<correctWord.word.count {
        enteredLetters.append("")
    }
    
    print("returning game settings with word: \(correctWord.word)")
    return GameSettings(score: 0, correctWord: correctWord, enteredWord: "", words: words, wordLocation: [correctWord.word], colourIndices: (0, 26, 500), enteredLetters: enteredLetters, gameEnded: false)
}
