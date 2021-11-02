//
//  WorkerTableViewCell.swift
//  Autoschool
//
//  Created by Max Sashcheka on 10/17/21.
//

import UIKit

class AdministratorTableViewCell: UITableViewCell {

    @IBOutlet weak var fullNameLabel: UILabel!
    @IBOutlet weak var phoneNumberLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    
    static let reuseIdentifier = "AdministratorTableViewCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    static func nib() -> UINib {
        return UINib(nibName: reuseIdentifier, bundle: nil)
    }
    
    func setup(withAdministrator administrator: Administrator) {
        fullNameLabel.text = "\(administrator.lastName) \(administrator.firstName) \(administrator.middleName)"
        phoneNumberLabel.text = "Моб. телефон: \(administrator.phoneNumber)"
        emailLabel.text = "Почтa: \(administrator.email)"
    }
    
}
