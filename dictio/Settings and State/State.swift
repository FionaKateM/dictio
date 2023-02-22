//
//  State.swift
//  dictio
//
//  Created by Fiona Kate Morgan on 14/02/2023.
//

import Foundation

enum SessionState {
    case home
    case game
    case stats
    case profile
    case coins
    case temp
}

enum GameState {
    case game
    case ended
}

enum EnteredWordState {
    case correct
    case newTopBoundary
    case newBottomBoundary
    case invalidWord
    case invalidOutsideBoundaries
    case activeEntering
}

