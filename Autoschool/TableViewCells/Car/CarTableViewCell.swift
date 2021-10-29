//
//  CarTableViewCell.swift
//  Autoschool
//
//  Created by Max Sashcheka on 10/17/21.
//

import UIKit

class CarTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var colorLabel: UILabel!
    
    static let reuseIdentifier = "CarTableViewCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    static func nib() -> UINib {
        return UINib(nibName: reuseIdentifier, bundle: nil)
    }
    
    func setup(withCar car: Car) {
        nameLabel.text = "Машина: \(car.name)"
        numberLabel.text = "Номер: \(car.number)"
        colorLabel.text = "Цвет: \(car.color)"
    }
    
}
