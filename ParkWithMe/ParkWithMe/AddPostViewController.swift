//
//  AddPostViewController.swift
//  ParkWithMe
//
//  Created by Nhi Quach on 4/28/16.
//  Copyright © 2016 Nhi Quach. All rights reserved.
//

import UIKit
import Eureka
import Firebase
import CoreLocation
import AddressBookUI
import GeoFire

class AddPostViewController : FormViewController {

    let rootRef = Firebase(url:"https://blazing-inferno-8100.firebaseio.com")
    let geoFire = GeoFire(firebaseRef: Firebase(url:"https://blazing-inferno-8100.firebaseio.com"))
    var post: Post?


    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        form
        +++ Section("Address")
            <<< PostalAddressRow("addressTag"){
                $0.title = "Address"
                $0.streetPlaceholder = "Street"
                $0.cityPlaceholder = "City"
                $0.postalCodePlaceholder = "ZipCode"
                $0.statePlaceholder = "State"
                $0.countryPlaceholder = "Country"
            }
        +++ Section("Info")
            <<< DateTimeRow("dateStartingTag") { $0.title = "Available Starting" }
            <<< DateTimeRow("dateUntilTag") { $0.title = "Available Until" }
            <<< DecimalRow("priceTag") { $0.title = "Price Per Hour ($USD)"}
            <<< IntRow("numSpacesTag") { $0.title = "Number of Spaces"}
            <<< SegmentedRow<String>("spaceTypeTag") {
                $0.options = ["Driveway", "Home Garage", "Lot Space"]
            }
            <<< MultipleSelectorRow<String>("featuresTag") {
                $0.title = "Features"
                $0.options = ["CCTV", "Covered", "Electric Charging", "Compact", "Overnight"]
            }
        +++ Section("Description")
            <<< TextAreaRow("descriptionTag") { $0.placeholder = "Description" }
        saveButton.target = self
        saveButton.action = #selector(AddPostViewController.pressedSaveButton)
        
    }
    
    
    func pressedSaveButton() {
        if let authData = rootRef.authData {
            let data = getFormValues()
            if data == [:] {
                return
            }
            self.rootRef.childByAppendingPath("posts").childByAppendingPath(data["address"] as! String).updateChildValues(data as [NSObject : AnyObject])
            self.rootRef.childByAppendingPath("posts").childByAppendingPath(data["address"] as! String).updateChildValues(["uid": authData.uid])
            saveLocation(data)
            self.performSegueWithIdentifier("unwindFromSave", sender: self)
        }

    }

    func saveLocation(data: NSDictionary) {
        let key = data["address"] as! String
        self.post = Post(data: data)

        forwardGeocoding(key, post: self.post!, completion: {
            success, coordinate in

            if success {
                let lat = coordinate.latitude
                let long = coordinate.longitude
                self.post!.lat = "\(lat)"
                self.post!.lon = "\(long)"
                let latStr = (self.post!.lat as NSString).doubleValue
                let lonStr = (self.post!.lon as NSString).doubleValue
                self.geoFire.setLocation(CLLocation(latitude: latStr, longitude: lonStr), forKey: key)
            } else {
                // error sth went wrong
            }
            
        })

    }


    func forwardGeocoding(address: String, post: Post, completion: (Bool, CLLocationCoordinate2D!) -> () ) {
        let geoCoder = CLGeocoder()

        geoCoder.geocodeAddressString(address) { (placemarks: [CLPlacemark]?, error: NSError?) -> Void in

            if error != nil {
                print(error?.localizedDescription)
                completion(false,nil)
            } else {
                if placemarks!.count > 0 {
                    let placemark = placemarks![0] as CLPlacemark
                    let location = placemark.location

                    completion(true, location?.coordinate)
                    
                }
            }
        }
    }

    func getFormValues() -> NSDictionary {
        let addressRow : PostalAddressRow? = form.rowByTag("addressTag")
        let dateStartingRow : DateTimeRow? = form.rowByTag("dateStartingTag")
        let dateUntilRow : DateTimeRow? = form.rowByTag("dateUntilTag")
        let priceRow : DecimalRow? = form.rowByTag("priceTag")
        let numSpacesRow : IntRow? = form.rowByTag("numSpacesTag")
        let spaceTypeRow : SegmentedRow<String>? = form.rowByTag("spaceTypeTag")
        let featuresRow : MultipleSelectorRow<String>? = form.rowByTag("featuresTag")
        let descriptionRow : TextAreaRow? = form.rowByTag("descriptionTag")

        var data = [String: String]()

        let dateStarting = dateStartingRow!.value
        let dateUntil = dateUntilRow!.value
        let price = priceRow!.value
        let numSpaces = numSpacesRow!.value
        let spaceType = spaceTypeRow!.value
        let features = featuresRow!.value
        let description = descriptionRow!.value

        if price == nil || numSpaces == nil || spaceType == nil || dateStarting == nil || dateUntil == nil {
            let alertController = UIAlertController(
                title: "Form Not Filled",
                message: "Please fill in missing values",
                preferredStyle: .Alert)
            let doneAction = UIAlertAction(title: "Dismiss", style: .Default , handler: nil)
            alertController.addAction(doneAction)
            self.presentViewController(alertController, animated: true, completion: nil)
            return data
        }

        let fullAddress = getFullAddress(addressRow!)
        if fullAddress == "" {
            let alertController = UIAlertController(
                title: "Invalid Address or Missing Address Values",
                message: "Please try a different address",
                preferredStyle: .Alert)
            let doneAction = UIAlertAction(title: "Dismiss", style: .Default , handler: nil)
            alertController.addAction(doneAction)
            self.presentViewController(alertController, animated: true, completion: nil)
            return data
        }

        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "MM-dd-yyyy'T'HH:mm"

        data["street"] = addressRow!.cell.streetTextField.text!
        data["address"] = fullAddress
        data["startingDate"] = dateFormatter.stringFromDate(dateStarting!)
        data["endDate"] = dateFormatter.stringFromDate(dateUntil!)
        data["price"] = String(price!)
        data["numSpaces"] = String(numSpaces!)
        data["spaceType"] = spaceType
        data["description"] = description

        var featureString = ""
        for f in features! {
            featureString += f + " "
        }

        data["features"] = featureString

        return data
    }

    func getFullAddress(addressRow: PostalAddressRow) -> String {
        let street = addressRow.cell.streetTextField.text!
        let city = addressRow.cell.cityTextField.text!
        let state = addressRow.cell.stateTextField.text!
        let zipcode = addressRow.cell.postalCodeTextField.text!
        let country = addressRow.cell.countryTextField.text!

        if street == "" || city == "" || state == "" || zipcode == "" || country == "" {
            return ""
        }

        return street + " " + city + ", " + state + " " + zipcode + " " + country

    }

}