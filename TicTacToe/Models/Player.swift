//
//  Player.swift
//  TicTacToe
//
//  Created by Polina Tikhomirova on 01.06.2022.
//

import Foundation

public enum Player: CaseIterable {
    case first
    case second
    case computer
    
    var next: Player {
        if Game.shared.mode == .twoPlayers {
            switch self {
            case .first: return .second
            case .second: return .first
            default: return .first
            }
        }
        if Game.shared.mode == .vsComputer {
            switch self {
            case .first: return .computer
            case .computer: return .first
            default: return .first
            }
        }
        return .first
    }
    
    var markViewPrototype: MarkView {
        switch self {
        case .first:
            return XView()
        case .second, .computer:
            return OView()
        }
    }
}
