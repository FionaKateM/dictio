//
//  FunctionsClassesStructs.swift
//  dictio
//
//  Created by Fiona Kate Morgan on 11/02/2023.
//

import Foundation
import SwiftUI
import GameKit

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


func getDailyWord(id: String) -> Word? {
//    var word = Word(word: "", definition: "")
    if let wordsURL = Bundle.main.url(forResource: "daily-words-date", withExtension: "json") {
        if let data = try? Data(contentsOf: wordsURL) {
            // we're OK to parse!
            if let json = parse(json: data) {
                let dict = json[0]
                print("returning word: \(dict[id])")

                return Word(word: "\(dict[id])", definition: "")
//                let word = "\(dict[id])"
            } else {
                return nil
            }
        } else {
            return nil
        }
    } else {
//        print("word from daily word func: \(word.word)")
        return nil
    }
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

func initialiseGame(date: String?, testWord: String?, wordLength: Int?) -> GameSettings {
    var correctWord: Word = Word(word: "", definition: "")
    if let dateID = date {
        print("getting daily word")
        // TODO: add check that they have not already played the daily game
        if let word = getDailyWord(id: dateID) {
            correctWord = word
        }
        
    } else if let testWord = testWord {
        print("word does equals speechmarks")
        correctWord = Word(word: testWord.lowercased(), definition: "")
    } else if let length = wordLength {
        // get word of specific length from correct words
        // TODO - fix this
        switch length {
        case 4:
            correctWord = Word(word: "test", definition: "xxx")
        case 5:
            correctWord = Word(word: "hello", definition: "xxx")
        case 6:
            correctWord = Word(word: "abacus", definition: "xxx")
        case 7:
            correctWord = Word(word: "abysmal", definition: "xxx")
        case 8:
            correctWord = Word(word: "absolute", definition: "xxx")
        default:
            correctWord = Word(word: "unbelievable", definition: "xxx")
        }
    } else {
        correctWord = getWord()
    }
    
    let words = getWordsOf(length: correctWord.word.count)
    var enteredLetters: [String] = []
    for _ in 0..<correctWord.word.count {
        enteredLetters.append("")
    }
    
    print("returning game settings with word: \(correctWord.word)")
    return GameSettings(score: 0, correctWord: correctWord, enteredWord: "", allWords: words, allValidWords: words, wordLocation: [correctWord.word], colourIndices: (0, 26, 500), enteredLetters: enteredLetters, gameEnded: false, gameState: .game)
}

enum EnteredWordState {
    case correct
    case newTopBoundary
    case newBottomBoundary
    case invalidWord
    case invalidOutsideBoundaries
    case activeEntering
}








