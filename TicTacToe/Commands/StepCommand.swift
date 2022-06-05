//
//  StepCommand.swift
//  TicTacToe
//
//  Created by Polina Tikhomirova on 01.06.2022.
//

import Foundation

// MARK: - Protocols

protocol Command: AnyObject {
    func execute(delay: Double)
}

class StepCommand: Command {
    
    // MARK: - Private properties
    
    private var player: Player
    private var position: GameboardPosition
    private var markViewPrototype: MarkView
    private var referee: Referee?
    private(set) weak var gameboard: Gameboard?
    private(set) weak var gameboardView: GameboardView?
    
    // MARK: - Init
    
    init(
        position: GameboardPosition,
        player: Player,
        gameboard: Gameboard,
        gameboardView: GameboardView,
        markViewPrototype: MarkView
    ) {
        self.position = position
        self.player = player
        self.gameboard = gameboard
        self.gameboardView = gameboardView
        self.markViewPrototype = markViewPrototype
        self.referee = Referee(gameboard: gameboard)
    }
    
    // MARK: - Functions
    
    func execute(delay: Double) {
        guard
            let gameboardView = gameboardView,
            let gameboard = gameboard
        else { return }
        if !gameboard.containsAnything(at: position) {
            gameboard.setPlayer(self.player, at: self.position)
            DispatchQueue.main.asyncAfter(deadline: .now() + delay ) {
                gameboardView.placeMarkView(
                                self.markViewPrototype.copy(),
                                at: self.position)
            }
        } else {
            gameboard.setPlayer(self.player, at: self.position)
            DispatchQueue.main.asyncAfter(deadline: .now() + delay ) {
                gameboardView.removeMarkView(at: self.position)
                gameboardView.placeMarkView(
                                self.markViewPrototype.copy(),
                                at: self.position)
            }
        }
    }
}

