//
//  FunctionsClassesStructs.swift
//  dictio
//
//  Created by Fiona Kate Morgan on 11/02/2023.
//

import Foundation
import SwiftUI
import GameKit

struct Word : Codable {
    var word: String
    var definition: String
    var id: Int?
    var date: String?
}

struct Words : Codable {
    var words: [Word]
}

struct DataWords : Codable {
    var words: [String: Word]
}

func getDailyWord(date: String) async -> Word? {
    
    // TODO - fix the date issue
    // Currently saving daily words with date MM/DD/YYYY as string, but using date.now to get it doesn't work because of different default date settings
    if let wordsURL = Bundle.main.url(forResource: "daily-words", withExtension: "json") {
        if let data = try? Data(contentsOf: wordsURL) {
            if let words = parseWordsFrom(json: data) {
                let dailyWordArray = words.filter({ $0.date == date})
                if dailyWordArray.count > 0 {
                    return dailyWordArray[0]
                } else {
                    return nil
                }
            } else {
                return nil
            }
        } else {
            return nil
        }
    } else {
        return nil
    }
}

func parseWordsFrom(json: Data) -> [Word]? {
    let decoder = JSONDecoder()
    
    if let words = try? decoder.decode([Word].self, from: json) {
        return words
    } else {
        print("parse didn't work")
        return nil
    }
}

func getWords(fileName: String) -> [Word] {
    var words: [Word] = []
    if let wordsURL = Bundle.main.url(forResource: fileName, withExtension: "json") {
        if let data = try? Data(contentsOf: wordsURL) {
            if let parsedWords = parseWordsFrom(json: data) {
                words = parsedWords
            }
        }
    }
    return words
}

func parseStrings(json: Data) -> JSON? {
    if let parsed = try? JSON(data: json) {
        return parsed
    }
    return nil
}

// gets all words of a specific length that will be accepted in the game
func getWordsOf(length: Int) -> [String] {
    var allWords: [String] = []
    
    if let wordsURL = Bundle.main.url(forResource: "\(length)-letter-words", withExtension: "json") {
        if let data = try? Data(contentsOf: wordsURL) {
            if let json = parseStrings(json: data) {
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

func getPracticeWord() -> Word {
    let words = getWords(fileName: "correct-words")
    if let random = words.randomElement() {
        
        // TODO: check not previously played
        
        return random
    } else {
        print("couldn't get random word")
        return Word(word: "axis", definition: "xxx")
    }
}

func initialiseGame(date: String?) async -> GameSettings {
    var correctWord: Word = Word(word: "", definition: "")
    
    //*** Word selection ***
    
    // if it is a daily game
    if let dateID = date {
        print("getting daily word")
        // TODO: add check that they have not already played the daily game
        if let word = await getDailyWord(date: dateID) {
            print("correct word is: \(word)")
            correctWord = word
        }
        
    } else {
        // not a daily game
        correctWord = getPracticeWord()
    }
    
    
    //*** Game initialisation ***
    
    // gets all accepted words the same length as correct word
    let words = getWordsOf(length: correctWord.word.count)
    
    // sets the number of entered letters to the number of letters in the correct word
    var enteredLetters: [String] = []
    for _ in 0..<correctWord.word.count {
        enteredLetters.append("")
    }
    
    // prints the correct word for easy testing
    print("returning game settings with word: \(correctWord.word)")
    
    // initialises the gameSettings struct
    let gameSettings = GameSettings(score: 0, correctWord: correctWord, enteredWord: "", allWords: words, allValidWords: words, wordLocation: [correctWord.word], colourIndices: (0, 26, 500), enteredLetters: enteredLetters, gameState: .game, started: Date.now)
    
    return gameSettings
}

func formatDate(_ date: Date) -> String {
    let formattedDate = date.formatted(
        Date.FormatStyle()
            .locale(Locale(identifier: "en_US"))
            .month(.defaultDigits)
            .day(.defaultDigits)
            .year()
    )
    return formattedDate
}



