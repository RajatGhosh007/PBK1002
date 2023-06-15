//
//  String+Size.swift
//  PerfectBookKeeping
//
//  Created by Rajat Ghosh on 21/04/23.
//

import UIKit


extension String {
    func size(attribute: [NSAttributedString.Key : Any], size: CGSize) -> CGSize {
        let attributedText = NSAttributedString(string: self, attributes: attribute)
        return attributedText.boundingRect(with: size, options: NSStringDrawingOptions.usesLineFragmentOrigin, context: nil).size
    }
    
    var isValidEmail: Bool {
        NSPredicate(format: "SELF MATCHES %@", "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}").evaluate(with: self)
    }
    
     
        
    func getFormattedDateFromString(inputFormatter: String ,outputFormatter: String) -> String  {
        
                var strDateDis = ""
              
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = inputFormatter
                dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
                dateFormatter.locale = Locale.current
                
                if let date = dateFormatter.date(from:self) {
                    
                    let dateFormteOut = DateFormatter()
                    dateFormteOut.dateFormat = outputFormatter
                    dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
                    dateFormteOut.locale = Locale.current
                    strDateDis =  dateFormteOut.string(from: date)
                   
                }
              
                
                return  strDateDis
        }
    
    
    
      func getDateFromString(format: String = "dd-MM-yyyy") -> Date? {
            let formatter = DateFormatter()
            formatter.dateStyle = .short
          //  formatter.timeZone = TimeZone(abbreviation: "UTC")
          //  formatter.locale = Locale.current
            formatter.dateFormat = format
            return formatter.date(from: self)
        }
        
   
    
}
extension Data {
  mutating func append(string: String) {
    let data = string.data(
        using: String.Encoding.utf8,
        allowLossyConversion: true)
    append(data!)
  }
}
