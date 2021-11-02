//
//  InstructorTableViewCell.swift
//  Autoschool
//
//  Created by Max Sashcheka on 10/17/21.
//

import UIKit

class InstructorTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var fullNameLabel: UILabel!
    @IBOutlet weak var drivingExperienceLabel: UILabel!
    @IBOutlet weak var passportNumberLabel: UILabel!
    @IBOutlet weak var phoneNumberLabel: UILabel!
    
    static let reuseIdentifier = "InstructorTableViewCell"

    override func awakeFromNib() {
        super.awakeFromNib()
        accessoryType = .disclosureIndicator
    }
    
    static func nib() -> UINib {
        return UINib(nibName: reuseIdentifier, bundle: nil)
    }
    
    func setup(withInstructor instructor: Instructor) {
        fullNameLabel.text = "\(instructor.fullName)"
        drivingExperienceLabel.text = "Опыт вождения: \(instructor.drivingExperience) \(instructor.drivingExperience > 4 ? "лет" : "года")"
        passportNumberLabel.text = "Номер паспорта: \(instructor.passportNumber)"
        phoneNumberLabel.text = "Моб.телефон: \(instructor.phoneNumber)"
    }
    
}
