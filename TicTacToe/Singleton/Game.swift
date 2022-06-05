//
//  Game.swift
//  TicTacToe
//
//  Created by Polina Tikhomirova on 01.06.2022.
//

import Foundation

class Game {
    
    // MARK: - Singletone
    
    static let shared = Game()
    
    // MARK: - Properties
    
    var mode: Mode = .twoPlayers
    var stepMode: StepMode = .onePerMove
    var fieldSize: Int = 3 {
        didSet {
            GameboardSize.columns = fieldSize
            GameboardSize.rows = fieldSize
        }
    }
    
    var playerOneName: String = "PLAYER #1"
    var playerTwoName: String = "PLAYER #2"
    
    // MARK: - Init
    
    private init() { }
    
    // MARK: - Fubctions
    
    func description() -> String {
        return "fieldSize: \(fieldSize), mode: \(mode), stepMode: \(stepMode), players: \(playerOneName), \(playerTwoName)"
    }
}
