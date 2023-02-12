//
//  DailyWordsArrage.swift
//  dictio
//
//  Created by Fiona Kate Morgan on 12/02/2023.
//

import SwiftUI

struct DailyWordsArrage: View {
    
    @State var words: [Word] = []
    @State var wordArray: [String] = []
    @State var shuffledWords: [String: String] = [:]
    
    var body: some View {
        
        Text("Daily words stuff")
        Button("Print shuffled words") {
            for word in words {
                wordArray.append(word.word)
                
            }
            
            wordArray.shuffle()
            print("wordArray: \(wordArray)")
            var date = Date.now
            for index in 0..<wordArray.count {
                shuffledWords["\(date.formatted(date: .numeric, time: .omitted))"] = wordArray[index]
                date = date.addingTimeInterval(86400)
            }
            print(shuffledWords)
        }
            .onAppear() {
                words = getDailyWords()
            }
    }
    
    func getDailyWords() -> [Word] {
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
}


