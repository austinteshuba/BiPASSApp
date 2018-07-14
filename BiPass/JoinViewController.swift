//
//  JoinViewController.swift
//  BiPass
//
//  Created by Austin Teshuba on 2018-01-21.
//  Copyright © 2018 Austin Teshuba. All rights reserved.
//this view controller is where users will first join the program

import UIKit

class JoinViewController: UIViewController, UITextFieldDelegate {//inherits from the text field delegate, which allows us to access proerties of the keyboard
    @IBOutlet weak var line: UIView!//outlets for the stuff on the screen

    @IBOutlet weak var bottomConst: NSLayoutConstraint!//constraint for the bottom of the inputstackview
    
    @IBOutlet weak var emailAddress: UITextField!
    @IBOutlet weak var lastName: UITextField!
    @IBOutlet weak var firstName: UITextField!
    @IBOutlet weak var inputStackView: UIStackView!
    @IBOutlet weak var pressText: UILabel!
    @IBOutlet weak var explainText: UILabel!
    @IBOutlet var superview: UIView!
    @IBOutlet weak var trailingMarginConstraint: NSLayoutConstraint!
    @IBOutlet weak var leadingMargingConstraint: NSLayoutConstraint!
    @IBOutlet weak var centerYConstraint: NSLayoutConstraint!
    @IBOutlet weak var joinLabel: UILabel!
    
    @IBOutlet weak var bottomStack: UIStackView!
    @IBOutlet weak var topConst: NSLayoutConstraint!//this is for the continue button
    
    @IBAction func back(_ sender: Any) {//gesture controller.
        performSegue(withIdentifier: "joinBack", sender: nil)
    }
    //flags
    var activeField: UITextField? = nil
    var isActive: Bool = false
    var keyboardHeight:CGFloat!
    var lastOffset: CGPoint!
    
    override func viewDidLayoutSubviews() {
        emailAddress.delegate = self//set the delegates
        lastName.delegate = self
        firstName.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)//add gesture recognizers for the text field
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        self.superview.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(returnTextView(gesture:))))
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: NSNotification.Name.UIKeyboardWillShow,
            object: nil
        )
        
        
        let newTrailing: NSLayoutConstraint = NSLayoutConstraint(item: line, attribute: .width, relatedBy: .equal, toItem: superview, attribute: .width, multiplier: 1, constant: -20)
        let newLeading: NSLayoutConstraint = NSLayoutConstraint(item: line, attribute: .leading, relatedBy: .equal, toItem: superview, attribute: .leading, multiplier: 1, constant: 10)
        let newY:NSLayoutConstraint = NSLayoutConstraint(item: line, attribute: .top, relatedBy: .equal, toItem: joinLabel, attribute: .bottom, multiplier: 1, constant: 10)//make new constraints for the animation
        
        trailingMarginConstraint.priority = 1 // existing constraints have literally no priority. system will break them ASAP (its 1/1000)
        leadingMargingConstraint.priority = 1
        centerYConstraint.priority=1
        newTrailing.isActive = true//set the contraints to active
        newLeading.isActive = true
        newY.isActive = true
        
        //animate the labels and stuff
        UIView.animate(withDuration: 1.0, delay: 0.3, options: [], animations: {
            self.superview.layoutIfNeeded()
            self.joinLabel.alpha=1
            
            
        }, completion: nil)
        UIView.animate(withDuration:0.5, delay: 1.3, options: [], animations: {
            self.explainText.alpha=1
            self.pressText.alpha=1
            
        }, completion: nil)
        UIView.animate(withDuration:0.5, delay: 1.8, options: [], animations: {
            self.inputStackView.alpha=1
            
        }, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Do any additional setup after loading the view.
    }
    
    func returnTextView(gesture: UIGestureRecognizer) {//functions for the textfields
        guard activeField != nil else {
            return
        }
        
        activeField?.resignFirstResponder()
        activeField = nil
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    
    
    
    @IBAction func continueClicked(_ sender: Any) {//if continue is clicked, move t next screen
        if (isActive==false) {
            let alert = UIAlertController(title: "Alert", message: "Please enter all information.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                switch action.style{
                case .default:
                    print("default")
                    
                case .cancel:
                    print("cancel")
                    
                case .destructive:
                    print("destructive")
                    
                    
                }}))//make alerts for not entering all the info
            
            let alertExists = UIAlertController(title: "Alert", message: "Email Already Exists", preferredStyle: UIAlertControllerStyle.alert)
            alertExists.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                switch action.style{
                case .default:
                    print("default")
                    
                case .cancel:
                    print("cancel")
                    
                case .destructive:
                    print("destructive")
                    
                    
                }}))//make alert for entering existing email 
            
            
            //get info
            var e:String = ""
            var f:String = ""
            var l:String = ""
            if let email = emailAddress.text {
                e = email
                if (email == "") {
                    self.present(alert, animated: true, completion: nil)
                    return//PLEASE ENTER ALL OF THE INFORMATION
                }
            } else {
                self.present(alert, animated: true, completion: nil)
                return//PLEASE ENTER ALL OF THE INFORMATION
            }
            
            if let first = firstName.text {
                f = first
                if (first == "") {
                    self.present(alert, animated: true, completion: nil)
                    return//PLEASE ENTER ALL OF THE INFORMATION
                }
            } else {
                self.present(alert, animated: true, completion: nil)
                return
            }
            
            if let last = lastName.text {
                l = last
                if (last=="") {
                    self.present(alert, animated: true, completion: nil)
                    return//PLEASE ENTER ALL OF THE INFORMATION
                }
            } else {
                self.present(alert, animated: true, completion: nil)
                return
            }
            
            currentUser = User(email: e,firstName: f,lastName: l, personObject: nil)
            
            let success = currentUser!.upload()
            
            if (success){
                performSegue(withIdentifier: "toCamera", sender: nil)
            }
            else {
                self.present(alertExists, animated: true, completion: nil)
            }
            
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
extension JoinViewController {//keyboard handling
    func keyboardWillShow(notification: NSNotification) {
        if (isActive==false) {
            //print("This happened")//test to see if this function was called. the adjustment for the keyboard isnt working.
            var keyboardHeight:CGFloat? = nil;
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
                    self.bottomConst.constant = ((superview.frame.maxY - k) - bottomStack.frame.maxY)+30//find a way to get this algorithmically so you dont look like a fool
                    self.topConst.constant = ((superview.frame.maxY - k) - bottomStack.frame.maxY)+30
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
            
            self.bottomConst.constant = 30//find a way to get this algorithmically so you dont look like a fool
            self.topConst.constant = 30
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
