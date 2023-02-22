//
//  DailyWordsArrage.swift
//  dictio
//
//  Created by Fiona Kate Morgan on 12/02/2023.
//

import SwiftUI

struct DailyWordsArrange: View {
    
    @State var words: [Word] = []
    @State var wordArray: [String] = []
    @State var shuffledWords: [String: String] = [:]
    @State var tempWordsArray: [Word] = []
    
    var body: some View {
        VStack {
            
            Spacer()
            Button("Print daily words") {
                setDailyWords(startingDate: Date.now)
            }
            Spacer()
            Button("Get correct words") {
                getCorrectWords()
            }
        }
        .onAppear() {
            words = getDailyWords()
        }
    }
    
    func setDailyWords(startingDate: Date) {
        var date = startingDate
        var id = 1
        var words = getCorrectWords().shuffled()
        var tempArray: [Word] = []
        for word in words {
            var tempWord = word
            tempWord.id = id
            tempWord.date = "\(date.formatted(date: .numeric, time: .omitted))"
            tempArray.append(tempWord)
            
            // add 24 hours
            date = date.addingTimeInterval(86400)
            
            // increase ID
            id += 1
        }
        
        print(tempArray)
        
    }
    
    
    func getDailyWords() -> [Word] {
        var correctWords: [Word] = getCorrectWords()
        if let wordsURL = Bundle.main.url(forResource: "correct-words", withExtension: "json") {
            //        print("here 1")
            if let data = try? Data(contentsOf: wordsURL) {
                // we're OK to parse!
                //            print("here 2")
//                if let json = parse(json: data) {
//                    //                print("here 3")
//                    for item in json {
//                        let word = Word(word: "\(item.1["word"].rawValue)", definition: "\(item.1["definition"].rawValue)")
//                        //                    correctWords.append("\(item.1["word"].rawValue)")
//                        correctWords.append(word)
//                        //                    print(word)
//                    }
//                }
            }
        }
        
        return correctWords
        
    }
    
    func getCorrectWords() -> [Word] {
        var correctWords: [Word] = []
        if let wordsURL = Bundle.main.url(forResource: "correct-words", withExtension: "json") {
            if let data = try? Data(contentsOf: wordsURL) {
                let decoder = JSONDecoder()
                if let words = try? decoder.decode([Word].self, from: data) {
//                    print("words: \(words)")
                    return words
                }
            }
        }
        return correctWords
    }
}

