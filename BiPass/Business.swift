//
//  Business.swift
//  BiPass
//
//  Created by Austin Teshuba on 2018-06-08.
//  Copyright © 2018 Austin Teshuba. All rights reserved.
// class the contains the boilerplate info for a business

import Foundation
import UIKit
import Firebase//database info

class Business {
    var name:String//fields
    var postalCode:String
    var address:String
    var city:String
    var payments:Bool
    var loyalty:Bool
    var logo:UIImage?
    var phone:String?
    var email:String?
    var description:String?
    var loyaltyProgram:Loyalty? = nil
    
    init (name:String, postalCode: String, address:String, city:String, payments:Bool, loyalty:Bool) {
        self.name = name
        self.postalCode = postalCode
        self.address = address
        self.city = city
        self.payments = payments
        self.loyalty = loyalty
        self.logo = nil
        self.phone = nil
        self.email = nil
        self.description = nil
    }
    
    func upload()->Bool {//uploads to firebase
        var ref: FIRDatabaseReference//make reference
        ref = FIRDatabase.database().reference()
        var exists:Bool = true
      
        guard let l = logo else {
            print("logo no exist")
            return false
        }
        let storage = FIRStorage.storage()//make the storage reference
        let storageRef = storage.reference()
        
        let date:Date = Date()//current date stuff
        let dateFormatter:DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        
        let imageRef = storageRef.child("\(self.name)/\(dateFormatter.string(from:date))")//upload the image
        let data:Data = UIImageJPEGRepresentation(l, 1.0)!//now the image is an ios image object.
        print("we uploading now")
        var downloadURL:URL? = nil//get the download url
        _ = imageRef.put(data, metadata:nil, completion: {
            (metadata,error) in
            print("theres something happening")
            guard let metadata=metadata else {
                print(error)
                return
            }
            downloadURL = metadata.downloadURL()//get the download url
            guard downloadURL != nil else {
                print("download url missing")
                return
            }
            
            var paymentText = "no"//store the booleans with no as the default
            var loyaltyText = "no"
            
            if (self.payments) {//change if the default is true
                paymentText = "yes"
                exists=false
            }
            if (self.loyalty) {
                loyaltyText = "yes"
                exists=false
            }
            
            
            
            if let n = self.name.encodeKeys(), let p = self.postalCode.encodeKeys(), let a = self.address.encodeKeys(), let c = self.city.encodeKeys(), let phone = self.phone?.encodeKeys(), let e = self.email?.encodeKeys(), let d = self.description?.encodeKeys(), let down = downloadURL!.absoluteString.encodeKeys() {
                ref.child("businesses").child(n).setValue(["email":e, "phone":phone, "description":d, "address":a, "city": c, "postalCode":p, "logo":down, "payment": paymentText, "loyalty": loyaltyText, "balance":"0.0", "pointsOwing": "0.0"])//upload to the database
                print("business uploaded")
            } else {//if error decoding, return false cause faulure
                exists=true
                print("error decoding")
            }
            
            if (self.loyalty) {//if theres loyaltyy, upload the program!
                self.loyaltyProgram?.upload(businessName: self.name)
            }
            })
        
       
        
        
        return !exists//return tif it works
        
        
        
        
        
        
        
    }
    
}
