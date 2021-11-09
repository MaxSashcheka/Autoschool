//
//  NavigationCollectionViewCell.swift
//  Autoschool
//
//  Created by Max Sashcheka on 11/8/21.
//

import UIKit

class NavigationCollectionViewCell: UICollectionViewCell {
    
    static let reuseIdentifier = "NavigationCollectionViewCell"
    
    static func nib() -> UINib {
        return UINib(nibName: reuseIdentifier, bundle: nil)
    }

    @IBOutlet weak var navigationTitleLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = .white
        layer.masksToBounds = false
        layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.4).cgColor
        layer.shadowRadius = 2
        layer.shadowOpacity = 1.0
        layer.shadowOffset = .zero
        layer.cornerRadius = 15
    }
    
    func setup(withTitle title: String) {
        navigationTitleLabel.text = title
        if navigationTitleLabel.text == "Автошкола" {
            navigationTitleLabel.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        }
    }
    
    func setup(withGroup group: Group) {
        navigationTitleLabel.text = group.name
    }

}
