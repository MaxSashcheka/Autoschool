//
//  InstructorCell.swift
//  Autoschool
//
//  Created by Max Sashcheka on 10/4/21.
//

import UIKit

class InstructorCell: UICollectionViewCell {
    
    static let reuseIdentifier = "InstructorCell"
    
    
    @IBOutlet weak var instructorsImageView: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var phoneNumberLabel: UILabel!
    @IBOutlet weak var drivingExperienceLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
//        layer.masksToBounds = false
        layer.cornerRadius = 30
        layer.borderWidth = 2
        layer.borderColor = UIColor.darkGray.cgColor
//        layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
//        layer.shadowRadius = 5
//        layer.shadowOpacity = 1.0
//        layer.shadowOffset = .zero
        
        instructorsImageView.layer.cornerRadius = 30
    }
    
    func setup(withInstructor instructor: Instructor) {
        nameLabel.text = "\(instructor.lastName) \(instructor.firstName) \(instructor.patronymic)"
        phoneNumberLabel.text = "Моб. телефон:\(instructor.phoneNumber)"
        drivingExperienceLabel.text = "Стаж вождения: \(instructor.drivingExperience) \(instructor.drivingExperience < 4 ? "года" : "лет")"
        instructorsImageView.image = #imageLiteral(resourceName: "instructor6")
    }
    
    static func nib() -> UINib {
        return UINib(nibName: "InstructorCell", bundle: nil)
    }


}
