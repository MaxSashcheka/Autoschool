//
//  Student.swift
//  Autoschool
//
//  Created by Max Sashcheka on 10/3/21.
//

import Foundation

struct Student: Codable {
    var studentId: Int
    var firstName: String
    var lastName: String
    var middleName: String
    var passportNumber: String
    var phoneNumber: String
    var instructorId: Int
    var groupId: Int
    
    var fullName: String {
        return "\(lastName) \(firstName) \(middleName)"
    }
}
