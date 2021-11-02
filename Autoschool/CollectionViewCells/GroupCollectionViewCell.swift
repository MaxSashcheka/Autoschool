//
//  GroupCell.swift
//  Autoschool
//
//  Created by Max Sashcheka on 10/3/21.
//

import UIKit

class GroupCollectionViewCell: UICollectionViewCell {
    
    static let reuseIdentifier = "GroupCollectionViewCell"

    
    @IBOutlet weak var lessonsTimeLabel: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var categoryNameLabel: UILabel!
    @IBOutlet weak var categoryImageView: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
        
    override func awakeFromNib() {
        super.awakeFromNib()
        
        lessonsTimeLabel.layer.cornerRadius = lessonsTimeLabel.frame.width / 2
        categoryImageView.tintColor = .black
        
        backgroundColor = .white
        layer.cornerRadius = 30
//        layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.33).cgColor
//        layer.shadowRadius = 5.0
//        layer.shadowOpacity = 1.0
//        layer.shadowOffset = .zero
//        layer.masksToBounds = false
        layer.borderWidth = 2
        layer.borderColor = UIColor.darkGray.cgColor
    }
    
    func setup(withGroup group: Group) {
        backgroundColor = .white
        nameLabel.text = group.name
        
        switch group.categoryId {
        case 1:
            categoryImageView.image = UIImage(named: "motorbike")
            categoryNameLabel.text = "Категория А"
        case 2:
            categoryImageView.image = UIImage(systemName: "car")
            categoryNameLabel.text = "Категория B (АКПП)"
        case 3:
            categoryImageView.image = UIImage(systemName: "car")
            categoryNameLabel.text = "Категория В (МКПП)"
        default:
            print("Wrong categoryId")
        }
        
        switch group.lessonsTimeId {
        case 1:
            lessonsTimeLabel.backgroundColor = #colorLiteral(red: 1, green: 0.5781051517, blue: 0, alpha: 1)
        case 2:
            lessonsTimeLabel.backgroundColor = #colorLiteral(red: 0, green: 0.9768045545, blue: 0, alpha: 1)
        case 3:
            lessonsTimeLabel.backgroundColor = #colorLiteral(red: 0.3236978054, green: 0.1063579395, blue: 0.574860394, alpha: 1)
        default:
            print("Wrong lessonsTimeId")
        }
        let endOfDate = String.Index(encodedOffset: 9)

        let lessonsStartDateString = group.lessonsStartDate[...endOfDate].replacingOccurrences(of: "-", with: "/")
        let lessonsEndDateString = group.lessonsEndDate[...endOfDate].replacingOccurrences(of: "-", with: "/")
        
        dateLabel.text = "\(lessonsStartDateString) - \(lessonsEndDateString)"
//        studentsCountLabel.text = "Количество учеников: \(group.students.count)"
    }
    
    static func nib() -> UINib {
        return UINib(nibName: reuseIdentifier, bundle: nil)
    }

}
