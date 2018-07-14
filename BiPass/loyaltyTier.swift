//
//  loyaltyTier.swift
//  BiPass
//
//  Created by Austin Teshuba on 2018-06-08.
//  Copyright © 2018 Austin Teshuba. All rights reserved.
//  this is a class containing the informationcfor each of the loyalty tier

import Foundation
class LoyaltyTier {
    var name:String//fields
    var pointsMultiplier:Double
    var pointValue:Int
    var otherBenefits: String?
    var tierNumber:Int
    
    init (name:String, multiplier: Double, value:Int, tierNumber:Int, other: String?) {
        self.name = name
        self.pointsMultiplier = multiplier
        self.pointValue = value
        self.tierNumber = tierNumber
        self.otherBenefits = other
    }
    
}
