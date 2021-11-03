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
    var category: Category = Category()
    var teacherId: Int = 0
    var lessonsTimeId: Int = 0
    var lessonsTime: LessonsTime = LessonsTime()
}

struct Category: Codable {
    var categoryId: Int = 0
    var categoryName: String = ""
}

struct LessonsTime: Codable {
    var lessonsTimeId: Int = 0
    var lessonsTimeName: String = ""
}
