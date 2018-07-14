//
//  LogInViewController.swift
//  BiPass
//
//  Created by Austin Teshuba on 2018-06-14.
//  Copyright © 2018 Austin Teshuba. All rights reserved.
// This allows users to log in

import UIKit
import Foundation
import Firebase

enum UserType {// this is saying there are two types of possible users: businesses or users.
    case business
    case user
}
class LogInViewController: UIViewController {

    @IBOutlet weak var businessName: UITextField!//fields on the screen
    @IBOutlet weak var businessEmail: UITextField!
    @IBOutlet weak var userPassword: UITextField!
    @IBOutlet weak var username: UITextField!
    
    @IBAction func back(_ sender: Any) {//goes back
        performSegue(withIdentifier: "backLogIn", sender: nil)
    }
    var logType:UserType = .user//default type of user is just a regular user. this doesnt do much rn, this is for future
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func logIn(_ sender: Any) {//pressed log in
        let alert = UIAlertController(title: "Alert", message: "Please enter all information", preferredStyle: UIAlertControllerStyle.alert)//make alert in case of invalid information
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            switch action.style{
            case .default:
                print("default")
                
            case .cancel:
                print("cancel")
                
            case .destructive:
                print("destructive")
                
            }}))
        
        let alertIncorrect = UIAlertController(title: "Alert", message: "Invalid information. Please try again.", preferredStyle: UIAlertControllerStyle.alert)//make an alert for incorrect user/pass combo
        alertIncorrect.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            switch action.style{
            case .default:
                print("default")
                
            case .cancel:
                print("cancel")
                
            case .destructive:
                print("destructive")
                
            }}))
        
    
        
        var ref: FIRDatabaseReference//firebase things. make the reference
        ref = FIRDatabase.database().reference()
        
        
        if let bName = businessName.text, let bEmail = businessEmail.text {//if there is a business name and email
            logType = .business//type of user is a business
            if (busPass[bName]==bEmail) {//if the info is valid
                //download the business information
                
                
                /////////download code
                ref.child("businesses").child(bName).observeSingleEvent(of: .value, with: { (snapshot) in//this checks for duplicates
                    // Get user value
                    currentBusiness = Business(name: bName, postalCode: "", address: "", city: "", payments: false, loyalty: false)//make an empty business object
                    if  !snapshot.exists() { return }
                    for child in snapshot.children {
                        let snap = child as! FIRDataSnapshot
                        let key = snap.key
                        let val = snap.value
                        let strVal = (val as? String)?.decodeKeys()
                        
                        if (key=="email") {//populate the business object based on the stuff in the databse
                            currentBusiness!.email = strVal ?? ""
                            //add email
                        } else if (key=="phone") {
                            //add phone
                            currentBusiness!.phone = strVal ?? ""
                        } else if (key=="description") {
                            currentBusiness!.description = strVal ?? ""
                        } else if (key=="address") {
                            currentBusiness!.address = strVal ?? ""
                        } else if (key=="city") {
                            currentBusiness!.city = strVal ?? ""
                        } else if (key=="postalCode") {
                            currentBusiness!.postalCode = strVal ?? ""
                        } else if (key == "logo" && strVal != nil) {
                            currentBusiness!.logo = nil
                            let url = URL(string: strVal!)
                            let data = try? Data(contentsOf: url!) //make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
                            currentBusiness!.logo = UIImage(data: data!)
                            //we need to downlaod the image
                        } else if (key=="payment") {
                            if (strVal=="yes") {
                                currentBusiness!.payments = true
                            } else if (strVal=="no") {
                                currentBusiness!.payments = false
                            }
                        } else if (key=="loyalty") {//if there is a loyalty program enabled
                            if (strVal=="yes") {
                                currentBusiness!.loyalty = true
                            } else if (strVal=="no") {
                                currentBusiness!.loyalty = false
                            }
                        } else if (key=="Loyalty") {
                            let newVal = val as? [String:Any?]//parse the value into a dictionary
                            
                            if let v = newVal {//if that worked, lets start to populat the loyalty program
                                currentBusiness!.loyaltyProgram = Loyalty(name: v["name"] as? String ?? "", pointsUnit: .dollar, earningsRate: Int(v["earningRate"] as? String ?? "0") ?? 0, tiers: Int(v["tiers"] as? String ?? "0") ?? 0, tierOne: nil, tierTwo: nil, tierThree: nil)
                                //make the loyalty program based on info in the dictionary. This is a risky line and might crash, but if it does, something is likelye wrong with the database
                                if (v["pointsUnit"] as? String == "purchase") {
                                    currentBusiness!.loyaltyProgram?.pointsUnit = .purchase
                                }
                                if let t1 = v["tierOne"] as? [String:String] {//get the tiers if they are there!
                                    currentBusiness?.loyaltyProgram?.tierOne = LoyaltyTier(name: t1["name"] ?? "", multiplier: Double(t1["pointsMultiplier"] ?? "1.0") ?? 1.0, value: Int(t1["value"] ?? "0") ?? 0, tierNumber: 1, other: t1["otherBenefits"])
                                }
                                if let t2 = v["tierTwo"] as? [String:String] {
                                    currentBusiness?.loyaltyProgram?.tierTwo = LoyaltyTier(name: t2["name"] ?? "", multiplier: Double(t2["pointsMultiplier"] ?? "1.0") ?? 1.0, value: Int(t2["value"] ?? "0") ?? 0, tierNumber: 2, other: t2["otherBenefits"])
                                }
                                if let t3 = v["tierThree"] as? [String:String] {
                                    currentBusiness?.loyaltyProgram?.tierThree = LoyaltyTier(name: t3["name"] ?? "", multiplier: Double(t3["pointsMultiplier"] ?? "1.0") ?? 1.0, value: Int(t3["value"] ?? "0") ?? 0, tierNumber: 3, other: t3["otherBenefits"])
                                }
                            } else {
                                print("loyalty parse error")
                            }
                            
                            
                            
                        }
                        
                        
                        
                        }

                }) { (error) in
                    print(error.localizedDescription)
                }
                
                //////////////end download code
                
                
                
                
                
                
                performSegue(withIdentifier: "toBusiness", sender: nil)//go to business
            } else {
                //incorrect password user combo. show an error.
                self.present(alertIncorrect, animated:true, completion:nil)
            }
        } else{
            if let password = userPassword.text, let user = username.text {//if the password and username exist
                if (userPass[user] == password) {//if the combo is correct
                    //download the user information
                    currentUser = User(email: "", firstName: "", lastName: "", personObject: nil)//make current user empty
                    ref.child("users").child(user.encodeKeys()!).observeSingleEvent(of: .value, with: { (snapshot) in//this checks for duplicates
                        // Get user value
                        
                        if  !snapshot.exists() { return }
                        for child in snapshot.children {
                            let snap = child as! FIRDataSnapshot
                            let key = snap.key
                            let val = snap.value
                            let strVal = (val as? String)?.decodeKeys()
                            
                            if (key=="firstName") {//populate the current user based on info in the database
                                currentUser?.firstName = strVal ?? ""
                            } else if (key=="lastName") {
                                currentUser?.lastName = strVal ?? ""
                            } else if (key=="password") {
                                currentUser?.password = strVal ?? ""
                                
                            } else if (key=="personID" && strVal != "") {
                                currentUser?.personObject = CogPerson(pID: strVal ?? "")
                            } else if (key=="Payment") {//get the payment info too!
                                let newVal = val as? [String: String]
                                if let v = newVal {
                                    currentUser?.address = v["address"] ?? ""
                                    currentUser?.city = v["city"] ?? ""
                                    currentUser?.creditCard = CreditCard(n: v["creditCard"] ?? "", e: v["expiry"] ?? "", c: v["cvv"] ?? "")
                                    currentUser?.postalCode = v["postalCode"] ?? ""
                                }
                            }
                            
                            
                            
                            
                            
                            
                        }
                    })
                    
                    performSegue(withIdentifier: "toUser", sender: nil)//go to user screen
                } else {
                    //incorrect combo. present an error.
                     self.present(alertIncorrect, animated:true, completion:nil)
                }
                
                
                
            } else {
                //this is literally nothing. present an error.
                self.present(alert, animated: true, completion: nil)
            }
            //take a look for the user
        }
        
        
        
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}





