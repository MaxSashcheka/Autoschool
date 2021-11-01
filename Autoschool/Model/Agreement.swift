//
//  Agreement.swift
//  Autoschool
//
//  Created by Max Sashcheka on 10/29/21.
//

import Foundation

struct Agreement: Codable {
    var agreementId: Int
    var amount: Int
    var signingDate: String
    var administratorId: Int
    var studentId: Int
}
