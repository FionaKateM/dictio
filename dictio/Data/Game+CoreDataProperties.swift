//
//  Game+CoreDataProperties.swift
//  dictio
//
//  Created by Fiona Kate Morgan on 16/02/2023.
//
//

import Foundation
import CoreData


extension Game {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Game> {
        return NSFetchRequest<Game>(entityName: "Game")
    }

    @NSManaged public var correctWord: String?
    @NSManaged public var started: Date?
    @NSManaged public var ended: Date?
    @NSManaged public var dailyGameID: Int16
    @NSManaged public var guesses: NSOrderedSet?
    
    public var unwrappedCorrectWord: String {
        correctWord ?? ""
    }
    
    public var unwrappedStarted: Date {
        started ?? Date.now
    }
    
    public var unwrappedEnded: Date {
        ended ?? Date.now
    }
    
    public var guessArray: [Guess] {
        // turns the ordered set into an array
        let set = guesses?.array as? [Guess] ?? []
        return set
    }

}

// MARK: Generated accessors for guesses
extension Game {

    @objc(addGuessesObject:)
    @NSManaged public func addToGuesses(_ value: Guess)

    @objc(removeGuessesObject:)
    @NSManaged public func removeFromGuesses(_ value: Guess)

    @objc(addGuesses:)
    @NSManaged public func addToGuesses(_ values: NSSet)

    @objc(removeGuesses:)
    @NSManaged public func removeFromGuesses(_ values: NSSet)

}

extension Game : Identifiable {

}
