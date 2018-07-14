//
//  CogPerson.swift
//  BiPass
//
//  Created by Austin Teshuba on 2018-05-26.
//  Copyright © 2018 Austin Teshuba. All rights reserved.
// the is a person returned by the microsoft azure api.

import Foundation
import UIKit
import Alamofire//import alamofire for networking
import Firebase//import firebase
import FirebaseStorage

class CogPerson {
    var personID:String = ""//the person id from azure is a property
    var otherIDs:[String]? = nil
    var valid:Bool = true
    init (pID:String) {
        personID = pID
    }
    
    init (image:UIImage) {
        //so we want to make a cog person from an image. we need to query azure.
        valid = false//this wont be a valid person until the upload is done
        //var id = ""
        //upload the image
        let storage = FIRStorage.storage()//make the storage reference
        let storageRef = storage.reference()
        
        let date:Date = Date()//current date stuff
        let dateFormatter:DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        
        let imageRef = storageRef.child("\(self.personID)/\(dateFormatter.string(from:date))")//naviagte to unique area of database
        let data:Data = UIImageJPEGRepresentation(image, 1.0)!//now the image is an ios image object.
        print("we uploading now")
        var downloadURL:URL? = nil//this is the download url
        _ = imageRef.put(data, metadata:nil, completion: {
            (metadata,error) in
            print("theres something happening")
            guard let metadata=metadata else {
                print(error)//if thers an error, print it
                return
            }
            downloadURL = metadata.downloadURL()//get the download url
            guard let dURL = downloadURL else {
                print("download url missing")
                return
            }
            print("got it!")
            
            
            //cool. now off the azure!
            
            
            
            
            
            
            
            
            let headers = [
                "Ocp-Apim-Subscription-Key": "6476aadeea904a80837fe0d0f9bc45ac",
                "Content-Type": "application/json",
                "Cache-Control": "no-cache",
                "Postman-Token": "b5bdb836-fd17-4b3e-b4cf-3bcd2f040f5e"//make the headers
            ]
            let parameters = ["url": dURL.absoluteString] as [String : Any]//send the url as a param
            var postData:Data? = nil
            do {
                postData = try JSONSerialization.data(withJSONObject: parameters, options: [])//make this into data
            } catch {
                print("parse fail")
            }
            
            let request = NSMutableURLRequest(url: NSURL(string: "https://westcentralus.api.cognitive.microsoft.com/face/v1.0/detect")! as URL,
                                              cachePolicy: .useProtocolCachePolicy,
                                              timeoutInterval: 10.0)//make the request
            request.httpMethod = "POST"
            request.allHTTPHeaderFields = headers
            request.httpBody = postData! as Data
            
            let session = URLSession.shared
            let m = session.synchronousDataTask(urlrequest: request as URLRequest)//launch the request synchronously
            print(m.error)
            
            
            
            guard let data = m.data else {//if the data is empty, leave scope.
                print("theres no response")
                return
            }
            
            var fID = ""//this is the id of the face we put into azure. we need it to call into identify
            print()
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [Any]
                let t = json[0] as! [String:Any]//get the face id out of the json mess
                print(t)
                print(t["faceId"])
                
                //fID = (json["faceId"] as? String) ?? ""
                fID = t["faceId"] as? String ?? ""// get the face id and print it for clairty
                print(fID)
            } catch let error as NSError {//if theres an error with the JSON handling, just print it.
                print(error)
            }
            
            if (fID != ""){//as long as the face id exists (so the previous block of code has to do stuff)
            //the face is now in azure. So, lets identify
            
                let h = [
                    "Ocp-Apim-Subscription-Key": "6476aadeea904a80837fe0d0f9bc45ac",
                    "Content-Type": "application/json",
                    "Cache-Control": "no-cache",
                    "Postman-Token": "b5bdb836-fd17-4b3e-b4cf-3bcd2f040f5e"//make the headers with the usual subscription key, content type, etc
                ]
                
                let p = ["largePersonGroupID": "tester", "faceIDs": [fID]] as [String : Any]//send the faceid as a param
                var postDat:Data? = nil//start with an empty swift data file
                do {
                    postDat = try JSONSerialization.data(withJSONObject: p, options: [])//make this into data
                } catch {
                    print("parse fail")
                }
                
                let reques = NSMutableURLRequest(url: NSURL(string: "https://westcentralus.api.cognitive.microsoft.com/face/v1.0/identify")! as URL,
                                                  cachePolicy: .useProtocolCachePolicy,
                                                  timeoutInterval: 10.0)//make the request
                reques.httpMethod = "POST"
                reques.allHTTPHeaderFields = h//add the proper components
                reques.httpBody = postDat! as Data
                
                let sessio = URLSession.shared
                let me = sessio.synchronousDataTask(urlrequest: reques as URLRequest)//launch the request synchronously
                print(me.error)
                
                guard let res = me.data else {//if the response is empty, print that out and leave scope
                    print("we didn't get anything back...")
                    return
                }
                
                do {
                    let json = try JSONSerialization.jsonObject(with: res, options: .allowFragments) as! [Any]//get the person id from the json mess through a bunch of casts. Sigh this was annoying
                    print(json)
                    let n = json[0] as? [String:Any] ?? [:]
                    print(n)
                    let candid = n["candidates"] as! [Any]
                    print(candid)
                    let candidate = candid[0] as! [String:Any]
                    print(candidate)
                    self.personID = candidate["personId"] as? String ?? ""
                    self.valid=true
                    print(self.personID)
                    
                    //print(json[0]["faceId"])
                    //let cand = (json[0] as? [String:Any])["faceId"] ?? []
                    //self.personID = cand[0]["personId"] as? String ?? ""
                    //print(cand)
                } catch let error as NSError {
                    print(error)
                }
            }
        })
    }
    
    func addFace(image: UIImage) {//this adds the face to the azure machine learning model
        //first, we have to upload the image to firebase and get the URL back.
        // Create a root reference
        let storage = FIRStorage.storage()//make the storage reference
        let storageRef = storage.reference()
        
        let date:Date = Date()//current date stuff
        let dateFormatter:DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"//format as day month year
        
        let imageRef = storageRef.child("\(self.personID)/\(dateFormatter.string(from:date))")//naviagte to unique area of database
        let data:Data = UIImageJPEGRepresentation(image, 1.0)!//now the image is an ios image object.
        print("we uploading now")
        var downloadURL:URL? = nil//this is the download url
        _ = imageRef.put(data, metadata:nil, completion: {
            (metadata,error) in
            print("theres something happening")
            guard let metadata=metadata else {
                print(error)//if thers an error, print it
                return
            }
            downloadURL = metadata.downloadURL()//get the download url
            guard let dURL = downloadURL else {
                print("download url missing")
                return
            }
            print("got it!")
            
            
            var header = [String : String]()//pass off to azure
            //header["Ocp-Apim-Subscription-Key"] = CognitiveService.apiKey
            
            
            //step 2 - to azure!
            let headers = [
                "Ocp-Apim-Subscription-Key": "6476aadeea904a80837fe0d0f9bc45ac",
                "Content-Type": "application/json",
                "Cache-Control": "no-cache",
                "Postman-Token": "b5bdb836-fd17-4b3e-b4cf-3bcd2f040f5e"//make the headers
            ]
            let parameters = ["url": dURL.absoluteString] as [String : Any]//send the url as a param
            var postData:Data? = nil
            do {
                postData = try JSONSerialization.data(withJSONObject: parameters, options: [])//make this into data
            } catch {
                print("parse fail")
            }
            
            let request = NSMutableURLRequest(url: NSURL(string: "https://westcentralus.api.cognitive.microsoft.com/face/v1.0/largepersongroups/tester/persons/\(self.personID)/persistedfaces")! as URL,
                                              cachePolicy: .useProtocolCachePolicy,
                                              timeoutInterval: 10.0)//make the request
            request.httpMethod = "POST"//attach the componenets we made
            request.allHTTPHeaderFields = headers
            request.httpBody = postData! as Data
            
            let session = URLSession.shared//make the data task
            let m = session.synchronousDataTask(urlrequest: request as URLRequest)//launch the request synchronously
            print(m.error)//print any errors that occue
            
            
            //let params:[String: String] = ["largePersonGroupID":CognitiveService.groupName, "personID":self.personID, "url": dURL.absoluteString]
            
            //_ = Alamofire.request(url, method: .post, parameters: params, encoding: JSONEncoding.default, headers: header)//make the request
        })
        
        
        
        
        
    }
}
