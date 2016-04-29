//
//  AddPostViewController.swift
//  ParkWithMe
//
//  Created by Nhi Quach on 4/28/16.
//  Copyright © 2016 Nhi Quach. All rights reserved.
//

import Eureka

class AddPostViewController : FormViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        form
        +++ Section("Address")
            <<< PostalAddressRow(){
                $0.title = "Address"
                $0.streetPlaceholder = "Street"
                $0.cityPlaceholder = "City"
                $0.postalCodePlaceholder = "ZipCode"
                $0.statePlaceholder = "State"
                $0.countryPlaceholder = "Country"
            }
            
        +++ Section("Pricing")
            <<< IntRow() { $0.title = "Price Per Hour (USD)"}
        
        +++ Section("Description")
            <<< TextAreaRow() { $0.placeholder = "Description" }
        
    }
}