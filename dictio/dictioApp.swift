//
//  dictioApp.swift
//  dictio
//
//  Created by Fiona Kate Morgan on 11/02/2023.
//

import SwiftUI
import GameKit

@main
struct dictioApp: App {
    @StateObject private var dataController = DataController()

    var body: some Scene {
        WindowGroup {
            InitialisationView()
                .environment(\.managedObjectContext, dataController.container.viewContext)
        }
    }
}





