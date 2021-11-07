//
//  TypePickerCollectionTableViewCell.swift
//  Autoschool
//
//  Created by Max Sashcheka on 11/8/21.
//

import UIKit

class TypePickerCollectionTableViewCell: UITableViewCell {

    static let reuseIdentifier = "TypePickerCollectionTableViewCell"
    
    static func nib() -> UINib {
        return UINib(nibName: reuseIdentifier, bundle: nil)
    }
    
    @IBOutlet weak var typePickerCollectionVIew: UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = .clear
    }

    
    
}
