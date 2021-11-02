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
        examTypeView.layer.cornerRadius = examTypeView.frame.width / 2
        backgroundColor = .white
        layer.cornerRadius = 30
        layer.borderWidth = 2
        layer.borderColor = UIColor.darkGray.cgColor
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
        
        switch exam.examTypeId {
        case 1:
            examTypeLabel.text = "Тип экзамена: внутренний теория"
            examTypeView.backgroundColor = .systemGreen
        case 2:
            examTypeLabel.text = "Тип экзамена: внутренний практика"
            examTypeView.backgroundColor = .systemGreen
        case 3:
            examTypeLabel.text = "Тип экзамена: гаи теория"
            examTypeView.backgroundColor = .systemRed
        case 4:
            examTypeLabel.text = "Тип экзамена: гаи практика"
            examTypeView.backgroundColor = .systemRed
        default: examTypeLabel.text = "Ошибка"
        }

    }

}
