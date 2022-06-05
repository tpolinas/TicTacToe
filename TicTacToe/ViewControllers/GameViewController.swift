//
//  GameViewController.swift
//  TicTacToe
//
//  Created by Polina Tikhomirova on 01.06.2022.
//

import UIKit

final class GameViewController: UIViewController {
    
    // MARK: - Interface builder
    
    @IBOutlet var playerOneScoreLabel: UILabel!
    @IBOutlet var playerTwoScoreLabel: UILabel!
    @IBOutlet var infoLabel: UILabel!
    @IBOutlet var gameboardView: GameboardView!
    @IBOutlet var nextRoundButton: UIButton!
    @IBOutlet var playerTwoName: UILabel! {
        didSet {
            playerTwoName.text = Game.shared.playerTwoName.uppercased()
        }
    }
    @IBOutlet var playerOneName: UILabel! {
        didSet {
            playerOneName.text = Game.shared.playerOneName.uppercased()
        }
    }
    @IBAction func backToMainButtonPressed(_ sender: Any) {
        let alert = UIAlertController(
                        title: "Are you sure?",
                        message: "Do you really want to exit?",
                        preferredStyle: .alert)
        alert.addAction(
            UIAlertAction(
                title: "Yes!",
                style: .default,
                handler: exitToMainMenu))
        alert.addAction(
            UIAlertAction(
                title: "No!",
                style: .cancel,
                handler: nil))
        present(
            alert,
            animated: true)
    }
    @IBAction func restartMatchButtonPressed(_ sender: Any) {
        let alert = UIAlertController(
                        title: "Are you sure?",
                        message: "Do you really want to restart the whole game?",
                        preferredStyle: .alert)
        alert.addAction(
            UIAlertAction(
                title: "Yes!",
                style: .default,
                handler: restartTheMatch))
        alert.addAction(
            UIAlertAction(
                title: "No!",
                style: .cancel,
                handler: nil))
        present(
            alert,
            animated: true)
    }
    @IBAction func nextRoundButtonPressed(_ sender: Any) {
        setFirstPlayerStep()
        gameboardView.clear()
        gameboardView.boardBeforeMoves = [:]
        gameboard.clear()
        stepInvoker?.clear()
    }
    
    // MARK: - Properties
    
    var stepInvoker: StepInvoker?
    private let gameboard = Gameboard()
    lazy var referee = Referee(gameboard: gameboard)
    
    // MARK: - Init
    
    var currentState: GameState! {
        didSet {
            aiNeedsToThink()
        }
    }
    
    var playerOneScore = 0 {
        didSet {
            playerOneScoreLabel.text = "\(playerOneScore)"
        }
    }
    
    var playerTwoScore = 0 {
        didSet {
            playerTwoScoreLabel.text = "\(playerTwoScore)"
        }
    }
    
    var playerToStart: Player = .first
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        welcomeMessage()
        self.stepInvoker = StepInvoker(
                            source: self,
                            gameboard: gameboard)
        setFirstPlayerStep()
        setGameboardViewInitialState()
        gameboardView.boardBeforeMoves = gameboardView
                                            .markViewForPosition
    }
    
    // MARK: - Functions 
    
    public func matchWon() {
        let winner = playerOneScore == 5 ? playerOneName.text?.uppercased() : playerTwoName.text?.uppercased()
        let alert = UIAlertController(
                        title: "Game over!",
                        message: "The winner is: \(winner ?? "") \n Do you want to play one more time?",
                        preferredStyle: .alert)
        alert.addAction(
            UIAlertAction(
                title: "Yes!",
                style: .default,
                handler: restartTheMatch))
        alert.addAction(
            UIAlertAction(
                title: "No!",
                style: .default,
                handler: exitToMainMenu))
        present(
            alert,
            animated: true)
    }
    
    private func setGameboardViewInitialState() {
        switch playerToStart {
        case .first, .second:
            gameboardView.onSelectPosition = { [weak self] position in
                guard let self = self else { return }
                if let playerInputState = self.currentState as? PlayerInputState {
                    if playerInputState.player != .computer {
                        self.currentState.addMark(at: position)
                        if self.currentState.isCompleted {
                            self.goToNextState()
                        }
                    }
                }
            }
        case .computer: aiNeedsToThink()
        }
    }
    
    private func setFirstPlayerStep() {
        currentState = PlayerInputState(
            player: playerToStart,
            gameViewController: self,
            gameboard: gameboard,
            gameboardView: gameboardView,
            markViewPrototype: playerToStart.markViewPrototype
        )
        nextRoundButton.isEnabled = false
    }
    
    private func checkIfNoMoreMoves() -> Bool {
        var result = true
        gameboard.positions.forEach { column in
            if column.contains(nil) {
                result = false
            }
        }
        return result
    }
    
    private func goToNextState() {
        if let winner = referee.determineWinner() {
            currentState = gameEndedState(winner: winner, gameViewController: self)
            return
        }
        
        switch Game.shared.stepMode {
        case .onePerMove:
            guard !checkIfNoMoreMoves() else {
                return currentState = gameEndedState(
                                        winner: nil,
                                        gameViewController: self)
            }
            setPlayer()
        case .fivePerMove:
            guard let stepInvoker = stepInvoker else { return }
            if stepInvoker.commands.count % 5 == 0 { setPlayer() }
        }
    }
    
    private func aiMove() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
            if let playerInputState = self.currentState as? PlayerInputState {
                if playerInputState.player == .computer {
                    self.currentState.addAIMark()
                    if self.currentState.isCompleted {
                        self.goToNextState()
                    }
                }
            }
        })
    }
    
    private func aiNeedsToThink() {
        currentState.begin()
        switch Game.shared.stepMode {
        case .fivePerMove:
            guard let stepInvoker = stepInvoker else { return }

            let delay: Double = stepInvoker.commands.count < 6 ? 3 : 5
            DispatchQueue.main.asyncAfter(deadline: .now() + delay, execute: { [self] in
                for _ in 0..<5 { aiMove() }
            })
        case .onePerMove: aiMove()
        }
    }
    
    private func setPlayer() {
        if let playerInputState = currentState as? PlayerInputState {
            let player = playerInputState.player.next
            currentState = PlayerInputState(
                                player: player,
                                gameViewController: self,
                                gameboard: gameboard,
                                gameboardView: gameboardView,
                                markViewPrototype: player
                                                    .markViewPrototype)
        }
    }
    
    private func exitToMainMenu(action: UIAlertAction! = nil) {
        navigationController?.popViewController(animated: true)
    }
    
    private func welcomeMessage() {
        let alert = UIAlertController(
                        title: "Game is on!",
                        message: "First player gotta get 5 points to win the round. \n Good luck!",
                        preferredStyle: .alert)
        alert.addAction(
            UIAlertAction(
                title: "Got it!",
                style: .cancel,
                handler: nil))
        present(
            alert,
            animated: true)
    }
    
    private func restartTheMatch(action: UIAlertAction! = nil) {
        playerOneScore = 0
        playerTwoScore = 0
        playerToStart = .first
        setFirstPlayerStep()
        gameboardView.clear()
        gameboardView.boardBeforeMoves = [:]
        gameboard.clear()
        stepInvoker?.clear()
    }
}
