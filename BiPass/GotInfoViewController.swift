//
//  GotInfoViewController.swift
//  Alamofire
//
//  Created by Austin Teshuba on 2018-06-15.
//  This just waits until there is a value for cog person. a stupid byproduct of force asynchronous uploading in firebase.

import UIKit

class GotInfoViewController: UIViewController {
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    var timer:Timer = Timer()
    var cogPerson:CogPerson? = nil
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = .gray//this all sets up the activity montior.
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        scheduledTimerWithTimeInterval()
        // Do any additional setup after loading the view.
    }
    func scheduledTimerWithTimeInterval(){
        // Scheduling timer to Call the function "check val" with the interval of 0.5 seconds
        timer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(self.check), userInfo: nil, repeats: true)
    }
    func check(){
        if (currentPurchase?.cog != nil) {
            
            activityIndicator.stopAnimating()//stops moving the circle
            timer.invalidate()//turn off timer
            performSegue(withIdentifier: "toCheck", sender: nil)
        }
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
