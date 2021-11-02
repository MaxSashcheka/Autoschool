//
//  Instructor.swift
//  Autoschool
//
//  Created by Max Sashcheka on 10/4/21.
//

import Foundation

struct Instructor: Codable {
    var instructorId: Int
    var firstName: String
    var lastName: String
    var middleName: String
    var drivingExperience: Int
    var passportNumber: String
    var phoneNumber: String
    var carId: Int
    var driverLicenseId: Int
    
    var fullName: String {
        return "\(lastName) \(firstName) \(middleName)"
    }
}
