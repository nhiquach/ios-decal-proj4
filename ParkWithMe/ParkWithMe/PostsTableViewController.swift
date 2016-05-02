//
//  PostsTableViewController.swift
//  ParkWithMe
//
//  Created by Nhi Quach on 4/28/16.
//  Copyright © 2016 Nhi Quach. All rights reserved.
//

import UIKit

class PostsTableViewController: UITableViewController {
    
    var posts = [Post]()

    override func viewDidLoad() {
        super.viewDidLoad()
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
}
