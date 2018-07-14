//
//  VerifyUserViewController.swift
//  BiPass
//
//  Created by Austin Teshuba on 2018-06-15.
//  Copyright © 2018 Austin Teshuba. All rights reserved.
//

import UIKit
import Firebase
class VerifyUserViewController: UIViewController {

    @IBOutlet weak var emailLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        emailLabel.text = personIDs[currentPurchase!.cog!.personID]//print out the email that is on file
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func yes(_ sender: Any) {
        //conduct the transaction
        var ref: FIRDatabaseReference//firebase things. make the reference
        ref = FIRDatabase.database().reference()
        var busBal:Double = 0.0
        var pointsOwing:Double = 0.0
        
        
        let alert = UIAlertController(title: "Alert", message: "Success", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            switch action.style{
            case .default:
                print("default")
                
            case .cancel:
                print("cancel")
                
            case .destructive:
                print("destructive")
                
            }}))
        
        
        
        
        //update the balance and the points owing in the databse
        
        ref.child("businesses").child(currentBusiness!.name).observeSingleEvent(of: .value, with: { (snapshot) in//this checks for duplicates
            if  !snapshot.exists() { return }
            for child in snapshot.children {
                let snap = child as! FIRDataSnapshot
                let key = snap.key
                let val = snap.value
                let strVal = (val as? String)?.decodeKeys()
                
                if (key=="balance") {
                    busBal = Double(val as? String ?? "0.0") ?? 0.0
                    
                    ref.child("businesses").child(currentBusiness!.name).child("balance").setValue(String(busBal + ((currentPurchase?.total) ?? 0.0)))
                    
                    
                    
                    
                } else if (key=="pointsOwing") {
                    pointsOwing = Double(val as? String ?? "0.0") ?? 0.0
                    ref.child("businesses").child(currentBusiness!.name).child("pointsOwing").setValue(String(pointsOwing + ((currentPurchase?.loyaltyPoints) ?? 0.0)))
                }
            }
            
            
        })
        var oweMoney = 0.0//update the user amount owing and points acquired in the database!
        var point = 0.0
        ref.child("users").child(personIDs[currentPurchase!.cog!.personID]!).observeSingleEvent(of: .value, with: { (snapshot) in//this checks for duplicates
            if  !snapshot.exists() { return }
            for child in snapshot.children {
                let snap = child as! FIRDataSnapshot
                let key = snap.key
                let val = snap.value
                
                if (key=="owing") {
                    oweMoney = Double(val as? String ?? "0.0") ?? 0.0
                    ref.child("users").child(personIDs[currentPurchase!.cog!.personID]!).child("owing").setValue(String(oweMoney + ((currentPurchase?.total) ?? 0.0)))
                }
                if (key==currentBusiness!.name) {
                    point = Double(val as? String ?? "0.0") ?? 0.0
                    
                }
                
                
                
                
                
            }
            ref.child("users").child(personIDs[currentPurchase!.cog!.personID]!).child(currentBusiness!.name).setValue(String(point + ((currentPurchase?.loyaltyPoints) ?? 0.0)))
        })
        
        present(alert, animated: true, completion: nil)//show the alert
        
        
    }
    
    @IBAction func no(_ sender: Any) {
        //go back to the start
        performSegue(withIdentifier: "toTheStart", sender: nil)
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
