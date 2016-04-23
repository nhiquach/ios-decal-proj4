//
//  User.swift
//  ParkWithMe
//
//  Created by Nhi Quach on 4/23/16.
//  Copyright © 2016 Nhi Quach. All rights reserved.
//

import Foundation
import Firebase

class User {
    
    let uid: String
    let email: String
    
    init(authData: FAuthData) {
        uid = authData.uid
        email = authData.providerData["email"] as! String
    }
    
    // Initialize from arbitrary data
    init(uid: String, email: String) {
        self.uid = uid
        self.email = email
    }
}