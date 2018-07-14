//
//  Loyalty.swift
//  BiPass
//
//  Created by Austin Teshuba on 2018-06-08.
//  Copyright © 2018 Austin Teshuba. All rights reserved.
//this is a loyalty class that contains all of the functions related to the loyalty program of businesses

import Foundation
import Firebase//import databaser things

enum PointsPer:String {//thuis is an enum that pint s are awarded either dollars or purchases
    case dollar = "dollar"
    case purchase = "purchase"
}

class Loyalty {
    var name:String//fields and properties
    var pointsUnit: PointsPer
    var earningsRate: Int
    var tiers: Int
    var tierOne: LoyaltyTier?
    var tierTwo: LoyaltyTier?
    var tierThree: LoyaltyTier?
    
    init(name:String, pointsUnit:PointsPer, earningsRate:Int, tiers:Int, tierOne:LoyaltyTier?, tierTwo:LoyaltyTier?, tierThree:LoyaltyTier?) {
        self.name = name
        self.pointsUnit = pointsUnit
        self.earningsRate = earningsRate
        self.tiers = tiers
        self.tierOne = tierOne
        self.tierTwo = tierTwo
        self.tierThree = tierThree
    }
    
    
    
    func upload(businessName:String) {
        var ref: FIRDatabaseReference//make a firebase reference
        ref = FIRDatabase.database().reference()
        
        if let b = businessName.encodeKeys(), let n = name.encodeKeys(), let p = pointsUnit.rawValue.encodeKeys(), let t = String(tiers).encodeKeys(), let r = String(earningsRate).encodeKeys() {//if the fields can be encoded
            ref.child("businesses").child(b).child("Loyalty").setValue(["name":n, "pointsUnit":p, "tiers":t, "earningsRate":r])
            
            if (tiers>0) {//if there are tiers, upload tier one
                let desc = tierOne?.otherBenefits ?? ""
                if let tier = tierOne, let n = tier.name.encodeKeys(), let m = String(tier.pointsMultiplier).encodeKeys(), let v = String(tier.pointValue).encodeKeys() {
                    ref.child("businesses").child(b).child("Loyalty").child("tierOne").setValue(["name":n, "pointsMultiplier": m, "value": v, "otherBenefits": desc])
                }
            }
            
            if (tiers>1) {//upload tier two
                let desc = tierTwo?.otherBenefits ?? ""
                if let tier = tierTwo, let n = tier.name.encodeKeys(), let m = String(tier.pointsMultiplier).encodeKeys(), let v = String(tier.pointValue).encodeKeys() {
                    ref.child("businesses").child(b).child("Loyalty").child("tierOne").setValue(["name":n, "pointsMultiplier": m, "value": v, "otherBenefits": desc])
                }
            }
            if (tiers>2) {//upload tier 3
                let desc = tierThree?.otherBenefits ?? ""
                if let tier = tierThree, let n = tier.name.encodeKeys(), let m = String(tier.pointsMultiplier).encodeKeys(), let v = String(tier.pointValue).encodeKeys() {
                    ref.child("businesses").child(b).child("Loyalty").child("tierOne").setValue(["name":n, "pointsMultiplier": m, "value": v, "otherBenefits": desc])
                }
            }
        }
        
        
        
        
        
        
    }
}
