//
//  Extensions.swift
//  Autoschool
//
//  Created by Max Sashcheka on 10/1/21.
//

import UIKit

extension UIColor {
    static let lightGreenSea: UIColor = UIColor(red: 33.0 / 255.0, green: 176.0 / 255.0, blue: 142.0 / 255.0, alpha: 1.0)
    static let chillSky: UIColor = UIColor(red: .zero, green: 178.0 / 255.0, blue: 255.0 / 255.0, alpha: 1.0)
    static let quarterBlack: UIColor = UIColor(red: .zero, green: .zero, blue: .zero, alpha: 0.25)
    static let viewBackground: UIColor = UIColor.secondarySystemBackground
}


extension String {
    func widthOfString(usingFont font: UIFont) -> CGFloat {
        let fontAttributes = [NSAttributedString.Key.font: font]
        let size = (self as NSString).size(withAttributes: fontAttributes)
        return ceil(size.width)
    }
}

