//
//  Player+CoreDataProperties.swift
//  dictio
//
//  Created by Fiona Kate Morgan on 22/02/2023.
//
//

import Foundation
import CoreData


extension Player {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Player> {
        return NSFetchRequest<Player>(entityName: "Player")
    }

    @NSManaged public var coins: Int16
    @NSManaged public var lastLogin: Date?

}

extension Player : Identifiable {

}
