//
//  TeacherTableViewCell.swift
//  Autoschool
//
//  Created by Max Sashcheka on 10/17/21.
//

import UIKit

class TeacherTableViewCell: UITableViewCell {

    static let reuseIdentifier = "TeacherTableViewCell"
    
    @IBOutlet weak var fullNameLabel: UILabel!
    
    @IBOutlet weak var mobilePhoneNumberLabel: UILabel!
    @IBOutlet weak var passportNumberLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    static func nib() -> UINib {
        return UINib(nibName: reuseIdentifier, bundle: nil)
    }
    
    
}
