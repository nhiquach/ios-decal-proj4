//
//  Post.swift
//  ParkWithMe
//
//  Created by Nhi Quach on 4/22/16.
//  Copyright © 2016 Nhi Quach. All rights reserved.
//

import Foundation

class Post {
    
    let timeAvailableStarting: String
    let timeAvailableUntil: String
    let address: String
    let features: String
    let spaceType: String
    let description: String
    let pricePerHour: String
    let numberOfSpaces: String
    let streetAddress: String
    let startFormatted: String
    let endFormatted: String
    var lat: String
    var lon: String


    init(data: NSDictionary) {
        self.timeAvailableStarting = data["startingDate"] as! String
        self.timeAvailableUntil = data["endDate"] as! String
        self.address = data["address"] as! String
        self.features = data["features"] as! String
        self.spaceType = data["spaceType"] as! String
        self.description = data["description"] as! String
        self.pricePerHour = data["price"] as! String
        self.numberOfSpaces = data["numSpaces"] as! String
        self.streetAddress = data["street"] as! String

        let range = timeAvailableStarting.startIndex..<timeAvailableStarting.startIndex.advancedBy(10)
        let endRange = timeAvailableStarting.startIndex.advancedBy(11)..<timeAvailableStarting.endIndex

        self.startFormatted = timeAvailableStarting.substringWithRange(range) + " " + timeAvailableStarting.substringWithRange(endRange)
        self.endFormatted = timeAvailableUntil.substringWithRange(range) + " " + timeAvailableUntil.substringWithRange(endRange)

        self.lat = ""
        self.lon = ""
    }
    
}