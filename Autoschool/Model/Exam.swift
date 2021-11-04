//
//  Exam.swift
//  Autoschool
//
//  Created by Max Sashcheka on 10/29/21.
//

import Foundation

struct Exam: Codable {
    var examId: Int = 0
    var date: String = ""
    var examTypeId: Int = 0
    var examType: ExamType = ExamType()
    var groupId: Int = 0
}

struct ExamType: Codable {
    var examTypeId: Int = 0
    var examTypeName: String = ""
}
