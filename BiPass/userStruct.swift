//
//  userStruct.swift
//  BiPass
//
//  Created by Austin Teshuba on 2018-04-17.
//  Copyright © 2018 Austin Teshuba. All rights reserved.
//this is the gloabl structure for a user

import Foundation
import Firebase
import CoreLocation


class User {
    var email:String//fields
    var firstName:String
    var lastName:String
    var password:String?
    
    var personObject: CogPerson?
    var detailsAdded:Bool {//computed property and it is read only.
        get {
            if let c = creditCard, let _=address, let _=postalCode {
                if (c.validate()) {
                    return true
                } else {
                    print("the credit card is not validated!")
                }
            } else {
                print("Please enter all the requested information")
            }
            return false
        }
    }
    var creditCard:CreditCard?
    private var basicsUploaded = false
    var address:String?
    var postalCode:String?
    var city:String?
    
    init (email:String, firstName:String, lastName:String, personObject:CogPerson?) {
        self.email = email
        self.firstName = firstName
        self.lastName = lastName
        self.personObject = personObject
        creditCard = nil
        address = nil
        postalCode = nil
        password = nil
    }
    init (email: String, firstName:String, lastName:String, personObject:CogPerson?, creditCard: CreditCard, address:String, postalCode: String, password: String) {
        self.email = email
        self.firstName = firstName
        self.lastName = lastName
        self.personObject = personObject
        self.creditCard = creditCard
        self.address = address
        self.postalCode = postalCode
        basicsUploaded = true
        self.password = password
    }
    
    func upload()->Bool {//will return if the upload was successful
        var ref: FIRDatabaseReference
        ref = FIRDatabase.database().reference()//make the databse regerences
        var exists:Bool = false
        
        print(emails)
        if (basicsUploaded==false) {
            if (emails.contains(self.email.lowercased())) {
                exists = true
            }
            if (!exists) {
                if let e = email.encodeKeys(), let f = firstName.encodeKeys(), let l = lastName.encodeKeys() {
                    ref.child("users").child(e).setValue(["firstName":f, "lastName":l])//this uploads the user's email, first, and last name.
                } else {
                    exists = true
                }
            }
            self.basicsUploaded = true
        }
        
        
        
        if (detailsAdded) {
            //upload the credit information and stuff
            guard let creditCard = creditCard else {
                print("credit card not okay")
                return false
            }
            
            let number = creditCard.number.encodeKeys()
            let expiry = creditCard.expiry
            let cvv = creditCard.cvv.encodeKeys()
            
            if let exp=expiry.encodeKeys(), let n=number, let c=cvv, let add = address?.encodeKeys(), let post = postalCode?.encodeKeys(), let city = city?.encodeKeys(), let e=email.encodeKeys() {
                let ec = expiry.components(separatedBy: "/")
                print(ec)
                if ((ec.count) != 2){
                    print("expiry not okay")
                    return false
                }
                if (expiry.count==5 && ec[0].isNumber && ec[1].isNumber) {//set the information if the inputs are valid
                    print("uploading")
                    ref.child("users").child(e).child("password").setValue(password)
                    ref.child("users").child(e).child("Payment").setValue(["creditCard":n, "expiry":exp, "cvv":c, "address":add, "postalCode": post, "city":city, "personID": personObject?.personID ?? ""])
                    ref.child("users").child(e).child("owing").setValue("0.0")
                    return true
                } else {
                    exists=true
                }
                
                
            } else {
                exists = true
            }
        }
        return !exists//if exists is false, it was a success.
        
    }
    
    
    
    
    
}
