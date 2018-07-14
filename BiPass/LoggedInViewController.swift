//
//  LoggedInViewController.swift
//  BiPass
//
//  Created by Austin Teshuba on 2018-06-06.
//  Copyright © 2018 Austin Teshuba. All rights reserved.
// Make some basic dashboard information to make th program cleaner and have the screen have some functionality. SHows after a user is logged in or just made a user

import UIKit

class LoggedInViewController: UIViewController {

    @IBOutlet var superview: UIView!
    @IBOutlet weak var welcomeLabel: UILabel!//make outlets
    @IBOutlet weak var centerXConstraint: NSLayoutConstraint!
    override func viewDidLoad() {
        super.viewDidLoad()
        welcomeLabel.textColor = orangeColor
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func logOut(_ sender: Any) {
        currentUser = nil
        
        
        performSegue(withIdentifier: "logOut", sender: nil)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {//check if this works
        
        let topConst:NSLayoutConstraint = NSLayoutConstraint(item: welcomeLabel, attribute: .top, relatedBy: .equal, toItem: superview, attribute: .top, multiplier: 1.0, constant: 20)//make a new contraint and then animate
        
        UIView.animate(withDuration: 1.0, delay:0.5, animations: {() in
            self.centerXConstraint.isActive = false
            self.view.addConstraint(topConst)
            self.view.layoutIfNeeded()
            
            
        })
        
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
