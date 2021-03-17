//
//  Date.swift
//  AAACOMP iOS
//
//  Created by Rafael Escaleira on 15/07/20.
//  Copyright © 2020 Rafael Escaleira. All rights reserved.
//

import Foundation

extension Date {
    
    static var currentTimeStamp: String {
        return String(Int64(Date().timeIntervalSince1970 * 1000))
    }
    
    static var currentYear: Int {
        return Int(String.getCurrentDateFormatted(dateFormat: "yyyy")) ?? 0
    }
    
    static var currentMonth: Int {
        return Int(String.getCurrentDateFormatted(dateFormat: "MM")) ?? 0
    }
    
    static var currentDay: Int {
        return Int(String.getCurrentDateFormatted(dateFormat: "dd")) ?? 0
    }
}
