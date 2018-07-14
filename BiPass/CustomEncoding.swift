//
//  CustomEncoding.swift
//  BiPass
//
//  Created by Austin Teshuba on 2018-05-29.
//  Copyright © 2018 Austin Teshuba. All rights reserved.
// this is a type of parameter encoding for alamofire that will take JSON
import Foundation
import UIKit
import Alamofire

public struct MyCustomEncoding : ParameterEncoding {
    private let data: Data//this is data you pass in. create swift object for it
    init(data: Data) {
        self.data = data
    }
    public func encode(_ urlRequest: URLRequestConvertible, with parameters: Parameters?) throws -> URLRequest {//will throw a url request error and will return a url request
        
        var urlReques:URLRequest? = nil//make a url request
        do {
            urlReques = try urlRequest.asURLRequest()//make input a urlRequest
            urlReques!.httpBody = data//make the body contain the data
            urlReques!.setValue("application/json", forHTTPHeaderField: "Content-Type")//set content type to json
        } catch {
            throw AFError.parameterEncodingFailed(reason: .jsonEncodingFailed(error: error))//throw an error if one arises
        }
        
        return urlReques!//return the request
    }
}
