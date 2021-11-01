//
//  DriverLicense.swift
//  Autoschool
//
//  Created by Max Sashcheka on 10/17/21.
//

import Foundation

struct DriverLisence: Codable {
    var driverLicenseId: Int
    var issueDate: String
    var number: String
    var validity: Int
}
