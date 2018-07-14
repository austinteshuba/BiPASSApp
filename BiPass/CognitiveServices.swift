//
//  CognitiveServices.swift
//  
//
//  Created by Austin Teshuba on 2018-05-26.
// The is the class the interfaces with microsoft azure for the Face PI

import Foundation
import UIKit
import Alamofire//netowkring API
import Alamofire_Synchronous
import SwiftyJSON//JSON handler

class CognitiveService {
    static let instance = CognitiveService()
    static let apiKey: String = API_KEY /// set in constants file
    static let groupName:String = "tester"//would have regional group names. This will only be tested in canada
    
    
    func makeNewPersonGroup() {
        var header = [String : String]()//headers are string dicts
        header["Ocp-Apim-Subscription-Key"] = CognitiveService.apiKey//set the api key
        
        let url:URL = URL(string: "https://westcentralus.api.cognitive.microsoft.com/face/v1.0/largepersongroups/tester")!//set the url
        
        let params:[String: String] = [:]//set params
        let json:JSON = JSON(["name":"tester"])
        var encoding:ParameterEncoding = MyCustomEncoding(data: Data())//use custom encoding to make the data
        do {
            let d:Data = try json.rawData()//make the data
            encoding = MyCustomEncoding(data:d)
        } catch {
            print("conversion failed")
        }
        let request = Alamofire.request(url, method: .put, parameters: params, encoding: encoding, headers: header)//make the synchronous request
        
        let resp = request.responseJSON()//get the request
        print(resp)
    }
    
    func createPerson()-> CogPerson? {

        let headers = [
            "Ocp-Apim-Subscription-Key": "6476aadeea904a80837fe0d0f9bc45ac",
            "Content-Type": "application/json",
            "Cache-Control": "no-cache",
            "Postman-Token": "b5bdb836-fd17-4b3e-b4cf-3bcd2f040f5e"
        ]//make the headers (made with postman)
        let parameters = ["name": currentUser!.firstName + "_" + currentUser!.lastName] as [String : Any]//current user better exist here or it will fail!
        var postData:Data? = nil
        do {
            postData = try JSONSerialization.data(withJSONObject: parameters, options: [])
        } catch {
            print("parse fail")
        }//make the data
        
        let request = NSMutableURLRequest(url: NSURL(string: "https://westcentralus.api.cognitive.microsoft.com/face/v1.0/largepersongroups/tester/persons")! as URL,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 10.0)//make the request (done synchronously)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = headers
        request.httpBody = postData! as Data
        
        let session = URLSession.shared
        let m = session.synchronousDataTask(urlrequest: request as URLRequest)
        print("I mean we made it here....")
        print(m.response)
        print(m.error)
        print(m.data!.description)
        do {
            let json = try? JSONSerialization.jsonObject(with: m.data!, options: [])//try to make the response into json
            print(json)
            if let jsonDict = json as? [String: String] {
                print(jsonDict)
                let pers:CogPerson = CogPerson(pID: jsonDict["personId"]!)//if you can, get the personID and return it
                
                return pers
            }
            
        } catch {//cant make it json? well thats a problem. just die then
            return nil
        }
        print("dies")
        return nil
        
        
        
        /*
        let params:[String: String] = [:]
        
        let request = Alamofire.request(url, method: .put, parameters: params, encoding: encoding, headers: header)//make the request
        print(request.description)
        var pID:String? = nil
        let response = request.responseJSON()
        
        if (response.result.isSuccess){//make sure the data is normal
            if let value = response.result.value as? [String:Any] {
                print(value)
                pID = value["personID"] as? String
                if let person = pID {
                    print("We made a person!")
                    return CogPerson(pID: person)
                } else {
                    print("this is returning nil")
                    return nil
                }
            } else {
                print("bad data")
            }
        } else {
            print(String(describing: response.result.error))
            return nil
        }
        */
       
    }
    
    func train() {//this trains the model. should be called after new faces are added.
        let headers = [
            "Ocp-Apim-Subscription-Key": "6476aadeea904a80837fe0d0f9bc45ac",
            "Content-Type": "application/json",
            "Cache-Control": "no-cache",
            "Postman-Token": "b5bdb836-fd17-4b3e-b4cf-3bcd2f040f5e"
        ]//make the headers. contains subscription key, declares the request is in JSON, and that I used postman to get the API access
        let parameters = [:] as [String : Any]//make an empty parameters dict. None are needed for this request
        var postData:Data? = nil//start with an empty data object
        do {
            postData = try JSONSerialization.data(withJSONObject: parameters, options: [])
        } catch {
            print("parse fail")
        }//make the data from the params
        
        let request = NSMutableURLRequest(url: NSURL(string: "https://westcentralus.api.cognitive.microsoft.com/face/v1.0/largepersongroups/tester/train")! as URL,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 10.0)//make the request to the API ur; (done synchronously)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = headers
        request.httpBody = postData! as Data//attach the created structures to the requests
        
        let session = URLSession.shared
        let m = session.synchronousDataTask(urlrequest: request as URLRequest)//make the request synchronously
        //print("I mean we made it here....")
        print(m.response)//print the results
        print(m.error)
        print(m.data!.description)
    }
        
    
    
    
}
