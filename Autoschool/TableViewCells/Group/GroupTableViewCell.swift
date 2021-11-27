//
//  GroupTableViewCell.swift
//  Autoschool
//
//  Created by Max Sashcheka on 11/27/21.
//

import UIKit

class GroupTableViewCell: UITableViewCell {

    static let reuseIdentifier = "GroupTableViewCell"
    static func nib() -> UINib {
        return UINib(nibName: reuseIdentifier, bundle: nil)
    }
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var lessonsTimeLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func setup(withGroup group: Group) {
        nameLabel.text = "Группа: \(group.name)"
        categoryLabel.text = "Категория \(group.category.categoryName)"
        lessonsTimeLabel.text = "Время занятий: \(group.lessonsTime.lessonsTimeName)"
        
        let endOfDate = String.Index(encodedOffset: 9)
        let lessonsStartDateString = group.lessonsStartDate[...endOfDate].replacingOccurrences(of: "-", with: "/")
        let lessonsEndDateString = group.lessonsEndDate[...endOfDate].replacingOccurrences(of: "-", with: "/")
        
        dateLabel.text = "\(lessonsStartDateString) - \(lessonsEndDateString)"
    }


    
}
