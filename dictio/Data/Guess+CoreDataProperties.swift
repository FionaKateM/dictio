//
//  Guess+CoreDataProperties.swift
//  dictio
//
//  Created by Fiona Kate Morgan on 16/02/2023.
//
//

import Foundation
import CoreData


extension Guess {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Guess> {
        return NSFetchRequest<Guess>(entityName: "Guess")
    }

    @NSManaged public var guess: String?
    @NSManaged public var game: Game?
    
    public var unwrappedGuess: String {
        guess ?? ""
    }

}

extension Guess : Identifiable {

}
