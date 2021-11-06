//
//  DatabaseCollectionViewCell.swift
//  Autoschool
//
//  Created by Max Sashcheka on 11/6/21.
//

import UIKit

class DatabaseCollectionViewCell: UICollectionViewCell {

    static let reuseIdentifier = "DatabaseCollectionViewCell"
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        imageView.tintColor = .black
        backgroundColor = .white
        
        layer.masksToBounds = false
        layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.35).cgColor
        layer.shadowRadius = 3.0
        layer.shadowOpacity = 1.0
        layer.shadowOffset = .zero
        layer.cornerRadius = 20
    }
    
    
    static func nib() -> UINib {
        return UINib(nibName: reuseIdentifier, bundle: nil)
    }
    
    func setup(withRepresentator representator: ViewControllerRepresentation) {
        titleLabel.text = representator.name
        imageView.image = representator.image
    }

}
