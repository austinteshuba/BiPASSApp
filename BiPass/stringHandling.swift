//
//  stringHandling.swift
//  BiPass
//
//  Created by Austin Teshuba on 2018-05-14.
//  Copyright © 2018 Austin Teshuba. All rights reserved.
// this is an extension for strings and changing strings for databases

import Foundation
import UIKit

extension String {
    func encodeKeys() -> String? {//encodes strings to only allow characters that can go in databases
        let original: String = self
        return original.lowercased().addingPercentEncoding(withAllowedCharacters: .alphanumerics)
    }

    func decodeKeys() -> String? {//removes the replaced character s from database and gives normal outputs.
        let original:String = self
        return original.removingPercentEncoding
    
    }
}
