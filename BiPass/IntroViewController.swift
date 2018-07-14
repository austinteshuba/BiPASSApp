//
//  ViewController.swift
//  BiPass
//
//  Created by Austin Teshuba on 2018-01-20.
//  Copyright © 2018 Austin Teshuba. All rights reserved.
// this is the first view controller class. It simply intorduces users to the program

import UIKit
import Firebase

class IntroViewController: UIViewController {

    @IBOutlet weak var superview: UIView!
    @IBOutlet weak var logo: UIImageView!//outlets for components omn the screen
    @IBOutlet weak var label: UILabel!

    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var press: UILabel!
    //flags
    var pressed: Bool = false//if pressed, dont allow to press again and control the transitions multiple times
    var enable: Bool = false//if enabled, allow for next transitions
 
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        //change initial settings for the textlabel
        label.alpha = 0.0
        //label.translatesAutoresizingMaskIntoConstraints=false
        label.text = "Secure. Fast. BiPASS."
        label.textColor = orangeColor
        
        //set alpha of press
        press.alpha=0.0
        press.tintColor = orangeColor
        press.textColor = orangeColor
        
        var ref: FIRDatabaseReference//make the data base reference
        ref = FIRDatabase.database().reference()
        
        //this is storing all of the usernames and passwords locally. To make this industry ready, we would need secure transmissions and query a database rather thamn store locally. However, since the firebase helper library is asynchronous, its hard to handle how the app will actually work if the user and pass is checked asychronously. This is a next step.
        
        
        ref.child("users").observeSingleEvent(of: .value, with: { (snapshot) in
            // Get list of users from the database
            
            if  !snapshot.exists() { return }
            for child in snapshot.children {
                let snap = child as! FIRDataSnapshot
                let key = snap.key
                if let add = key.lowercased().decodeKeys(){
                    emails.append(add)//add the email to the emails list
                    ref.child("users").child(key).observeSingleEvent(of: .value, with: { (snapshot) in//this checks for duplicates
                        // Get the password for the email from the database
                        
                        if  !snapshot.exists() { return }
                        for child in snapshot.children {
                            let snap = child as! FIRDataSnapshot
                            let key = snap.key
                            print(key)
                            let val = snap.value
                            if (key == "password") {
                                if let v = (val as? String)?.decodeKeys() {
                                    userPass[add] = v//add the password to the dictionary
                                    print(userPass)
                                } else {
                                    print("error decoding")
                                }
                            } else if (key == "personID") {
                                if let v = (val as? String)?.decodeKeys() {
                                    personIDs[v] = add
                                    print("we added an id")
                                }
                            }
                            
                        }
                    
                    
                    })
                }
                else {
                    print("error decoding")
                }
                
            }
            
            
        }) { (error) in
            print(error.localizedDescription)
        }
        
        
        //get all of the businesses information. Same situation as above. Additionally, add a password componenet for the businesses. THis is another next step.
        ref.child("businesses").observeSingleEvent(of: .value, with: { (snapshot) in//this checks for duplicates
            // Get user value
            
            if  !snapshot.exists() { return }
            for child in snapshot.children {
                let snap = child as! FIRDataSnapshot
                let key = snap.key
                if let add = key.lowercased().decodeKeys(){
                    businesses.append(add)//add the business name
                    print("adding businesses")
                    print(businesses)
                    ref.child("businesses").child(add).observeSingleEvent(of: .value, with: { (snapshot) in//this checks for duplicates
                        // Get user value
                        
                        if  !snapshot.exists() { return }//check the businesses email
                        for child in snapshot.children {
                            let snap = child as! FIRDataSnapshot
                            let key = snap.key
                            print(key)
                            let val = snap.value
                            if (key == "email") {
                                if let v = (val as? String)?.decodeKeys() {
                                    busPass[add] = v
                                    print(busPass)//make dict with business name and email
                                } else {
                                    print("error decoding")
                                }
                            }
                            
                        }
                        
                        
                    }) { (error) in
                        print(error.localizedDescription)
                    }
                    
                    
                    
                    
                    
                    
                } else {
                    print("error decoding")
                }
            }
            
            
        }) { (error) in
            print(error.localizedDescription)
        }
        
        
        
        
        /*
        for bus in businesses {
            ref.child("businesses").child(bus).observeSingleEvent(of: .value, with: { (snapshot) in//this checks for duplicates
                // Get user value
                
                if  !snapshot.exists() { return }
                for child in snapshot.children {
                    let snap = child as! FIRDataSnapshot
                    let key = snap.key
                    print(key)
                    print(snap.value)
                    if let add = key.lowercased().decodeKeys(){
                        //businesses.append(add)
                        print("adding emails")
                    } else {
                        print("error decoding")
                    }
                }
                
                
            }) { (error) in
                print(error.localizedDescription)
            }
            
            
        }
        */
        
        
        
        //change color
        
    }
    
    override func viewDidAppear(_ animated: Bool) {//once the view appears, animate things
        super.viewDidAppear(animated)
        UIView.animate(withDuration: 0.5, delay: 0.3, options: [],
                       animations: {
                        self.logo.center.y -= self.label.bounds.height//move the logo to the top
                        self.label.alpha=1.0//show the label
                        
                        
        },
                       completion: nil
        )
        UIView.animate(withDuration: 1.0, delay: 0.8, options: [],
                       animations: {
                        self.press.alpha = 1.0//show the press label
                        
                        
        },
                       completion: {
                        (value: Bool) in
                        self.enable = true//allow for the next set of transitions
        })
    }
    
    
    @IBAction func pressedFunc(_ sender: Any) {
        if (enable) {//only if first set of transitions have completed,
            UIView.animate(withDuration: 1.0, delay: 0.0, options: [],
                           animations: {
                            self.logo.center.y += self.label.bounds.height// move the logo back, make the other elements invisible
                            //self.logo.alpha = 0.0
                            self.label.alpha = 0.0
                            self.press.alpha = 0.0
                            
                            
            },
                           completion: {
                            (value: Bool) in
                            self.performSegue(withIdentifier: "afterIntro", sender: nil)//go to next screen
                            print("Moving on")
            })
            
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

