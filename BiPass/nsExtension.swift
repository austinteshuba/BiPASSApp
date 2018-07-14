//
//  nsExtension.swift
//  BiPass
//
//  Created by Austin Teshuba on 2018-06-02.
//  Copyright © 2018 Austin Teshuba. All rights reserved.
//this is an extension to make synchronous url reauests

import Foundation

extension URLSession {//extends url session
    func synchronousDataTask(urlrequest: URLRequest) -> (data: Data?, response: URLResponse?, error: Error?) {//return a tuple that you can use to get the info and use it
        var data: Data?
        var response: URLResponse?
        var error: Error?
        
        let semaphore = DispatchSemaphore(value: 0)//ensures that the shared resources (data) are only used by this call
        
        let dataTask = self.dataTask(with: urlrequest) {
            data = $0//data is first param of the closure, $1, the second, etc.
            response = $1
            error = $2
            
            semaphore.signal()//signify that we are going to use these resources
        }
        dataTask.resume()//start the data task
        
        _ = semaphore.wait(timeout: .distantFuture)//wait until the task is done
        
        return (data, response, error)//return the information from the data task in a tuple
    }
}


