//
//  BusinessJoinViewController.swift
//  BiPass
//
//  Created by Austin Teshuba on 2018-06-08.
//  Copyright © 2018 Austin Teshuba. All rights reserved.
//  business join controller. this is the intro to joining businesses

import UIKit

class BusinessJoinViewController: UIViewController {

    @IBOutlet weak var lineTrailing: NSLayoutConstraint!//outlets from the screen
    @IBOutlet weak var lineLeading: NSLayoutConstraint!
    @IBOutlet weak var LineVerticalConst: NSLayoutConstraint!
    @IBOutlet weak var line: UIView!
    @IBOutlet weak var coffeePicture: UIImageView!
    @IBOutlet weak var businessLabel: UILabel!
    @IBOutlet weak var buttonOutlet: UIButton!
    @IBOutlet weak var letsLabel: UILabel!
    @IBOutlet weak var textImage: UIImageView!
    @IBOutlet weak var pressToJoin: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    @IBAction func continuePressed(_ sender: Any) {
        performSegue(withIdentifier: "toBusinessJoin", sender: nil)//to next view controller
    }
    
    @IBAction func back(_ sender: Any) {//goes back
        performSegue(withIdentifier: "backBusiness", sender: nil)
    }
    override func viewDidAppear(_ animated: Bool) {
        let newTopConst:NSLayoutConstraint = NSLayoutConstraint(item: line, attribute: .top, relatedBy: .equal, toItem: businessLabel, attribute: .bottom, multiplier: 1.0, constant: 5.0)//make a new contraint for the line and business label
        UIView.animate(withDuration: 0.5, delay: 0.3, animations: {() in
            self.LineVerticalConst.isActive = false//animate the screen
            self.lineLeading.constant = 5
            self.lineTrailing.constant = 5
            self.view.addConstraint(newTopConst)
            self.view.layoutIfNeeded()
            
            
        })
        UIView.animate(withDuration: 0.5, delay:0.8, animations: {() in
            //make things visible
            self.coffeePicture.alpha=1.0
            self.businessLabel.alpha=1.0
            self.buttonOutlet.isEnabled = true
            self.letsLabel.alpha=1.0
            self.letsLabel.textColor = orangeColor
            self.pressToJoin.textColor = orangeColor
            self.textImage.alpha=1.0
            self.pressToJoin.alpha=1.0
            
        })
        
        
        
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
