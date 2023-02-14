//
//  LoadingView.swift
//  dictio
//
//  Created by Fiona Kate Morgan on 13/02/2023.
//

import SwiftUI
import GameKit

// Initialisation View is the loading screen presented on opening the app
// This authenticates the player with GameKit and if they are not already logged in, asks them to do so
// No information, other than a loading animation and a button to log into Game Center, will be on this screen

struct InitialisationView: View {
    @State var localPlayer = GKLocalPlayer.local
    @State var playerAuthenticated = false
    
    var body: some View {
        if !playerAuthenticated {
            Text("Loading your Game Center profile")
                .onAppear() {
                    Task {
                        authenticateUser()
                    }
                }
        } else {
            SessionView(sessionSettings: SessionSettings(appState: .home, player: localPlayer, gameSettings: nil))
        }
    }
    
    func authenticateUser() {
        localPlayer.authenticateHandler = { vc, error in
            guard error == nil else {
                print(error?.localizedDescription ?? "")
                return
            }
            GKAccessPoint.shared.isActive = localPlayer.isAuthenticated
            playerAuthenticated = true
        }
    }
    
}

