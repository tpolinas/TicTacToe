//
//  MarkView.swift
//  TicTacToe
//
//  Created by Polina Tikhomirova on 01.06.2022.
//

import UIKit

// MARK: - Protocols

protocol Copying {
    init(_ prototype: Self)
}

// MARK: - Exstensions

extension Copying {
    func copy() -> Self {
        return type(of: self).init(self)
    }
}

public class MarkView: UIView, Copying {

    // MARK: - Init
    
    public init() {
        super.init(
            frame: CGRect(
                origin: .zero,
                size: CGSize(
                    width: 90,
                    height: 90)))
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    public required init(_ prototype: MarkView) {
        super.init(frame: prototype.frame)
    }
    
    // MARK: - UIView
    
    public final override func layoutSubviews() {
        super.layoutSubviews()
        updateMark()
    }
    
    // MARK: - Template methods
    
    internal func updateMark() { }
}

