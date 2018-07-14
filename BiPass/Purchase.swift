//
//  Purchase.swift
//  BiPass
//
//  Created by Austin Teshuba on 2018-06-14.
//  Copyright © 2018 Austin Teshuba. All rights reserved.
// This is a class outlining the componenets of a purchase

import Foundation

class Purchase {
    var total:Double//properties for total, taxes, subtotal, and type
    var taxes:Double
    var business: Business?
    var user: User?
    var loyaltyPoints: Double?
    var type: TransactionType
    var cog: CogPerson? = nil
    var subtotal:Double
    
    init (subtotal:Double, taxes:Double, total:Double, loyaltyPoints:Double?, type: TransactionType) {
        self.subtotal = subtotal
        self.taxes = taxes
        self.total = total
        self.loyaltyPoints = loyaltyPoints
        self.type = type
        user = nil
        business = nil
    }
    
    
    
    
    
}
