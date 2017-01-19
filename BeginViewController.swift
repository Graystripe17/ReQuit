//
//  BeginViewController.swift
//  ReQuit
//
//  Created by Winston Van on 1/4/17.
//  Copyright © 2017 Winston Van. All rights reserved.
//

import UIKit
import FirebaseAuth


class BeginViewController: UIViewController {
    
    @IBOutlet weak var usernameInput: UITextField!
    @IBOutlet weak var passwordInput: UITextField!
    
    
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        
        print(identifier)
        
        if identifier == Constants.Segues.SignUp {
            
        }
        
        if identifier == Constants.Segues.SignIn {
            return true
        }
        
    
        return false
    }
    
    
    @IBAction func didTapSignUp(_ sender: UIButton) {
        
        guard let username = usernameInput.text, let password = passwordInput.text else { return }
        
        // CES in the last parameter is called on completion
        // Need to implement callback, remove flag
        FIRAuth.auth()?.createUser(withEmail: username, password: password)
        { (user, error) in
            if let error = error {
                print(error.localizedDescription)
                self.signUpFailed()
                return
            }
            // Change to sign up info
            self.signedIn(user!)
        }
        
        
    }
    
    func signUpFailed() {
        
    }
    
    
    func signedIn(_ user: FIRUser?) {
        // MeasurementHelper.sendLoginEvent()
        
        AppState.sharedInstance.displayName = user?.displayName ?? user?.email
        AppState.sharedInstance.photoURL = user?.photoURL
        AppState.sharedInstance.signedIn = true
        
//        let notificationName = Notification.Name(rawValue: Constants.NotificationKeys.SignedIn)
//        NotificationCenter.default.post(name: notificationName, object: nil, userInfo: nil)
        performSegue(withIdentifier: Constants.Segues.SignUp, sender: nil)
        
        
    }
    
}
