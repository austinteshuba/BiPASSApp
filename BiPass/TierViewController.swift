//
//  TierViewController.swift
//  BiPass
//
//  Created by Austin Teshuba on 2018-06-11.
//  Copyright © 2018 Austin Teshuba. All rights reserved.
// ADD KEYBOARD HANDLING
//this is a view controller to handle adding information about the loyalty tiers

import UIKit

class TierViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate {

    @IBOutlet var superview: UIView!
    @IBOutlet weak var tierDescription: UITextView!//outlets for the things on the screen
    @IBOutlet weak var pointsMultiplier: UITextField!
    @IBOutlet weak var tierName: UITextField!
    @IBOutlet weak var pointsThreshold: UITextField!
    @IBOutlet weak var tierClicker: UISegmentedControl!
    
    //flags
    var activeField: UITextField? = nil
    var isActive: Bool = false
    var keyboardHeight:CGFloat!
    var lastOffset: CGPoint!
    
    //var tiers: [LoyaltyTier] = []//contains the tiers
    
    @IBOutlet weak var topConstraint: NSLayoutConstraint!//contraints for the stack view that contains the input fields
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    var currentTierNum:Int = 1//current tier is the first one
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tierClicker.addTarget(self, action: Selector(("newTierControlled:")), for:.valueChanged)
        
        pointsMultiplier.delegate = self
        pointsThreshold.delegate = self
        tierName.delegate = self
        tierDescription.delegate = self//set the delegates for text field and text view
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)//adds observers for when things
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        self.superview.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(returnTextView(gesture:))))
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: NSNotification.Name.UIKeyboardWillShow,
            object: nil
        )
        
        currentTierNum = tierClicker.selectedSegmentIndex+1
        let numberOfSegments = (currentBusiness?.loyaltyProgram?.tiers)!
        if (numberOfSegments<3) {//set the right amount of segements according to the amount of tier inputs
            tierClicker.removeSegment(at: 2, animated: false)
        }
        if (numberOfSegments<2) {
            tierClicker.removeSegment(at: 1, animated: false)
        }
        // Do any additional setup after loading the view.
    }

    
    
    @IBAction func continuePressed(_ sender: UISegmentedControl) {
        storeCurrentInfo()
        if (((currentBusiness?.loyaltyProgram?.tierOne?.name.characters.count) ?? 0) > 0) {//if valid first tier, move on.
            performSegue(withIdentifier: "toThePayment", sender: nil)
        } else {
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
            present(alert, animated: true, completion: nil)
        }
        
        
        
        
    }
    func storeCurrentInfo() {
        //store the information entered
        var currentTier:LoyaltyTier? = currentBusiness?.loyaltyProgram?.tierOne
        if (currentTierNum==2) {
            currentTier = currentBusiness?.loyaltyProgram?.tierTwo
        } else if (currentTierNum==3) {
            currentTier = currentBusiness?.loyaltyProgram?.tierThree
        }
        if let currentTier = currentTier {
            currentTier.name = tierName.text ?? ""
            currentTier.pointsMultiplier = Double((pointsMultiplier.text ?? "")!) ?? 1.0
            currentTier.pointValue = Int((pointsThreshold.text ?? "")!) ?? 0
            currentTier.otherBenefits = tierDescription.text
            
            if (currentTierNum==1) {
                currentBusiness?.loyaltyProgram?.tierOne = currentTier
            } else if (currentTierNum==2) {
                currentBusiness?.loyaltyProgram?.tierTwo = currentTier
            } else if (currentTierNum==3) {
                currentBusiness?.loyaltyProgram?.tierThree = currentTier
            }
            
        } else {
            if let name = tierName.text, let multiplier = Double(pointsMultiplier.text ?? ""), let value = Int(pointsThreshold.text ?? "") {
                currentTier = LoyaltyTier(name: name, multiplier: multiplier, value: value, tierNumber: currentTierNum, other: tierDescription.text)
                if (currentTierNum==1) {
                    currentBusiness?.loyaltyProgram?.tierOne = currentTier
                } else if (currentTierNum==2) {
                    currentBusiness?.loyaltyProgram?.tierTwo = currentTier
                } else if (currentTierNum==3) {
                    currentBusiness?.loyaltyProgram?.tierThree = currentTier
                }
            }
            
        }
    }
    
    @IBAction func newTierControlled(_ sender: Any) {
        
        //store the information entered
        storeCurrentInfo()
        
        
        
        
        //set the tier number properly and get ready for more input
        currentTierNum = tierClicker.selectedSegmentIndex+1
        var currentTier = currentBusiness?.loyaltyProgram?.tierOne
        if (currentTierNum==2) {
            currentTier = currentBusiness?.loyaltyProgram?.tierTwo
        } else if (currentTierNum==3) {
            currentTier = currentBusiness?.loyaltyProgram?.tierThree
        }
        guard let t = currentTier else {
            tierDescription.text = nil
            pointsMultiplier.text = nil
            tierName.text = nil
            pointsThreshold.text = nil
            return
        }
        tierDescription.text = t.otherBenefits
        pointsMultiplier.text = String(t.pointsMultiplier)
        pointsThreshold.text = String(t.pointValue)
        tierName.text = t.name
        
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

    func returnTextView(gesture: UIGestureRecognizer) {
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
}
extension TierViewController {//keyboard handling
    func keyboardWillShow(notification: NSNotification) {
        if (isActive==false) {//if not active
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
                    self.bottomConstraint.constant = k+20
                    self.topConstraint.constant = 0
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
            
            self.bottomConstraint.constant = 100//find a way to get this algorithmically so you dont look like a fool
            self.topConstraint.constant = 20
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
