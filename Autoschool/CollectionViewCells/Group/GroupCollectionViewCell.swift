//
//  GroupCell.swift
//  Autoschool
//
//  Created by Max Sashcheka on 10/3/21.
//

import UIKit

class GroupCollectionViewCell: UICollectionViewCell {
    
    static let reuseIdentifier = "GroupCollectionViewCell"

    @IBOutlet weak var lessonsTimeView: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var categoryNameLabel: UILabel!
    @IBOutlet weak var categoryImageView: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var lessonsTimeLabel: UILabel!
    @IBOutlet weak var teacherNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        categoryImageView.tintColor = .black
        layer.masksToBounds = false
        backgroundColor = .white
        
        layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.35).cgColor
        layer.shadowRadius = 3.0
        layer.shadowOpacity = 1.0
        layer.shadowOffset = .zero
        layer.cornerRadius = 25
        lessonsTimeView.layer.cornerRadius = layer.cornerRadius


    }
    
    func setup(withGroup group: Group) {
        backgroundColor = .white
        nameLabel.text = "Группа: \(group.name)"
        categoryNameLabel.text = "Категория \(group.category.categoryName)"

        switch group.categoryId {
        case 1:
            categoryImageView.image = UIImage(named: "motorbike")
        case 2:
            categoryImageView.image = UIImage(systemName: "car")
        case 3:
            categoryImageView.image = UIImage(systemName: "car")
        default:
            print("Wrong categoryId")
        }
        
        lessonsTimeLabel.text = "Время занятий: \(group.lessonsTime.lessonsTimeName)"
        switch group.lessonsTimeId {
        case 1:
            lessonsTimeView.backgroundColor = #colorLiteral(red: 0.9880984426, green: 0.9543653131, blue: 0.02447881922, alpha: 1)
        case 2:
            lessonsTimeView.backgroundColor = #colorLiteral(red: 0, green: 0.9768045545, blue: 0, alpha: 1)
        case 3:
            lessonsTimeView.backgroundColor = #colorLiteral(red: 0.3236978054, green: 0.1063579395, blue: 0.574860394, alpha: 1)
        default:
            print("Wrong lessonsTimeId")
        }
        
        let endOfDate = String.Index(encodedOffset: 9)
        let lessonsStartDateString = group.lessonsStartDate[...endOfDate].replacingOccurrences(of: "-", with: "/")
        let lessonsEndDateString = group.lessonsEndDate[...endOfDate].replacingOccurrences(of: "-", with: "/")
        
        dateLabel.text = "\(lessonsStartDateString) - \(lessonsEndDateString)"
    }
    
    static func nib() -> UINib {
        return UINib(nibName: reuseIdentifier, bundle: nil)
    }

}

