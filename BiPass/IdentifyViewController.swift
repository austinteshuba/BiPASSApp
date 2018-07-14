//
//  IdentifyViewController.swift
//  BiPass
//
//  Created by Austin Teshuba on 2018-06-14.
//  Copyright © 2018 Austin Teshuba. All rights reserved.
// This will identify a user.

//Problems: 

import UIKit

class IdentifyViewController: UIViewController {
    @IBOutlet weak var previewView: UIView!//outlets for things on the screen
    @IBOutlet weak var photoCapture: UIButton!
    
    @IBOutlet weak var photoButton: UIView!
    
    @IBOutlet weak var toggleCameraButton: UIButton!
    let cameraController = CameraController()//this controls the logic for taking pics
    override func viewDidLoad() {
        super.viewDidLoad()
        photoButton.backgroundColor = orangeColor

        // Do any additional setup after loading the view.
        
        func configureCameraController() {//this will put the preview feed on the preview view
            cameraController.prepare {(error) in
                if let error = error {
                    print(error)
                }
                
                try? self.cameraController.displayPreview(on: self.previewView)//try to display the camera on the preview view
            }
        }
        
        configureCameraController()//call nested function
    }
    @IBAction func liftFinger(_ sender: Any) {
        photoButton.backgroundColor = orangeColor
    }
    @IBAction func capture(_ sender: Any) {//this captures the picture
        photoButton.backgroundColor = clickedColor
        cameraController.captureImage(completion: {(image, error) in //capture image
            guard let image = image else {
                print(error ?? "Image capture error")
                return
            }
            //so we have the image
            let cog:CogPerson = CogPerson(image: image)
            currentPurchase?.cog = cog
            //print(cog.personID)
            
            self.performSegue(withIdentifier: "gotTheInfo", sender: nil)//you'll have issues with it being asyncronous
            
            
        })
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func switchCameras(_ sender: Any) {
        do {
            try cameraController.switchCameras()//switch cameras from front to back
        }
            
        catch {
            print(error)
        }
        
        switch cameraController.currentCameraPosition {//change the look of the button depending on current state
        case .some(.front):
            toggleCameraButton.setImage(#imageLiteral(resourceName: "Front Camera Icon"), for: .normal)
            
        case .some(.back):
            toggleCameraButton.setImage(#imageLiteral(resourceName: "Rear Camera Icon"), for: .normal)
            
        case .none:
            return
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
