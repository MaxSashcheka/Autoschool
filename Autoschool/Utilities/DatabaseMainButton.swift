//
//  HeaderViewButton.swift
//  Contacts
//
//  Created by Max Sashcheka on 9/17/21.
//

import UIKit

class DatabaseMainButton: UIButton {
    
    init() {
        super.init(frame: .zero)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    func setup() {
        setTitleColor(.lightGreenSea, for: .normal)
        backgroundColor = .white
        layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.30).cgColor
        layer.shadowRadius = 5
        layer.shadowOpacity = 1.0
        layer.shadowOffset = .zero
        layer.cornerRadius = layer.frame.height / 2
    
    }
    
    override var isHighlighted: Bool {
        didSet {
            UIView.transition(with: self, duration: 0.2, options: [.transitionCrossDissolve]) { [self] in
                if isHighlighted {
                    layer.shadowRadius = 4.0
                    layer.shadowColor = UIColor.lightGreenSea.cgColor
                } else {
                    layer.shadowRadius = 3.0
                    layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
                }
            }
        }
    }
    
}
