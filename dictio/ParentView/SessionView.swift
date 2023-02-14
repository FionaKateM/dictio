//
//  SessionView.swift
//  dictio
//
//  Created by Fiona Kate Morgan on 14/02/2023.
//

import SwiftUI

// Session View is the main view controlling between active game, home, profile and data screens
// Session View contains the session variables
// Session settings are loaded by Initialisation View and passed through in the transition

struct SessionView: View {
    
    @StateObject var sessionSettings: SessionSettings
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var body: some View {
        NavigationView {
            switch sessionSettings.appState {
            case .home:
                HomeView()
            case .game:
                if let gameSettings = sessionSettings.gameSettings {
                    GameView(settings: gameSettings)
                } else {
                    Text("game view cannot load")
                }
            case .stats:
                Text("stats")
            case .profile:
                Text("profile")
            }
        }
        .environmentObject(sessionSettings)
    }
}


