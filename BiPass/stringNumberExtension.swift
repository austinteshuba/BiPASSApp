//
//  stringNumberExtension.swift
//  BiPass
//
//  Created by Austin Teshuba on 2018-06-14.
//  Copyright © 2018 Austin Teshuba. All rights reserved.
// this is an extension for the buolt in string class to determine if the contents are a number

import Foundation
extension String  {
    var isNumber: Bool {
        return !isEmpty && rangeOfCharacter(from: CharacterSet.decimalDigits.inverted) == nil//ensure it isnt empty and make sure that there are no characters that arent allowed in the decimal character set
    }
    subscript(_ range: CountableClosedRange<Int>) -> String {//subscript is a function called when [] is used. must use a closed count range.
        let idx1 = index(startIndex, offsetBy: max(0, range.lowerBound))//get the start and end using the Index object in swift
        let idx2 = index(startIndex, offsetBy: min(self.count, range.upperBound))
        return String(self[idx1..<idx2])//check if this is actually a string
    }
}
