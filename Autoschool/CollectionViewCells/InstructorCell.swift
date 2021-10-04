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
        
        let cornerRadius: CGFloat = 30
        
        layer.masksToBounds = false
        layer.cornerRadius = cornerRadius
        backgroundColor = .white
        layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        layer.shadowRadius = 4
        layer.shadowOpacity = 1.0
        layer.shadowOffset = .zero
        
        instructorsImageView.layer.cornerRadius = cornerRadius
    }
    
    func setup(withInstructor instructor: Instructor) {
        nameLabel.text = "\(instructor.lastName) \(instructor.firstName) \(instructor.patronymic)"
        phoneNumberLabel.text = "Моб. телефон:\(instructor.phoneNumber)"
        drivingExperienceLabel.text = "Стаж вождения: \(instructor.drivingExperience)"
        instructorsImageView.image = #imageLiteral(resourceName: "instructor3")
    }
    
    static func nib() -> UINib {
        return UINib(nibName: "InstructorCell", bundle: nil)
    }


}
