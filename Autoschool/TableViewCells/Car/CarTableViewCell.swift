//
//  CarTableViewCell.swift
//  Autoschool
//
//  Created by Max Sashcheka on 10/17/21.
//

import UIKit

class CarTableViewCell: UITableViewCell {

    static let reuseIdentifier = "CarTableViewCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    

    static func nib() -> UINib {
        return UINib(nibName: reuseIdentifier, bundle: nil)
    }
    
}
