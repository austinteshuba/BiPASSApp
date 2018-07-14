//
//  BusinessDetailsViewController.swift
//  BiPass
//
//  Created by Austin Teshuba on 2018-06-08.
//  Copyright © 2018 Austin Teshuba. All rights reserved.
// this gets the details for creating a new business

import UIKit
var originalImage:UIImage?//global image


class BusinessDetailsViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {

    @IBOutlet var superview: UIView!
    @IBOutlet weak var businessDescription: UITextView!//outlets for the screen
 
    @IBOutlet weak var logoImage: UIImageView!//logo
    @IBOutlet weak var emailInput: UITextField!
    @IBOutlet weak var phoneInput: UITextField!
    
    //flags
    var activeField: UITextField? = nil
    var isActive: Bool = false
    var keyboardHeight:CGFloat!
    var lastOffset: CGPoint!
    
    let imagePicker:UIImagePickerController = UIImagePickerController() // image picker
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        
        emailInput.delegate = self
        phoneInput.delegate = self
        originalImage = logoImage.image
        // Do any additional setup after loading the view.
        
        
        self.superview.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(returnTextView(gesture:))))
        
    }
    @IBAction func loadPressed(_ sender: Any) {//when load is pressed, present the image picker
        
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        
        present(imagePicker, animated: true, completion: nil)
        
        
    }
    func returnTextView(gesture: UIGestureRecognizer) {//functions for the textfields
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
    
    @IBAction func confirm(_ sender: Any) {
        let alert = UIAlertController(title: "Alert", message: "Please enter all information and ensure it is valid.", preferredStyle: UIAlertControllerStyle.alert)//make alert in case not all info is entered
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            switch action.style{
            case .default:
                print("default")
                
            case .cancel:
                print("cancel")
                
            case .destructive:
                print("destructive")
                
            }}))
        
        if let p=phoneInput.text, let e=emailInput.text, let desc = businessDescription.text, let image = logoImage.image {
            
            
            
            if (p == "" || e == "" || desc == "" || !p.isNumber) {
                present(alert, animated: true, completion: nil)//show error if empty
            } else {
                currentBusiness!.phone = p//the current business details
                currentBusiness!.email = e
                currentBusiness!.description = desc
                currentBusiness!.logo = image
                if (currentBusiness!.loyalty) {
                    performSegue(withIdentifier: "toLoyalty", sender: nil)//if theres loyalty, go there
                } else {
                    performSegue(withIdentifier: "toPayment", sender: nil)// if not, dont!
                }
            }
        } else {
            present(alert, animated: true, completion: nil)//error show error theres an error oops
        }
        
        
        
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            logoImage.contentMode = .scaleAspectFit//import the image
            logoImage.image = pickedImage
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
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

