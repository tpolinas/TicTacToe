//
//  SettingsView.swift
//  TicTacToe
//
//  Created by Polina Tikhomirova on 01.06.2022.
//

import UIKit

class SettingsView: UIView,
                    SettingsViewDelegate {
    
    weak var delegate: SettingsViewDelegate?
    
    // MARK: - Interface Builder
    
    @IBOutlet var contentView: UIView!
    @IBOutlet var playerOneNameTextField: UITextField!
    @IBOutlet var playerTwoNameTextField: UITextField!
    @IBOutlet var fieldSizeSegmentedControl: UISegmentedControl!
    @IBOutlet var markPlacementModeSegmentedControl: UISegmentedControl!
    @IBAction func playButtonPressed(_ sender: UIButton) {
        goToGame()
    }
    @IBAction func backButtonPressed(_ sender: UIButton) {
        playerOneNameTextField.text = nil
        playerTwoNameTextField.text = nil
        playerTwoNameTextField.isEnabled = false
        self.isHidden = true
    }
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    // MARK: - Functions
    
    private func commonInit() {
        Bundle.main.loadNibNamed(
                        "SettingsView",
                        owner: self,
                        options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [
            .flexibleWidth,
            .flexibleHeight
        ]
    }
    
    func goToGame() {
        delegate?.goToGame()
    }
}
