//
//  LoyaltySetUpViewController.swift
//  BiPass
//
//  Created by Austin Teshuba on 2018-06-08.
//  Copyright © 2018 Austin Teshuba. All rights reserved.
// this is a screen for set up loyalty programs

import UIKit

class LoyaltySetUpViewController: UIViewController, UITextFieldDelegate {

    //flags
    var activeField: UITextField? = nil
    var isActive: Bool = false
    var keyboardHeight:CGFloat!
    var lastOffset: CGPoint!
    
    @IBOutlet var superview: UIView!
    @IBOutlet weak var name: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    @IBOutlet weak var basedOn: UISegmentedControl!
    
    @IBOutlet weak var topConst: NSLayoutConstraint!//constraint outlets
    @IBOutlet weak var bottomConst: NSLayoutConstraint!
    @IBOutlet weak var tiersNumber: UISegmentedControl!
    @IBOutlet weak var earnRate: UITextField!//text field
    
    @IBOutlet weak var pointsPer: UILabel!
    override func viewDidAppear(_ animated: Bool) {
        
        earnRate.delegate = self
        name.delegate = self//text fiueld delegates
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)//set gesture recognizers for the keyboard
        
        self.superview.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(returnTextView(gesture:))))
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: NSNotification.Name.UIKeyboardWillShow,
            object: nil
    )}
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func segmentChange(_ sender: Any) {
        if (basedOn.selectedSegmentIndex==0) {
            pointsPer.text = "Points per purchase:"
        } else {
            pointsPer.text = "Points per dollar:"
        }
    }
    
    @IBAction func confirm(_ sender: Any) {
        let alert = UIAlertController(title: "Alert", message: "Please enter all information and ensure it is valid.", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            switch action.style{
            case .default:
                print("default")
                
            case .cancel:
                print("cancel")
                
            case .destructive:
                print("destructive")
                
            }}))
        
        
        if let name = name.text, let earnRate = earnRate.text {//if theres info, maake a loyalty program
            if (earnRate.isNumber) {
                let t:PointsPer
                
                if (basedOn.selectedSegmentIndex == 0) {
                    t = .purchase
                } else {
                    t = .dollar
                }
                
                
                currentBusiness!.loyaltyProgram = Loyalty(name: name, pointsUnit: t, earningsRate: Int(earnRate)!, tiers: tiersNumber.selectedSegmentIndex+1, tierOne: nil, tierTwo: nil, tierThree: nil)
                print("made the program")
                performSegue(withIdentifier: "toTiers", sender: nil)
            }
            else {
                self.present(alert, animated: true, completion: nil)//no info? show an error
            }
        } else {
            self.present(alert, animated: true, completion: nil)
        }
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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
extension LoyaltySetUpViewController {//keyboard handling
    func keyboardWillShow(notification: NSNotification) {
        if (isActive==false) {
            //print("This happened")//test to see if this function was called. the adjustment for the keyboard isnt working.
            var keyboardHeight:CGFloat? = nil
            var keyboardRectangle:CGRect? = nil
            if let keyboardFrame: NSValue = notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue {
                //print("MEEEEEP")
                keyboardRectangle = keyboardFrame.cgRectValue
                keyboardHeight = keyboardRectangle!.height//this should never crash because we have already given this a value in the line above.
            }
            
            
            if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
                //print("MEEEEEP")
                keyboardHeight = keyboardSize.height
                //print(keyboardHeight)
                
                if let k = keyboardHeight {
                    //self.bottomConst.constant = ((superview.frame.maxY - k) - bottomStack.frame.maxY)+30//find a way to get this algorithmically so you dont look like a fool
                    self.bottomConst.constant = k+50
                    self.topConst.constant = 50
                    UIView.animate(withDuration: 0.3, animations: {
                        self.view.layoutIfNeeded()
                    })
                } else {
                    return
                }
                // so increase contentView's height by keyboard height
                
                
            }
            isActive=true
        }
        
    }
    
    func keyboardWillHide(notification: NSNotification) {
        //print("yes")
        if (isActive) {
            
            self.bottomConst.constant = 150//find a way to get this algorithmically so you dont look like a fool
            self.topConst.constant = 150
            UIView.animate(withDuration: 0.3) {
                self.view.layoutIfNeeded()
                //self.scrollView.contentOffset = self.lastOffset
            }
            keyboardHeight = nil
            isActive=false
            //print("yes")
            
        }
    }
}

