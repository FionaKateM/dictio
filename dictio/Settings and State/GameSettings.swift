//
//  GameSettings.swift
//  dictio
//
//  Created by Fiona Kate Morgan on 14/02/2023.
//

import Foundation
import SwiftUI
import GameKit

class GameSettings: ObservableObject {
    @Published var score = 0
    @Published var correctWord: Word = Word(word: "", definition: "")
    @Published var enteredWord = ""
    @Published var dailyID: Int?
    
    // dictionary of accepted words
    @Published var allWords: [String] = []
    
    // starts the same as the dictionary but removes words outside boundaries
    @Published var allValidWords: [String] = []
    
    // all guessed words
    @Published var allGuessedWords: [String] = []
    
    @Published var visualisedWords: [String] = ["a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z"]
    @Published var wordLocation: [String] = []
    @Published var colourIndices = (0, 26, 500)
    @Published var enteredLetters: [String]
//    @Published var gameEnded = false
    @Published var enteredWordState: EnteredWordState = .activeEntering
    @Published var wordBoundaries: (String, String) = ("","")
    @Published var gameState: GameState
    
    // timestamps
    @Published var started: Date
    
    init(score: Int = 0, correctWord: Word, enteredWord: String = "", allWords: [String], allValidWords: [String], wordLocation: [String], colourIndices: (Int, Int, Int) = (0, 26, 500), enteredLetters: [String], gameState: GameState, started: Date) {
        self.score = 0
        self.correctWord = correctWord
        self.enteredWord = enteredWord
        self.allWords = allWords
        self.allValidWords = allValidWords
        self.wordLocation = wordLocation
        self.colourIndices = colourIndices
        self.enteredLetters = enteredLetters
        self.gameState = gameState
        self.started = started
    }
}
