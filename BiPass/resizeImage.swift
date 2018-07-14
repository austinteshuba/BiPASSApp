//
//  resizeImage.swift
//  BiPass
//
//  Created by Austin Teshuba on 2018-05-17.
//  Copyright © 2018 Austin Teshuba. All rights reserved.
// this is an externsion for ui image that allows you to algorithmically resize an image

import Foundation
import UIKit

extension UIImage {
    func resize(width: CGFloat, height: CGFloat) -> UIImage {//takes the height and width and returns a new image
        //the image is self
        let targetSize:CGSize = CGSize(width: width, height: height)
        
        let widthRatio = targetSize.width / self.size.width
        let heightRatio = targetSize.height / self.size.height//get height and width ratios
        
        var newSize:CGSize
        if (widthRatio>heightRatio) {
            //it is a landscape photo
            newSize = CGSize(width: self.size.width * heightRatio, height: self.size.height * heightRatio)
        } else {
            //it is a portrait photo (or square but who cares)
            newSize = CGSize(width: self.size.width * widthRatio, height: self.size.height * heightRatio)
        }
        
        let rect = CGRect(x:0, y:0, width: newSize.width, height: newSize.height)//make a new rect
        
        UIGraphicsBeginImageContextWithOptions(newSize, true, 1.0)//paste the image in the rect
        self.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        print("this happened")
        return newImage!//return the image from the rect
    }
}
