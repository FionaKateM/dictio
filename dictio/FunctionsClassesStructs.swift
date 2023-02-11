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
    
    return word
}

func resetEnteredLetters() -> [String] {
    
    return ["", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", ""]
}

//struct TextFieldView: View {
//
//    // Constants, so all "TextFields will be the same in the app"
//    let fontSize: CGFloat
//    let backgroundColor: Color
//    let textColor: Color
//
//    // The @State Object
//    @Binding var field: String
//
//    // A custom variable for a "TextField"
//    @Binding var isHighlighted: Bool
//
//    init(field: Binding<String>, isHighlighted: Binding<Bool>, fontSize: CGFloat = 14, backgroundColor: Color = .blue, textColor:Color = .white) {
//        self._field = field
//        self._isHighlighted = isHighlighted
//        self.fontSize = fontSize
//        self.backgroundColor = backgroundColor
//        self.textColor = textColor
//    }
//
//    var body: some View {
//        TextField(field, text: $field)
//            .font(Font.system(size: fontSize))
//            .padding()
//            .background(RoundedRectangle(cornerRadius: 10).fill(backgroundColor))
//            .foregroundColor(textColor)
//            .padding()
//    }
//}
