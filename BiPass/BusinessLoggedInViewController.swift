//
//  BusinessLoggedInViewController.swift
//  BiPass
//
//  Created by Austin Teshuba on 2018-06-14.
//  Copyright © 2018 Austin Teshuba. All rights reserved.
// add some simple dasshboard views on the bottom of the  screen to make the program cleaner. 

import UIKit

class BusinessLoggedInViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var line: UIView!
    @IBOutlet weak var purchaseButton: UIButton!
    @IBOutlet weak var dashboardButton: UIButton!
    @IBOutlet weak var logoView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        line.backgroundColor = orangeColor
        purchaseButton.tintColor = orangeColor
        dashboardButton.tintColor = orangeColor
        titleLabel.text = "Welcome \(currentBusiness?.name ?? "Business")"
        logoView.image = currentBusiness?.logo ?? UIImage(named: "BiPass.png")
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func toPurchase(_ sender: Any) {
        performSegue(withIdentifier: "toPurchase", sender: nil)
    }
    
    @IBOutlet weak var toDashboard: UIButton!
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
