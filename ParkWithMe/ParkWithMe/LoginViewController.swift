//
//  LoginViewController.swift
//  ParkWithMe
//
//  Created by Nhi Quach on 4/16/16.
//  Copyright © 2016 Nhi Quach. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {
    
    // MARK: Properties
    let rootRef = Firebase(url:"https://blazing-inferno-8100.firebaseio.com")
    
    //MARK: Outlets
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    @IBAction func loginDidTouch(sender: AnyObject) {
        rootRef.authUser(emailTextField.text, password: passwordTextField.text,
            withCompletionBlock: { error, authData in
                if error != nil {
                    // There was an error logging in to this account
                    var errorMessage = ""
                    if let errorCode = FAuthenticationError(rawValue: error.code) {
                        switch (errorCode) {
                        case .UserDoesNotExist:
                            errorMessage = "Invalid username"
                        case .InvalidEmail:
                            errorMessage = "This email address does not exist."
                        case .InvalidPassword:
                            errorMessage = "Invalid password"
                        default:
                            errorMessage = ""
                        }
                    }
                    
                    let alertController = UIAlertController(
                        title: "Log In Error",
                        message: errorMessage,
                        preferredStyle: .Alert)
                    
                    let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
                    
                    alertController.addAction(cancelAction)
                    
                    self.presentViewController(alertController, animated: true, completion: nil)

                } else {
                    // We are now logged in
                    print("User logged in successfully")
                    self.performSegueWithIdentifier("loginToMap", sender: sender)
                }
        })
    }
    
    
    @IBAction func signUpDidTouch(sender: AnyObject) {
        rootRef.createUser(emailTextField.text, password: passwordTextField.text,
            withValueCompletionBlock: { error, result in
                if error != nil {
                    // There was an error creating the account
                } else {
                    let uid = result["uid"] as? String
                    print("Successfully created user account with uid: \(uid!)")
                }
        })
    }
    
    
}
