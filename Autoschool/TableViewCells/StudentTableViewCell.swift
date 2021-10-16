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
    
    func setup(withStudent student: Student) {
        fullNameLabel.text = "\(student.lastName) \(student.firstName) \(student.patronymic)"
        
        passportNumberLabel.text = "Номер паспорта: \(student.passportNumber)"
        
        phoneNumberLabel.text = "Моб. телефон: \(student.phoneNumber)"
        instructorNameLabel.text = "Инструктор: \(student.instructorName)"

    }
    
    static func nib() -> UINib {
        return UINib(nibName: "StudentTableViewCell", bundle: nil)
    }

}
