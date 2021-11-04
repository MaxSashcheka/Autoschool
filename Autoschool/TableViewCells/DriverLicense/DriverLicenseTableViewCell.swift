//
//  DriverLicenseTableViewCell.swift
//  Autoschool
//
//  Created by Max Sashcheka on 11/4/21.
//

import UIKit

class DriverLicenseTableViewCell: UITableViewCell {

    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var issueDateLabel: UILabel!
    @IBOutlet weak var validityLabel: UILabel!
    
    static let reuseIdentifier = "DriverLicenseTableViewCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
    
    }
    
    static func nib() -> UINib {
        return UINib(nibName: reuseIdentifier, bundle: nil)
    }
    
    func setup(withDriverLicense driverLicense: DriverLisence) {
        numberLabel.text = "Номер: \(driverLicense.number)"
        validityLabel.text = "Срок действия: \(driverLicense.validity) \(driverLicense.validity > 4 ? "лет" : "года")"
        let endOfDate = String.Index(encodedOffset: 9)
        issueDateLabel.text = "Дата выдачи: \(driverLicense.issueDate[...endOfDate])"
    }

}
