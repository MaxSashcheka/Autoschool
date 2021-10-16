//
//  GroupCell.swift
//  Autoschool
//
//  Created by Max Sashcheka on 10/3/21.
//

import UIKit

class GroupCell: UICollectionViewCell {
    
    static let reuseIdentifier = "GroupCell"

    
    @IBOutlet weak var dayPartIndicatorView: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var categoryNameLabel: UILabel!
    @IBOutlet weak var categoryImageView: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var studentsCountLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        dayPartIndicatorView.layer.cornerRadius = dayPartIndicatorView.frame.width / 2
        categoryImageView.tintColor = .black
        
        backgroundColor = .white
        layer.cornerRadius = 30
        layer.borderWidth = 2
        layer.borderColor = UIColor.darkGray.cgColor
    }
    
    func setup(withGroup group: Group) {
    
        nameLabel.text = group.name
        
        switch group.category {
        case .a:
            categoryImageView.image = UIImage(systemName: "bicycle")
            categoryNameLabel.text = "Категория А"
        case .AutomaticB:
            categoryImageView.image = UIImage(systemName: "car")
            categoryNameLabel.text = "Категория B (АКПП)"
        case .ManuallyB:
            categoryImageView.image = UIImage(systemName: "car")
            categoryNameLabel.text = "Категория В (МКПП)"
        }

        switch group.dayPart {
        case .morning:
            dayPartIndicatorView.backgroundColor = #colorLiteral(red: 1, green: 0.5781051517, blue: 0, alpha: 1)
        case .evening:
            dayPartIndicatorView.backgroundColor = #colorLiteral(red: 0.3236978054, green: 0.1063579395, blue: 0.574860394, alpha: 1)
        }
        
        dateLabel.text = "\(group.startLessonsDate) - \(group.endLesonnsDate)"
        studentsCountLabel.text = "Количество учеников: \(group.students.count)"
    }
    
    static func nib() -> UINib {
        return UINib(nibName: reuseIdentifier, bundle: nil)
    }

}
