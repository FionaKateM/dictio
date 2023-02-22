//
//  CoinsView.swift
//  dictio
//
//  Created by Fiona Kate Morgan on 16/02/2023.
//

import SwiftUI

struct CoinsView: View {
    @EnvironmentObject var sessionSettings: SessionSettings
    
    var body: some View {
        VStack {
            Text("Coins View")
            HStack {
                Button("Add Coins") {
                    sessionSettings.increaseCoinsBy(amount: 1)
                }
                .padding()
                Button("Subtract coins") {
                    sessionSettings.increaseCoinsBy(amount: -1)
                }
                .padding()
            }
            .padding()
            Button("Go back home") {
                sessionSettings.appState = .home
            }
        }
    }
}


