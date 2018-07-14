//
//  PurchaseViewController.swift
//  BiPass
//
//  Created by Austin Teshuba on 2018-06-14.
//  Copyright © 2018 Austin Teshuba. All rights reserved.
// THis will control the information for a businesses purchases * Untested but should work *

import UIKit

enum TransactionType:Int {//this is an enum that says the transaction is either a refund or a purchase.
    case purchase = 0
    case refund = 1
}


class PurchaseViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet var superview: UIView!
    @IBOutlet weak var loyaltyPoints: UILabel!//outlets for components on the screen
    @IBOutlet weak var total: UILabel!
    @IBOutlet weak var hst: UILabel!
    @IBOutlet weak var subtotal: UILabel!
    @IBOutlet weak var itemTotal: UITextField!
    @IBOutlet weak var purchaseButton: UISegmentedControl!
    //flags for keyboard handling
    var activeField: UITextField? = nil
    var isActive: Bool = false
    
    var subtot:Double = 0.0//start the subtotal at nothing, and the loyalty points at nil
    var points:Double? = nil
    
    var transType:TransactionType = .purchase//the type of transaction starts as a purchase
    override func viewDidLoad() {
        super.viewDidLoad()
        itemTotal.delegate = self
        
        self.superview.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(returnTextView(gesture:))))
        // Do any additional setup after loading the view.
    }
    
    func returnTextView(gesture: UIGestureRecognizer) {//functions for keyboard handling
        guard activeField != nil else {
            return
        }
        
        activeField?.resignFirstResponder()
        activeField = nil
    }
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        activeField = textField
        //lastOffset = self.inputStackView.contentOffset
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        activeField?.resignFirstResponder()
        activeField = nil
        return true
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func segControlChange(_ sender: Any) {//of the segemtn control is changed, change the current transaction type accordingly
        transType = TransactionType(rawValue: purchaseButton.selectedSegmentIndex) ?? .purchase
    }
    
    @IBAction func purchaseConfirmed(_ sender: Any) {//if the confirm button is pressed
        let alert = UIAlertController(title: "Alert", message: "Please enter all information and ensure it is valid.", preferredStyle: UIAlertControllerStyle.alert)//declare an alert in case not all the info is entered
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            switch action.style{//adds how to handle the alert
            case .default:
                print("default")
                
            case .cancel:
                print("cancel")
                
            case .destructive:
                print("destructive")
                
            }}))
        
        if (subtot == 0.0) {//if the subtotal is nothing, show the error.
            present(alert, animated: true, completion: nil)
            return
        }
        
        currentPurchase = Purchase(subtotal: subtot, taxes: subtot*0.13, total: subtot*1.13, loyaltyPoints: points, type: transType)//otherwise, make a new purchase that contains all the info based off the subtotal
        performSegue(withIdentifier: "toIdentify", sender: nil)//to next screen
    }
    
    
    @IBAction func editingChanged(_ sender: Any) {
        print("value changed called")
        subtotal.text = "$\(itemTotal.text ?? "")"//change the subtotal, tax, and total text
        subtot = (Double(itemTotal.text ?? "0.0") ?? 0.0)
        let sub:Double = Double(itemTotal.text ?? "0.0") ?? 0.0
        hst.text = "$\(String(sub*0.13))"
        total.text = "$\(String(sub*1.13))"
        
        if (currentBusiness!.loyalty) {//if there is a loyalty program
            switch currentBusiness!.loyaltyProgram!.pointsUnit {
            case .purchase://if points are awarded per purchase, then change the text accordingly
                points = Double(currentBusiness!.loyaltyProgram!.earningsRate)
                loyaltyPoints.text = String(points ?? 0.0)
            case .dollar://if its per dollar, then assign points on a dollar by dollar basis
                points = Double(currentBusiness!.loyaltyProgram!.earningsRate) * sub//points not earned on taxes
                loyaltyPoints.text = String(points ?? 0.0)
            }
        }
    }
    /*
    @IBAction func itemTotalChanged(_ sender: Any) {//if the price changed, live calculate the other fields below it
        print("value changed called")
        subtotal.text = itemTotal.text//change the subtotal, tax, and total text
        subtot = Double(subtotal.text ?? "0.0") ?? 0.0
        let sub:Double = Double(subtotal.text ?? "0.0") ?? 0.0
        hst.text = String(sub*0.13)
        total.text = String(sub*1.13)
        
        if (currentBusiness!.loyalty) {//if there is a loyalty program
            switch currentBusiness!.loyaltyProgram!.pointsUnit {
            case .purchase://if points are awarded per purchase, then change the text accordingly
                points = Double(currentBusiness!.loyaltyProgram!.earningsRate)
                loyaltyPoints.text = String(points ?? 0.0)
            case .dollar://if its per dollar, then assign points on a dollar by dollar basis
                points = Double(currentBusiness!.loyaltyProgram!.earningsRate) * sub//points not earned on taxes
                loyaltyPoints.text = String(points ?? 0.0)
            }
        }
        
        
    }
 */
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
