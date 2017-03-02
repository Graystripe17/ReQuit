//
//  SignInViewController.swift
//  ReQuit
//
//  Created by Winston Van on 1/16/17.
//  Copyright © 2017 Winston Van. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class SignInViewController: UIViewController {
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    
    @IBAction func didTapLogin(_ sender: UIButton) {
        if true {
            
        } else {
            
        }
    }
    
    override func viewDidLoad() {
        FIRApp.configure()
        FIRAuth.auth()?.signIn(withEmail: "hakuna.matata.kitty@gmail.com", password: "password") {
            (user, error) in
            print("Wrong")
        }
    }
}
