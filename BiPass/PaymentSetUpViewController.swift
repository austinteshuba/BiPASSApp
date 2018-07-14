//
//  PaymentSetUpViewController.swift
//  BiPass
//
//  Created by Austin Teshuba on 2018-06-08.
//  Copyright © 2018 Austin Teshuba. All rights reserved.
// Terms and conditions page

import UIKit

class PaymentSetUpViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func continuePressed(_ sender: Any) {//if they say they agree to the terms, go to the next page
        print(currentBusiness?.upload())
        performSegue(withIdentifier: "toBusinessLogIn", sender: nil)//go to the next page
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
