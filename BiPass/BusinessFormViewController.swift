//
//  BusinessFormViewController.swift
//  BiPass
//
//  Created by Austin Teshuba on 2018-06-08.
//  Copyright © 2018 Austin Teshuba. All rights reserved.
// this is the screen for the business form

import UIKit

class BusinessFormViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var bottomView: UIView!//outlets for the things on the screen
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var stackViewTopConst: NSLayoutConstraint!
    @IBOutlet weak var businessName: UITextField!
    @IBOutlet weak var stackViewBottomConst: NSLayoutConstraint!
    @IBOutlet weak var cityName: UITextField!
    @IBOutlet weak var postalCode: UITextField!
    @IBOutlet weak var address: UITextField!
    @IBOutlet weak var loyalty: UISegmentedControl!
    @IBOutlet weak var payments: UISegmentedControl!
    
    @IBOutlet var superview: UIView!
    //flags
    var activeField: UITextField? = nil
    var isActive: Bool = false
    var keyboardHeight:CGFloat!
    var lastOffset: CGPoint!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func continuePressed(_ sender: Any) {
        let alert = UIAlertController(title: "Alert", message: "Please enter all information", preferredStyle: UIAlertControllerStyle.alert)//make an alert if not all info is entered
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            switch action.style{
            case .default:
                print("default")
                
            case .cancel:
                print("cancel")
                
            case .destructive:
                print("destructive")
                
            }}))
        let alertPick = UIAlertController(title: "Alert", message: "Please enable at least one BiPASS feature", preferredStyle: UIAlertControllerStyle.alert)//if nothing is enabled, make this alert and show it
        alertPick.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            switch action.style{
            case .default:
                print("default")
                
            case .cancel:
                print("cancel")
                
            case .destructive:
                print("destructive")
                
            }}))
        let alertExists = UIAlertController(title: "Alert", message: "Email already exists", preferredStyle: UIAlertControllerStyle.alert)//if email already exists, make and show this error.
        alertExists.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            switch action.style{
            case .default:
                print("default")
                
            case .cancel:
                print("cancel")
                
            case .destructive:
                print("destructive")
                
            }}))
        //if there is valid info, make a curret business object
        if let name = businessName.text, let add = address.text, let post = postalCode.text, let city = cityName.text {
            if (businesses.contains(name)) {
                present(alertExists, animated: true, completion: nil)
                return
            }
            
            
            var pay:Bool = false
            var loy:Bool = false
            if (payments.selectedSegmentIndex==0) {
                pay = true
            }
            if (loyalty.selectedSegmentIndex==0) {
                loy=true
            }
            if (name == "" || post == "" || add == "" || city == "") {
                present(alert, animated: true, completion: nil)
            } else {
                currentBusiness = Business(name: name, postalCode: post, address: add, city: city, payments: pay, loyalty: loy)
                if (isActive==false && (pay || loy)) {
                    //perform segue
                    performSegue(withIdentifier: "toBusinessDetails", sender: nil)//ready to move on
                } else if (isActive==false) {//if they didnt enable antyhing, then shjow an error
                    present(alertPick, animated: true, completion: nil)
                }
            }
            
        } else {//present invalid info alert
            present(alert, animated: true, completion: nil)
        }
        
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewDidLayoutSubviews() {
        businessName.delegate = self
        cityName.delegate = self//set the keyboard delegates
        postalCode.delegate = self
        address.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        self.superview.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(returnTextView(gesture:))))
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: NSNotification.Name.UIKeyboardWillShow,
            object: nil
        )
        
    }
    
    func returnTextView(gesture: UIGestureRecognizer) {//functions for the keyboard recognizers
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
extension BusinessFormViewController {//keyboard handling
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
                    /*
                    self.bottomConst.constant = k+50
                    self.topConst.constant = 50
 */
                    let difference = k - self.bottomView.frame.height
                    self.stackViewTopConst.constant = -difference
                    self.stackViewBottomConst.constant = difference
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
            
            self.stackViewBottomConst.constant = 0//find a way to get this algorithmically so you dont look like a fool
            self.stackViewTopConst.constant = 0
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
