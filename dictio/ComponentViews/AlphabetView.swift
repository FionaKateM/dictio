//
//  GameComponentViews.swift
//  dictio
//
//  Created by Fiona Kate Morgan on 11/02/2023.
//

import SwiftUI



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


