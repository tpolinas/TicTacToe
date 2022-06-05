//
//  GameEndedState.swift
//  TicTacToe
//
//  Created by Polina Tikhomirova on 01.06.2022.
//

import Foundation

class gameEndedState: GameState {
    
    // MARK: - Properties
    
    let isCompleted: Bool = false
    let winner: Player?
    weak var gameViewController: GameViewController?
    
    // MARK: - Init
    
    init(
        winner: Player?,
        gameViewController: GameViewController
    ) {
        self.winner = winner
        self.gameViewController = gameViewController
    }
    
    // MARK: - Functions
    
    func begin() {
        guard let gameViewController = gameViewController else { return }
        if let winner = winner {
            switch winner {
            case .first:
                gameViewController.infoLabel.text = "\(Game.shared.playerOneName.uppercased()) WON!"
                gameViewController.playerOneScore += 1
            case .second:
                gameViewController.infoLabel.text = "\(Game.shared.playerTwoName.uppercased()) WON!"
                gameViewController.playerTwoScore += 1
            case .computer:
                gameViewController.infoLabel.text = "COMPUTER WON!"
                gameViewController.playerTwoScore += 1
            }
        } else {
            gameViewController.infoLabel.text = "It's a draw!"
        }
        
        guard gameViewController.playerOneScore < 5 && gameViewController.playerTwoScore < 5 else { return gameViewController.matchWon() }
        gameViewController.playerToStart = gameViewController.playerToStart.next
        gameViewController.nextRoundButton.isEnabled = true
    }
    
    func addMark(at position: GameboardPosition) { }
    
    func addAIMark() { }
}

