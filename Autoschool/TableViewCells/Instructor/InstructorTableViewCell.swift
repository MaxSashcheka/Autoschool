//
//  InstructorTableViewCell.swift
//  Autoschool
//
//  Created by Max Sashcheka on 10/17/21.
//

import UIKit

class InstructorTableViewCell: UITableViewCell {
    
    static let reuseIdentifier = "InstructorTableViewCell"

    override func awakeFromNib() {
        super.awakeFromNib()
        accessoryType = .disclosureIndicator
    }
    
    static func nib() -> UINib {
        return UINib(nibName: reuseIdentifier, bundle: nil)
    }
    
}
