//
//  SelectViewController.swift
//  BiPass
//
//  Created by Austin Teshuba on 2018-01-20.
//  Copyright © 2018 Austin Teshuba. All rights reserved.
// this is where people select where they are going (join, business sign up, or log in

import UIKit

class SelectViewController: UIViewController {

    @IBOutlet var superview: UIView!
    @IBOutlet weak var joinButton: UIButton!//outlets
    
    @IBOutlet weak var line: UIView!
    @IBOutlet weak var oldLogo: UIImageView!
    @IBOutlet weak var logo: UIImageView!
    @IBOutlet weak var logInButton: UIButton!
    @IBOutlet weak var testButton: UIButton!
    var enable:Bool = false
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var centerYConstraint: NSLayoutConstraint!
    @IBOutlet weak var bottomView: UIView!
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
     
        self.centerYConstraint.priority=1
        let newHorizontal: NSLayoutConstraint = NSLayoutConstraint(item: oldLogo, attribute: .centerY, relatedBy: .equal, toItem: logo, attribute: .centerY, multiplier: 1, constant: 0)//make constraint for animation
        newHorizontal.isActive = true
        UIView.animate(withDuration: 1.0, delay: 0.3, options: [], animations: {
            
            print(self.oldLogo.center.y)
            print(self.logo.center.y)
            self.superview.layoutIfNeeded()
        }, completion: {
            (value: Bool) in
            
        })
        
        UIView.animate(withDuration: 1.0, delay: 1.3, options: [], animations: {
            self.topView.alpha=0//make things visible
            self.bottomView.alpha=1
            self.joinButton.alpha = 1;
            self.logInButton.alpha = 1
            self.testButton.alpha = 1
            self.logo.alpha=1
            self.line.alpha=1
        }, completion: {
            (value: Bool) in
            
            self.enable = true
        })
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        joinButton.tintColor = orangeColor//change the color of the text
        logInButton.tintColor = orangeColor
        testButton.tintColor = orangeColor
        line.backgroundColor = orangeColor
        // Do any additional setup after loading the view.
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func join(_ sender: Any) {//if join, set up the animations and go to join
        if (enable) {
            //perform segue
            UIView.animate(withDuration: 1.0, delay: 0.0, options: [], animations: {
                self.topView.alpha=0
                self.bottomView.alpha=0
                self.joinButton.alpha=0
                self.logInButton.alpha=0
                self.testButton.alpha=0
                self.logo.alpha=0
            }, completion: {
            (value: Bool) in
            self.performSegue(withIdentifier: "toJoin", sender: nil)
        })
    }
    }

    @IBAction func test(_ sender: Any) {//if you press business log in, go there (used to be called test)
        if (enable) {
            //perform segue
            performSegue(withIdentifier: "toTest", sender: nil)
        }
    }
    @IBAction func logIn(_ sender: Any) {//if you press log in, go there.
        if (enable) {
            //perform segue
            performSegue(withIdentifier: "toLogIn", sender: nil)
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
