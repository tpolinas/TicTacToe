//
//  GameState.swift
//  TicTacToe
//
//  Created by Polina Tikhomirova on 01.06.2022.
//

import Foundation

protocol GameState {
    
    var isCompleted: Bool { get }
    
    func begin()
    func addMark(at position: GameboardPosition)
    func addAIMark()
}
