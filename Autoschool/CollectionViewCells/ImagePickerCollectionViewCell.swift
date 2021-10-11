//
//  StudentCollectionViewCell.swift
//  Autoschool
//
//  Created by Max Sashcheka on 10/5/21.
//

import UIKit

class ImagePickerCollectionViewCell: UICollectionViewCell {

    static let reuseIdentifier = "ImagePickerCollectionViewCell"
    
    @IBOutlet weak var pickerImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let cornerRadius: CGFloat = 30
//        layer.masksToBounds = false
//        backgroundColor = .white

        layer.cornerRadius = 30
        layer.borderWidth = 2
        layer.borderColor = UIColor.darkGray.cgColor
        //        backgroundColor = .white

//        layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
//        layer.shadowRadius = 5
//        layer.shadowOpacity = 1.0
//        layer.shadowOffset = .zero
        
        pickerImageView.layer.cornerRadius = cornerRadius
    }
    
    func setup(withStudent student: Student) {
        pickerImageView.image = #imageLiteral(resourceName: "student12")
    }
    
    static func nib() -> UINib {
        return UINib(nibName: "ImagePickerCollectionViewCell", bundle: nil)
    }

}
