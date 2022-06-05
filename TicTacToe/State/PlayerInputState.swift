//
//  PlayerInputState.swift
//  TicTacToe
//
//  Created by Polina Tikhomirova on 01.06.2022.
//

import Foundation

class PlayerInputState: GameState {
    
    // MARK: - Properties
    
    var isCompleted: Bool = false
    var player: Player
    let markViewPrototype: MarkView
    var gameViewController: GameViewController?
    weak var gameboard: Gameboard?
    weak var gameboardView: GameboardView?
    lazy var referee = gameViewController?.referee
    
    // MARK: - Init
    
    init(
        player: Player,
        gameViewController: GameViewController,
        gameboard: Gameboard,
        gameboardView: GameboardView,
        markViewPrototype: MarkView
    ) {
        self.player = player
        self.gameViewController = gameViewController
        self.gameboard = gameboard
        self.gameboardView = gameboardView
        self.markViewPrototype = markViewPrototype
    }
    
    // MARK: - Functions
    
    func begin() {
        switch player {
        case .first:
            gameViewController?
                .infoLabel
                .text = "\(Game.shared.playerOneName.uppercased()), it's your turn!"
        case .second:
            gameViewController?
                .infoLabel
                .text = "\(Game.shared.playerTwoName.uppercased()), it's your turn!"
        case .computer:
            gameViewController?
                .infoLabel
                .text = "COMPUTER's turn!"
        }
    }
    
    func addMark(at position: GameboardPosition) {
        guard
            let gameboardView = gameboardView,
            let gameboard = gameboard
        else { return }
        if Game.shared.stepMode == .fivePerMove {
            guard
                !gameboardView.temporaryMarksPositions.contains(position)
            else { return }
            let command = StepCommand(
                position: position,
                player: player,
                gameboard: gameboard,
                gameboardView: gameboardView,
                markViewPrototype: markViewPrototype
            )
            
            gameboardView.removeMarkView(at: position)
            gameboardView.placeMarkView(
                            markViewPrototype.copy(),
                            at: position)
            gameboardView.temporaryMarksPositions.append(position)
            gameViewController?.stepInvoker?.addCommand(command)
        
        } else {
            guard
                gameboardView.canPlaceMarkView(at: position)
            else { return }
            gameboard.setPlayer(
                        player,
                        at: position)
            gameboardView.placeMarkView(
                            markViewPrototype.copy(),
                            at: position)
        }
        
        if let commandsCount = gameViewController?
                                .stepInvoker?
                                .commands
                                    .count {
            if commandsCount % 5 == 0 {
                isCompleted = true
            }
        }
    }
    
