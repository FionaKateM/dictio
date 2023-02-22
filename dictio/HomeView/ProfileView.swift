//
//  ProfileView.swift
//  dictio
//
//  Created by Fiona Kate Morgan on 14/02/2023.
//

import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var sessionSettings: SessionSettings
    
    var body: some View {
        VStack {
            Text("Profile View")
            Button("Go back home") {
                sessionSettings.appState = .home
            }
        }
    }
}

