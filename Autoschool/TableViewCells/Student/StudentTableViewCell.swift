//
//  StudentCell.swift
//  Autoschool
//
//  Created by Max Sashcheka on 10/3/21.
//

import UIKit

class StudentTableViewCell: UITableViewCell {

    static let reuseIdentifier = "StudentTableViewCell"
    
    @IBOutlet weak var fullNameLabel: UILabel!
    
    @IBOutlet weak var passportNumberLabel: UILabel!
    @IBOutlet weak var phoneNumberLabel: UILabel!
    @IBOutlet weak var instructorNameLabel: UILabel!
    
    @IBOutlet weak var cellNumber: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setup(withStudent student: Student, andInstructor instructor: Instructor) {
        fullNameLabel.text = "\(student.fullName)"
        
        passportNumberLabel.text = "Номер паспорта: \(student.passportNumber)"
        
        phoneNumberLabel.text = "Моб. телефон: \(student.phoneNumber)"
        instructorNameLabel.text = "Инструктор: \(instructor.lastName) \(instructor.firstName)"
    }
    
    
    static func nib() -> UINib {
        return UINib(nibName: reuseIdentifier, bundle: nil)
    }

}
