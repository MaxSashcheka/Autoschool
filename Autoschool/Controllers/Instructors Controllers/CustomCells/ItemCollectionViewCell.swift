//
//  ItemCollectionViewCell.swift
//  Autoschool
//
//  Created by Max Sashcheka on 11/7/21.
//

import UIKit

class ItemCollectionViewCell: UICollectionViewCell {
    
    static let reuseIdentifier = "ItemCollectionViewCell"
    
    static func nib() -> UINib {
        return UINib(nibName: reuseIdentifier, bundle: nil)
    }
    
    @IBOutlet weak var itemImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        itemImageView.tintColor = .lightGreenSea
        
        layer.masksToBounds = false
        backgroundColor = .white
        layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.4).cgColor
        layer.shadowOffset = .zero
        layer.shadowRadius = 3.0
        layer.shadowOpacity = 1.0
        layer.cornerRadius = 15
        
    }
    
    func setup(withModel model: Model) {
        itemImageView.image = model.image
        titleLabel.text = model.title
    }
    

}
