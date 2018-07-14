//
//  Globals.swift
//  BiPass
//
//  Created by Austin Teshuba on 2018-01-20.
//  Copyright © 2018 Austin Teshuba. All rights reserved.
// contains all of the global variables we need for the project

import UIKit
let orangeColor = UIColor(red: 245/255, green: 172/255, blue: 82/255, alpha: 1.0)
let clickedColor = UIColor(red: 245/255, green: 154/255, blue:82/255, alpha: 1.0)

var currentUser:User? = nil
var currentBusiness:Business? = nil

var currentPurchase:Purchase? = nil

var emails:[String] = []

var businesses:[String] = []
var busPass: [String:String] = [:]

var personIDs : [String:String] = [:]

var userPass: [String:String] = [:]

let API_KEY = "6476aadeea904a80837fe0d0f9bc45ac"
