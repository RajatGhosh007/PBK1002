//
//  UITextField+Extension.swift
//  PerfectBookKeeping
//
//  Created by Rajat Ghosh on 21/04/23.
//

import UIKit

extension UITextField {

    /// Validates all text field are non-nil and non-empty, Returns true if all fields pass.
    /// - Returns: Bool
    static func validateAll(textFields:[UITextField]) -> Bool {
        // Check each field for nil and not empty.
        for field in textFields {
            // Remove space and new lines while unwrapping.
            guard let fieldText = field.text?.trimmingCharacters(in: .whitespacesAndNewlines) else {
                return false
            }
            // Are there no other charaters?
            if (fieldText.isEmpty) {
                return false
            }

        }
        // All fields passed.
        return true
    }

}
