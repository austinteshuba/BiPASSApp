//
//  creditcard.swift
//  BiPass
//
//  Created by Austin Teshuba on 2018-06-05.
//  Copyright © 2018 Austin Teshuba. All rights reserved.
//

import Foundation
import CCValidator//module uses algotihrms to determine if its a legit credit card
import Stripe

public class CreditCard {
    var number:String
    var expiry:String//fields
    var cvv:String
    var type: CreditCardType {
        get {
            let recognizedType:CreditCardType = CCValidator.typeCheckingPrefixOnly(creditCardNumber: number)
            return recognizedType
        }
    }
    
    init (n:String, e:String, c:String) {
        number = n.replacingOccurrences(of: " ", with: "").trimmingCharacters(in: CharacterSet.whitespaces)
        expiry = e.trimmingCharacters(in: CharacterSet.whitespaces)
        cvv = c.trimmingCharacters(in: CharacterSet.whitespaces)
    
    }
    
    func validate()->Bool {//validates if the card is real
        var valid = true//starts as true
        //lets check the credit card number first
        valid = CCValidator.validate(creditCardNumber: number)
        return valid
    }
    
    func createCustomer() {
        //this is where we will create a stripe customer object and get back the customer token. this allows us to securely hold onto customer data
        //first, lets convert the local credit card type tpo the stripe credit card type
        
    
        
        //split the expiry date to month and year
        
        
        
    }
    
    
    
}
