//
//  OView.swift
//  TicTacToe
//
//  Created by Polina Tikhomirova on 01.06.2022.
//

import UIKit

public class OView: MarkView {
    
    internal override func updateMark() {
        super.updateMark()
        let imageView = UIImageView(
            frame: CGRect(
                x: bounds.width * 0.1,
                y: bounds.height * 0.1,
                width: bounds.width * 0.8,
                height: bounds.height * 0.8))
        imageView.image = UIImage(systemName: "circle")
        addSubview(imageView)
    }
}

