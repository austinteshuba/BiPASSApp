//
//  CameraViewController.swift
//  BiPass
//
//  Created by Austin Teshuba on 2018-04-17.
//  Copyright © 2018 Austin Teshuba. All rights reserved.
// ADD A LOADING THING

import UIKit
import AVFoundation
import Photos

class CameraViewController: UIViewController {

    @IBOutlet weak var smileLabel: UILabel!//outlets
    @IBOutlet weak var line: UIView!
    @IBOutlet weak var buttonOutlet: UIView!
    @IBOutlet weak var previewView: UIView!
    @IBOutlet weak var switchCameraButton: UIButton!
    @IBOutlet weak var descriptionText: UILabel!
    
    @IBOutlet weak var toggleCameraButton: UIButton!
    //@IBOutlet var viewT: UIView!
    
    @IBOutlet weak var stackContainerView: UIView!
    let cameraController = CameraController()//this is a camera controller that will handle a lot of the logic for taking pics
    //let defaultImage: UIImage = UIImage(named: "questionMark.png")!
    var photos: [UIImage?] = [nil,nil,nil,nil,nil]//array of photos. Starts as all nill
    
    @IBOutlet weak var imageOne: UIImageView!
    @IBOutlet weak var imageTwo: UIImageView!
    @IBOutlet weak var imageThree: UIImageView!
    @IBOutlet weak var imageFour: UIImageView!
    @IBOutlet weak var imageFive: UIImageView!
    
    
    @IBOutlet weak var continueText: UILabel!
    
    @IBOutlet weak var continueButton: UIButton!
    
    
    @IBAction func continuePressed(_ sender: Any) {
        //person objects
        let cogServ:CognitiveService = CognitiveService()//make cognitive service object
        cogServ.makeNewPersonGroup()//if there is no users, this allows the first one to exist. in the end, everyone is added to the same group
        let cogPerson = cogServ.createPerson()//make a new person and save the object
        currentUser?.personObject = cogPerson
        
        for photo in photos {
            guard let p = photo else {
                continue
            }
            currentUser?.personObject?.addFace(image: p)//add faces to the person
        }
        
        
        cogServ.train()
        
        
        
        performSegue(withIdentifier: "toLastSignUp", sender: nil)//off to next page
    }
    @IBAction func pictureOnePressed(_ sender: Any) {//if you press a photo, it deletes
        photos[0]=nil
        populatePhotoViews()
        print("yes")
    }
    @IBAction func pictureTwoPressed(_ sender: Any) {
        photos[1]=nil
        populatePhotoViews()
    }
    @IBAction func pictureThreePressed(_ sender: Any) {
        photos[2]=nil
        populatePhotoViews()
    }
    @IBAction func pictureFourPressed(_ sender: Any) {
        photos[3]=nil
        populatePhotoViews()
    }
    @IBAction func pictureFivePressed(_ sender: Any) {
        photos[4]=nil
        populatePhotoViews()
    }
    
    @IBOutlet weak var pictureOnePressed: UIButton!
    @IBOutlet weak var pictureTwoPressed: UIButton!
    @IBOutlet weak var pictureThreePressed: UIButton!
    @IBOutlet weak var pictureFourPressed: UIButton!
    @IBOutlet weak var pictureFivePressed: UIButton!
    
    
    var imageViews:[UIImageView] = []//array of image views
    
    func populatePhotoViews() {
        //make a for loop and go through the arrays
        for index in 0...4 {
            imageViews[index].backgroundColor = nil//no background color
            if let im = photos[index] {//iof image available, add the image to the view
                imageViews[index].image = im.resize(width: imageViews[index].bounds.width, height: imageViews[index].bounds.height
                )
            } else {//if no image, add the placeholder
                imageViews[index].image = UIImage(named: "questionMark.png")!.resize(width: imageViews[index].bounds.width, height: imageViews[index].bounds.height)
            }
        }
        stackContainerView.bringSubview(toFront: pictureOnePressed)//present all the subviews
        stackContainerView.bringSubview(toFront: pictureTwoPressed)
        stackContainerView.bringSubview(toFront: pictureThreePressed)
        stackContainerView.bringSubview(toFront: pictureFourPressed)
        stackContainerView.bringSubview(toFront: pictureFivePressed)
        
        if (photos[4] != nil){
            //we have taken all pictures
            UIView.animate(withDuration: 0.5, animations: {//show continue button
                self.stackContainerView.alpha=0
                self.continueText.alpha=1.0
                
                
            }, completion: {
                _ in
                self.continueButton.isEnabled = true
                
            })
        }
        
    }
    
    @IBAction func switchCam(_ sender: Any) {//if switch cam button pressed
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
    
    @IBAction func takePicture(_ sender: Any) {//the capture button is pressed
        
        self.buttonOutlet.backgroundColor = clickedColor//set the button to clicked color
        cameraController.captureImage(completion: {(image, error) in //capture image
            guard let image = image else {
                print(error ?? "Image capture error")
                return
            }
            
            try? PHPhotoLibrary.shared().performChangesAndWait {//try to save the image
                PHAssetChangeRequest.creationRequestForAsset(from: image)
            }
            
            for index in 0...4 {//populate the photos!
                if self.photos[index]==nil {//find the first nil photo and populate it
                    //print("capture")
                    self.buttonOutlet.backgroundColor = clickedColor
                    self.photos[index] = image
                    self.populatePhotoViews()
                    break
                }
            }
            
        })
        
    }
    
    
    @IBAction func buttonRelease(_ sender: Any) {//if button is released, make it the regular orange
        self.buttonOutlet.backgroundColor = orangeColor
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        smileLabel.textColor = orangeColor
        line.backgroundColor = orangeColor
        buttonOutlet.backgroundColor = orangeColor
        descriptionText.textColor = orangeColor
        
        continueText.textColor = orangeColor
        continueText.alpha = 0.0
        
        imageViews = [imageOne, imageTwo, imageThree, imageFour, imageFive]
        
        populatePhotoViews()
        
        
        func configureCameraController() {//this will put the preview feed on the preview view
            cameraController.prepare {(error) in
                if let error = error {
                    print(error)
                }
                
                try? self.cameraController.displayPreview(on: self.previewView)
            }
        }
        
        configureCameraController()//call nested function
        
        
        
        // Do any additional setup after loading the view.
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
