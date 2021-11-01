//
//  Group.swift
//  Autoschool
//
//  Created by Max Sashcheka on 10/3/21.
//

import Foundation

struct Group: Codable {
    var groupId: Int
    var name: String
    var lessonsStartDate: String
    var lessonsEndDate: String
    var categoryId: Int
    var teacherId: Int
    var lessonsTimeId: Int
}
