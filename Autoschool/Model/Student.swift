//
//  Student.swift
//  Autoschool
//
//  Created by Max Sashcheka on 10/3/21.
//

import Foundation

struct Student: Codable {
    var studentID: Int
    var firstName: String
    var lastName: String
    var middleName: String
    var passportNumber: String
    var phoneNumber: String
    var instructorId: Int
    var groupId: Int
}
