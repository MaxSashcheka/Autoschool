//
//  Group.swift
//  Autoschool
//
//  Created by Max Sashcheka on 10/3/21.
//

import Foundation

struct Group: Codable {
    var groupId: Int = 0
    var name: String = ""
    var lessonsStartDate: String = ""
    var lessonsEndDate: String = ""
    var categoryId: Int = 0
    var teacherId: Int = 0
    var lessonsTimeId: Int = 0
}
