//
//  PostDetailViewController.swift
//  ParkWithMe
//
//  Created by Nhi Quach on 5/1/16.
//  Copyright © 2016 Nhi Quach. All rights reserved.
//

import UIKit
import Firebase


class PostDetailViewController: UIViewController {

    
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var featuresLabel: UILabel!
    @IBOutlet weak var availableFromLabel: UILabel!
    @IBOutlet weak var availableUntilLabel: UILabel!
    @IBOutlet weak var spaceTypeLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var contactButton: UIButton!
    @IBOutlet weak var bookButton: UIButton!

    var post: Post?
    let rootRef = Firebase(url:"https://blazing-inferno-8100.firebaseio.com")

    override func viewDidLoad() {
        super.viewDidLoad()
        addressLabel.text = post?.streetAddress
        priceLabel.text = post?.pricePerHour
        featuresLabel.text = post?.features
        availableFromLabel.text = "Available From " + (post?.startFormatted)!
        availableUntilLabel.text = "Available Until " + (post?.endFormatted)!
        spaceTypeLabel.text = post?.spaceType
        descriptionLabel.text = post?.description
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        super.prepareForSegue(segue, sender: sender)
        let chatVc = segue.destinationViewController as! ChatViewController
        chatVc.senderId = self.rootRef.authData.uid
        chatVc.senderDisplayName = ""
    }
}