    func addAIMark() {
        guard
            let gameboard = gameboard,
            let gameboardView = gameboardView,
            let referee = referee
        else { return }
  
        var positionOfNextMove: GameboardPosition?
        var numberOfMarksToWin: Int {
            return Game.shared.fieldSize == 3 ? 3 : 4
        }

        let position = GameboardPosition(
            column: (GameboardSize.columns - 1) / 2,
            row: (GameboardSize.columns - 1) / 2)
        if !gameboard.containsAtExactPosition(
            player: .computer,
            at: position) {
            if gameboardView.canPlaceMarkView(at: position) {
                print("i'm gonna place mark in the middle")
                addMark(at: position)
                return
            }
        }

        let winningCombinations = referee.winningCombinations
        
        var optimalCombinations: [Int : [[GameboardPosition]]] = [ : ]
        for number in 0..<numberOfMarksToWin {
            optimalCombinations[number] = []
        }
        for combination in winningCombinations {
            let number = gameboard.howManyTimesContains(
                                        player: .computer,
                                        at: combination)
            guard optimalCombinations[number] != nil else {
                return optimalCombinations[number] = [combination]
            }
            optimalCombinations[number]!.append(combination)
        }
        
        if optimalCombinations[numberOfMarksToWin - 1] != [] {
            print("there might be a chance to win")
            for combination in optimalCombinations[numberOfMarksToWin - 1]! {
                for position in combination {
                    if !gameboard.containsAtExactPosition(
                        player: .computer,
                        at: position) {
                        if gameboardView.canPlaceMarkView(at: position) {
                            print("i'm gonna place mark here: \(position), to complete this combination: \(combination)")
                            addMark(at: position)
                            return
                        }
                    }
                }
            }
        }
        
        var opponentsCombinations: [Int : [[GameboardPosition]]] = [:]
        for number in 0..<numberOfMarksToWin {
            opponentsCombinations[number] = []
        }
        for combination in winningCombinations {
            let number = gameboard.howManyTimesContains(
                                        player: .first,
                                        at: combination)
            guard opponentsCombinations[number] != nil else {
                return opponentsCombinations[number] = [combination]
            }
            opponentsCombinations[number]!.append(combination)
        }
        
        switch numberOfMarksToWin {
        case 4:
            var options: [GameboardPosition] = []
            var availablePositionIndexes: [Int] = []
            
            if opponentsCombinations[3] != [] {
                print("there might be a chance to block")
                
                for combination in opponentsCombinations[3]! {
                    for position in combination {
                        if !gameboard.containsAtExactPosition(
                                            player: .first,
                                            at: position) {
                            if gameboardView.canPlaceMarkView(
                                                at: position) {
                                addMark(at: position)
                                return
                            }
                        }
                    }
                }
                if let position = positionOfNextMove {
                    addMark(at: position)
                }
            }
            
            if optimalCombinations[2] != [] {
                print("there might be a chance to improve")
                for combination in optimalCombinations[2]! {
                    for position in combination {
                        if !gameboard.containsAtExactPosition(
                                            player: .computer,
                                            at: position) {
                            if gameboardView.canPlaceMarkView(
                                                at: position) {
                                options.append(position)
                                if let index = combination.firstIndex(
                                    of: position) {
                                    availablePositionIndexes
                                                .append(index)
                                }
                            }
                        }
                    }

                    if options.count == 2 {
                        print("improving")
                        print(options)
                        print(availablePositionIndexes)
                        switch availablePositionIndexes {
                        case [0,1]:
                            addMark(at: options[1])
                            return
                        case [0,2]:
                            addMark(at: options[1])
                            return
                        case [0,3]:
                            addMark(at: options[0])
                            return
                        case [1,2]:
                            addMark(at: options[1])
                            return
                        case [1,3]:
                            addMark(at: options[1])
                            return
                        case [2,3]:
                            addMark(at: options[0])
                            return
                        default: return
                        }
                    } else {
                        options = []
                        availablePositionIndexes = []
                    }
                }
            }
            
            if opponentsCombinations[2] != [] {
                print("there might be a chance to block")
                
                for combination in opponentsCombinations[2]! {
                    for position in combination {
                        if !gameboard.containsAtExactPosition(
                                                player: .first,
                                                at: position) {
                            if gameboardView.canPlaceMarkView(
                                                at: position) {
                                options.append(position)
                                if let index = combination
                                            .firstIndex(of: position) {
                                    availablePositionIndexes
                                            .append(index)
                                }
                            }
                        }
                    }
                    
                    if options.count == 2 {
                        print("trying to block")
                        print(options)
                        print(availablePositionIndexes)
                        switch availablePositionIndexes {
                        case [0,1]:
                            addMark(at: options[1])
                            return
                        case [0,2]:
                            addMark(at: options[1])
                            return
                        case [0,3]:
                            addMark(at: options[0])
                            return
                        case [1,2]:
                            addMark(at: options[1])
                            return
                        case [1,3]:
                            addMark(at: options[1])
                            return
                        case [2,3]:
                            addMark(at: options[0])
                            return
                        default: return
                        }
                    } else {
                        options = []
                        availablePositionIndexes = []
                    }
                }
            }
        case 3:
            var options: [GameboardPosition] = []
            if opponentsCombinations[2] != [] {
                print("there might be a chance to block")
                
                for combination in opponentsCombinations[2]! {
                    for position in combination {
                        if !gameboard.containsAtExactPosition(
                                                player: .first,
                                                at: position) {
                            if gameboardView.canPlaceMarkView(
                                                at: position) {
                                options.append(position)
                            }
                        }
                    }
                    if options.count > 1 {
                        positionOfNextMove = options[1]
                    } else if options.count > 0 {
                        positionOfNextMove = options[0]
                    }
                }
                if let position = positionOfNextMove {
                    addMark(at: position)
                    return
                }
            }
        default: return
        }
        
        addAIMarkRandomly()
    }
    
    func addAIMarkRandomly() {
        while !isCompleted {
            let column = Int.random(in: 0 ..< GameboardSize.columns)
            let row = Int.random(in: 0 ..< GameboardSize.rows)
            let position = GameboardPosition(
                                column: column,
                                row: row)
            addMark(at: position)
        }
    }
}

