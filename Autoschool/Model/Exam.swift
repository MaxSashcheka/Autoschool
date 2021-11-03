//
//  Exam.swift
//  Autoschool
//
//  Created by Max Sashcheka on 10/29/21.
//

import Foundation

struct Exam: Codable {
    var examId: Int
    var date: String
    var examTypeId: Int
    var examType: ExamType
    var groupId: Int
}

struct ExamType: Codable {
    var examTypeId: Int
    var examTypeName: String
}
