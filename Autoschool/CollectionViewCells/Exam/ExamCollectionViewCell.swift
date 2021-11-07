//
//  ExamCollectionViewCell.swift
//  Autoschool
//
//  Created by Max Sashcheka on 11/1/21.
//

import UIKit

class ExamCollectionViewCell: UICollectionViewCell {

    static let reuseIdentifier = "ExamCollectionViewCell"
    
    @IBOutlet weak var examTypeView: UIView!
    @IBOutlet weak var examIdentifierLabel: UILabel!
    @IBOutlet weak var examTypeLabel: UILabel!
    @IBOutlet weak var examDateLabel: UILabel!
    @IBOutlet weak var groupNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.45).cgColor
        layer.shadowRadius = 3.5
        layer.shadowOpacity = 1.0
        layer.shadowOffset = .zero
        layer.masksToBounds = false
        backgroundColor = .white
        layer.cornerRadius = 20
        examTypeView.layer.cornerRadius = layer.cornerRadius
    }
    
    static func nib() -> UINib {
        return UINib(nibName: reuseIdentifier, bundle: nil)
    }
    
    func setup(withExam exam: Exam, andGroup group: Group) {
        groupNameLabel.text = "Группа: \(group.name)"
        examIdentifierLabel.text = "Идентификатор: \(exam.examId)"

        let endOfDate = String.Index(encodedOffset: 9)
        let examDateString = exam.date[...endOfDate]
        examDateLabel.text = "Дата проведения: \(examDateString)"
        
        examTypeLabel.text = "Тип экзамена: \(exam.examType.examTypeName)"
        switch exam.examTypeId {
        case 1, 2:
            examTypeView.backgroundColor = .systemGreen
        case 3, 4:
            examTypeView.backgroundColor = .systemRed
        default: examTypeLabel.text = "Ошибка"
        }

    }

}
