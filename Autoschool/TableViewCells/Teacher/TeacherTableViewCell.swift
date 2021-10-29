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
    
    @IBOutlet weak var phoneNumberLabel: UILabel!
    @IBOutlet weak var passportNumberLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        accessoryType = .disclosureIndicator
        
    }

    static func nib() -> UINib {
        return UINib(nibName: reuseIdentifier, bundle: nil)
    }
    
    func setup(withTeacher teacher: Teacher) {
        fullNameLabel.text = "\(teacher.lastName) \(teacher.firstName) \(teacher.middleName)"
        phoneNumberLabel.text = "Моб.телефон: \(teacher.phoneNumber)"
        passportNumberLabel.text = "Номер паспорта: \(teacher.passportNumber)"
        
    }
    
}
