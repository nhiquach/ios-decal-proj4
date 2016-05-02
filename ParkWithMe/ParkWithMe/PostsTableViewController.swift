//
//  PostsTableViewController.swift
//  ParkWithMe
//
//  Created by Nhi Quach on 4/28/16.
//  Copyright © 2016 Nhi Quach. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import Firebase
import GeoFire

class PostsTableViewController: UITableViewController, CLLocationManagerDelegate {

    let manager = CLLocationManager()
    let rootRef = Firebase(url:"https://blazing-inferno-8100.firebaseio.com")
    let geoFire = GeoFire(firebaseRef: Firebase(url:"https://blazing-inferno-8100.firebaseio.com"))
    var currentLocation : CLLocation?
    var posts = [Post]()

    @IBOutlet weak var refreshButton: UIBarButtonItem!

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
        manager.requestLocation()
        
        refreshButton.target = self
        refreshButton.action = #selector(PostsTableViewController.nearbyPosts)
    }


    @IBAction func unwindToList(segue: UIStoryboardSegue) {
        if segue.identifier == "unwindFromSave" {
            let source: AddPostViewController = segue.sourceViewController as! AddPostViewController
            let post: Post? = source.post

            if post != nil {
                self.posts.append(post!)
                self.tableView.reloadData()
            }
        }
    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return posts.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier = "postCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! PostTableViewCell
        let post = posts[indexPath.row]
        cell.addressLabel.text = post.streetAddress
        cell.priceAndTypeLabel.text = "$" + post.pricePerHour + " - " + post.spaceType
        cell.availableFromLabel.text = "Available From: " + post.startFormatted
        cell.availableUntilLabel.text = "Available Until: " + post.endFormatted
        cell.availableFromLabel.sizeToFit()
        cell.availableUntilLabel.sizeToFit()
        cell.addressLabel.sizeToFit()
        cell.priceAndTypeLabel.sizeToFit()
        return cell
    }


    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            print("Found user's location: \(location)")
            self.currentLocation = location
            nearbyPosts()
        }
    }

    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print("Failed to find user's location: \(error.localizedDescription)")
    }

    func nearbyPosts() {
        if self.currentLocation == nil {
            return
        }
        let query = self.geoFire.queryAtLocation(self.currentLocation, withRadius: 1.6)

        query.observeEventType(.KeyEntered, withBlock: { (key: String!, location: CLLocation!) in


            let postRef = self.rootRef.childByAppendingPath("posts").childByAppendingPath(key)
            postRef.observeEventType(.Value, withBlock: {
                snapshot in
                self.posts.append(Post(data:snapshot.value as! NSDictionary))
              
            })
            self.tableView.reloadData()
        })
        
    }



}
