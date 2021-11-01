//
//  Teacher.swift
//  Autoschool
//
//  Created by Max Sashcheka on 10/29/21.
//

import Foundation

struct Teacher: Codable {
    var teacherID: Int
    var firstName: String
    var lastName: String
    var middleName: String
    var passportNumber: String
    var phoneNumber: String
}
