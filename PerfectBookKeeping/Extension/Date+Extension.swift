//
//  Date+Extension.swift
//  PerfectBookKeeping
//
//  Created by Rajat Ghosh on 26/05/23.
//

import Foundation



extension Date {
    
    
    func getSelectDateInString(format: String = "dd-MM-yyyy") -> String? {
            let formatter = DateFormatter()
           // formatter.dateStyle = .short
            formatter.timeZone = TimeZone(abbreviation: "UTC")
            formatter.locale = Locale.current
            formatter.dateFormat = format
            return formatter.string(from: self)
        }
    
   
    
    
}
