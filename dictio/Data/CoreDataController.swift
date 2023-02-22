//
//  CoreDataController.swift
//  dictio
//
//  Created by Fiona Kate Morgan on 16/02/2023.
//

import Foundation
import CoreData

class DataController: ObservableObject {
    let container = NSPersistentContainer(name: "PlayerData")
    
    init() {
        container.loadPersistentStores { description, error in
            if let error = error {
                print("Core Data failed to load: \(error.localizedDescription)")
            }
        }
    }
}

func turnArrayIntoOrderedSet(array: [String]) -> NSOrderedSet {

    return NSOrderedSet(array: array)
}

