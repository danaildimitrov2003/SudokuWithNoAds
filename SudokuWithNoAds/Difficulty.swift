//
//  Difficulty.swift
//  SudokuWithNoAds
//
//  Created by Danail Dimitrov on 26.12.25.
//


import Foundation

enum Difficulty: String, CaseIterable, Identifiable {
    case easy = "Easy"
    case normal = "Normal"
    case hard = "Hard"
    case extreme = "Extreme"
    case impossible = "Impossible"
    case youCannotDoThis = "You cannot do this"

    var id: String { self.rawValue }

    var cellsToRemove: Int {
        switch self {
        case .easy: return 30
        case .normal: return 40
        case .hard: return 50
        case .extreme: return 55
        case .impossible: return 60
        case .youCannotDoThis: return 70
        }
    }

    var scoreMultiplier: Int {
        switch self {
        case .easy: return 1
        case .normal: return 2
        case .hard: return 3
        case .extreme: return 4
        case .impossible: return 5
        case .youCannotDoThis: return 8
        }
    }
}

