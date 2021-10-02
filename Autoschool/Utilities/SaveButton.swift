//
//  SaveButton.swift
//  Autoschool
//
//  Created by Max Sashcheka on 10/1/21.
//

import UIKit

class SaveButton: UIButton {
    
    init() {
        super.init(frame: .zero)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    func setup() {
        setTitleColor(.systemTeal, for: .normal)
        backgroundColor = .white
        layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.30).cgColor
        layer.shadowRadius = 2.5
        layer.shadowOpacity = 1.0
        layer.shadowOffset = .zero
        layer.cornerRadius = layer.frame.height / 2
    
    }
    
    override var isHighlighted: Bool {
        didSet {
            UIView.transition(with: self, duration: 0.2, options: [.transitionCrossDissolve]) { [self] in
                if isHighlighted {
                    layer.shadowRadius = 4
                    layer.shadowColor = UIColor.systemTeal.cgColor
                } else {
                    layer.shadowRadius = 2.5
                    layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.30).cgColor
                }
            }
        }
    }
    
}
