//
//  Gameboard.swift
//  TicTacToe
//
//  Created by Polina Tikhomirova on 01.06.2022.
//

import Foundation

public final class Gameboard {
    
    // MARK: - Lazy properties
    
    lazy var positions: [[Player?]] = initialPositions()
    
    // MARK: - Public functions
    
    func setPlayer(
        _ player: Player,
        at position: GameboardPosition
    ) {
        positions[position.column][position.row] = player
    }
    
    public func clear() {
        self.positions = initialPositions()
    }
    
    public func contains(
        player: Player,
        at positions: [GameboardPosition]
    ) -> Bool {
        var number = 0
        for position in positions {
            guard
                containsAtExactPosition(
                player: player,
                at: position)
            else { return false }
            number += 1
        }
        if GameboardSize.rows == 3 {
            return number == 3
        } else {
            return number > 3
        }
    }
    
    public func containsAnything(
        at position: GameboardPosition
    ) -> Bool {
        let (column, row) = (position.column, position.row)
        return positions[column][row] != nil
    }
    
    public func howManyTimesContains(
        player: Player,
        at positions: [GameboardPosition]
    ) -> Int {
        var number = 0
        for position in positions {
            if containsAtExactPosition(
                player: player,
                at: position) {
                number += 1
            }
        }
        return number
    }
    
    public func containsAtExactPosition(
        player: Player,
        at position: GameboardPosition
    ) -> Bool {
        let (column, row) = (position.column, position.row)
        return positions[column][row] == player
    }
    
    // MARK: - Private functions
    
    private func initialPositions() -> [[Player?]] {
        var positions: [[Player?]] = []
        for _ in 0 ..< GameboardSize.columns {
            let rows = Array<Player?>(repeating: nil, count: GameboardSize.rows)
            positions.append(rows)
        }
        return positions
    }
}
