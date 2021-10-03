//
//  Group.swift
//  Autoschool
//
//  Created by Max Sashcheka on 10/3/21.
//

import Foundation

struct Group {
    
    var name: String
    var category: DrivingCategory
    var dayPart: DayPart
    var startLessonsDate: String
    var endLesonnsDate: String
    
}

enum DrivingCategory {
    case a
    case ManuallyB
    case AutomaticB
}

enum DayPart {
    case morning
    case evening
}
