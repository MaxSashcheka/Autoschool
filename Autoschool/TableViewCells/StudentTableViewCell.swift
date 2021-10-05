//
//  StudentCell.swift
//  Autoschool
//
//  Created by Max Sashcheka on 10/3/21.
//

import UIKit

class StudentTableViewCell: UITableViewCell {

    static let reuseIdentifier = "StudentTableViewCell"
    
    @IBOutlet weak var firstLastNameLabel: UILabel!
    @IBOutlet weak var patronymicLabel: UILabel!
    @IBOutlet weak var passportNumberLabel: UILabel!
    @IBOutlet weak var phoneNumberLabel: UILabel!
    @IBOutlet weak var instructorNameLabel: UILabel!
    
    @IBOutlet weak var cellNumber: UILabel!
    
    @IBOutlet weak var studentImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        studentImageView.layer.cornerRadius = studentImageView.frame.height / 4
        studentImageView.contentMode = .scaleAspectFill
//        studentImageView.layer.masksToBounds = false
    }
    
    func setup(withStudent student: Student, row: Int) {
        firstLastNameLabel.text = "\(student.lastName) \(student.firstName)"
        patronymicLabel.text = student.patronymic
        
        passportNumberLabel.text = "Номер паспорта: \(student.passportNumber)"
        
        phoneNumberLabel.text = "Моб. телефон: \(student.phoneNumber)"
        instructorNameLabel.text = "Инструктор: \(student.instructorName)"
        
        cellNumber.text = "\(row + 1)"
        studentImageView.image = UIImage(named: "student6")
    }
    
    static func nib() -> UINib {
        return UINib(nibName: "StudentTableViewCell", bundle: nil)
    }

}
