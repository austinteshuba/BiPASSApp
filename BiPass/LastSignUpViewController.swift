//
//  LastSignUpViewController.swift
//  BiPass
//
//  Created by Austin Teshuba on 2018-06-04.
//  Copyright © 2018 Austin Teshuba. All rights reserved.
// last sign up view controller

import UIKit

class LastSignUpViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var creditCard: UITextField!//outlets for the inputes
    @IBOutlet weak var expiry: UITextField!
    @IBOutlet weak var cvv: UITextField!
    @IBOutlet weak var address: UITextField!
    @IBOutlet weak var city: UITextField!
    @IBOutlet weak var postalCode: UITextField!
    
    @IBOutlet weak var password: UITextField!
    @IBOutlet var superview: UIView!
    @IBOutlet weak var line: UIView!
    @IBOutlet weak var addedInfoLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var continueLabel: UILabel!
    
    @IBOutlet weak var topConst: NSLayoutConstraint!
    @IBOutlet weak var bottomStack: UIStackView!
    @IBOutlet weak var bottomConst: NSLayoutConstraint!
    //flags
    var activeField: UITextField? = nil
    var isActive: Bool = false
    var keyboardHeight:CGFloat!
    var lastOffset: CGPoint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        line.backgroundColor=orangeColor
        addedInfoLabel.textColor = orangeColor
        titleLabel.textColor = orangeColor
        continueLabel.textColor = orangeColor
        // Do any additional setup after loading the view.
    }
    override func viewDidLayoutSubviews() {
        creditCard.delegate = self
        expiry.delegate = self
        cvv.delegate = self
        address.delegate = self
        city.delegate = self//set the delegates
        postalCode.delegate = self
        password.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)//add the gesture recognizers
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        self.superview.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(returnTextView(gesture:))))
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: NSNotification.Name.UIKeyboardWillShow,
            object: nil
        )
        
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

    @IBAction func continuePressed(_ sender: Any) {
        let alert = UIAlertController(title: "Alert", message: "Please enter all information", preferredStyle: UIAlertControllerStyle.alert)//make alert for invalid information
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            switch action.style{
            case .default:
                print("default")
                
            case .cancel:
                print("cancel")
                
            case .destructive:
                print("destructive")
                
            }}))
        guard let n = creditCard.text, let e = expiry.text, let c=cvv.text else {
            self.present(alert, animated: true, completion:nil)//if invalid input, show an error
            return
        }
        currentUser?.creditCard = CreditCard(n: n, e: e, c: c)//make a credit card object based off unwrapped pbject
        currentUser?.address = address.text//set current business details to the input
        currentUser?.postalCode = postalCode.text
        currentUser?.city = city.text
        currentUser?.password = password.text
        
         let alertValid = UIAlertController(title: "Alert", message: "Please enter all information and ensure it is valid.", preferredStyle: UIAlertControllerStyle.alert)//nvalid info alert
        alertValid.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            switch action.style{
            case .default:
                print("default")
                
            case .cancel:
                print("cancel")
                
            case .destructive:
                print("destructive")
                
            }}))
        
        
        if (currentUser?.detailsAdded == true) {//upload the current user
            let stat = currentUser!.upload()
            if (stat) {
                //go to next screen
                performSegue(withIdentifier: "loggedIn", sender: nil)//go to next screen
            } else {
                print("something went wrong")
                self.present(alertValid, animated: true, completion:nil)//shw invalid info error
                
            }
        }else {
            //show an invalid info alert
            self.present(alertValid, animated: true, completion:nil)
            
        }
        
        
        
        
        
        
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
extension LastSignUpViewController {//keyboard handling
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
                print(self.bottomConst.constant)
                print(bottomStack.frame.maxY)
                print(((superview.frame.maxY - keyboardHeight!) - bottomStack.frame.maxY))
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
