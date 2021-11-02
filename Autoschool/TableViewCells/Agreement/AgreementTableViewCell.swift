//
//  AgreementTableViewCell.swift
//  Autoschool
//
//  Created by Max Sashcheka on 10/18/21.
//

import UIKit

class AgreementTableViewCell: UITableViewCell {
    
    @IBOutlet weak var identifierLabel: UILabel!
    @IBOutlet weak var administratorNameLabel: UILabel!
    @IBOutlet weak var studentNameLabel: UILabel!
    @IBOutlet weak var signingDateLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    
    static let reuseIdentifier = "AgreementTableViewCell"

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    static func nib() -> UINib {
        return UINib(nibName: reuseIdentifier, bundle: nil)
    }
    
    func setup(withAgreement agreement: Agreement, administrator: Administrator, student: Student) {
        identifierLabel.text = "Договор номер: \(agreement.agreementId)"
        administratorNameLabel.text = "Администратор: \(administrator.fullName)"
        studentNameLabel.text = "Студент: \(student.fullName)"
        amountLabel.text = "Стоимость договора: \(agreement.amount) (бел.руб)"
        
        let endOfDate = String.Index(encodedOffset: 9)
        signingDateLabel.text = "Дата подписания: \(agreement.signingDate[...endOfDate])"

    }
    
}
