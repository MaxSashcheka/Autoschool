//
//  Teacher.swift
//  Autoschool
//
//  Created by Max Sashcheka on 10/29/21.
//

import Foundation

struct Teacher: Codable {
    var teacherId: Int = 0
    var firstName: String = ""
    var lastName: String = ""
    var middleName: String = ""
    var passportNumber: String = ""
    var phoneNumber: String = ""
    
    var fullName: String {
        return "\(lastName) \(firstName) \(middleName)"
    }
}