/* this was anoter method of getting the loyalty tiers. not smart lmao
 let newRef = FIRDatabase.database().reference()
 newRef.child("businesses").child(bName).child("Loyalty").observeSingleEvent(of: .value, with: { (snapshot) in
 if  !snapshot.exists() { return }
 for child in snapshot.children {
 let snap = child as! FIRDataSnapshot
 let key = snap.key
 let val = snap.value
 let strVal = (val as? String)?.decodeKeys()
 
 if (key=="name") {
 loyaltyProgram.name = strVal ?? ""
 } else if (key=="pointsUnit") {
 if (strVal == "purchase") {
 loyaltyProgram.pointsUnit = .purchase
 }
 } else if (key=="tiers") {
 loyaltyProgram.tiers = Int(strVal ?? "0") ?? 0
 //gotta get those tiers!
 /*
 var tier1:LoyaltyTier = LoyaltyTier(name: "", multiplier: 1.0, value: 0, tierNumber: 1, other: nil)
 newRef.child("businesses").child(bName).child("Loyalty").child("tierOne").observeSingleEvent(of: .value, with: { (snapshot) in
 if  !snapshot.exists() { return }
 for child in snapshot.children {
 let snap = child as! FIRDataSnapshot
 let key = snap.key
 let val = snap.value
 let strVal = val as? String
 
 if (key=="name") {
 tier1.name = strVal ?? ""
 } else if (key=="pointsMultiplier") {
 tier1.pointsMultiplier = Double(strVal ?? "1.0") ?? 1.0
 } else if (key=="value") {
 tier1.pointValue = Int(strVal ?? "0") ?? 0
 } else if (key=="otherBenefits") {
 tier1.otherBenefits = strVal
 }
 }
 })
 */
 
 
 } else if (key=="earningRate") {
 loyaltyProgram.earningsRate = Int(strVal ?? "0") ?? 0
 } else if (key=="Loyalty") {
 
 }
 }
 
 
 
 
 
 
 // Get user value
 })
 
 
 */


