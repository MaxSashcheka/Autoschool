//
//  Group.swift
//  Autoschool
//
//  Created by Max Sashcheka on 10/3/21.
//

import Foundation

struct Group {

    var groupID: Int
    var name: String
    var categoryID: Int
    var lessonsTypeID: Int

    var startLessonsDate: String
    var endLesonnsDate: String
    
    var students = [Student]()
}
