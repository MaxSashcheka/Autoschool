//
//  ExamCollectionViewCell.swift
//  Autoschool
//
//  Created by Max Sashcheka on 11/1/21.
//

import UIKit

class ExamCollectionViewCell: UICollectionViewCell {

    static let reuseIdentifier = "ExamCollectionViewCell"
    @IBOutlet weak var groupNameLabel: UILabel!
    @IBOutlet weak var examTypeLabel: UILabel!
    @IBOutlet weak var examDateLabel: UILabel!
    @IBOutlet weak var examIdentifierLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        backgroundColor = .white
        layer.cornerRadius = 30
        layer.borderWidth = 2
        layer.borderColor = UIColor.darkGray.cgColor
    }
    
    static func nib() -> UINib {
        return UINib(nibName: reuseIdentifier, bundle: nil)
    }
    
    func setup(withExam exam: Exam) {
        examIdentifierLabel.text = "Идентификатор: \(exam.examId)"
        groupNameLabel.text = "Группа: 913802"
        
        let endOfDate = String.Index(encodedOffset: 9)
        let examDateString = exam.date[...endOfDate]
        examDateLabel.text = "Дата проведения: \(examDateString)"
        
        switch exam.examTypeId {
        case 1: examTypeLabel.text = "Тип экзамена: внутренний теория"
        case 2: examTypeLabel.text = "Тип экзамена: внутренний практика"
        case 3: examTypeLabel.text = "Тип экзамена: гаи теория"
        case 4: examTypeLabel.text = "Тип экзамена: гаи практика"
        default: examTypeLabel.text = "Ошибка"
        }

    }

}
