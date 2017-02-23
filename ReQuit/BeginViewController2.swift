//
//  BeginViewController2
//  ReQuit
//
//  Created by Winston Van on 1/30/17.
//  Copyright © 2017 Winston Van. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class BeginViewController2: UIViewController {
    
    
    @IBOutlet weak var firstInput: UITextField!
    @IBOutlet weak var lastInput: UITextField!
    @IBOutlet weak var usernameInput: UITextField!
    
    var ref: FIRDatabaseReference!
    
    override func viewDidLoad() {
        ref = FIRDatabase.database().reference()
    }
    
    
    @IBAction func next(_ sender: UIButton) {
        
        // Authenticated user
        let user = FIRAuth.auth()?.currentUser
        
        guard let first = firstInput.text, let last = lastInput.text, let username = usernameInput.text else {
            print("Not formatted correctly")
            return
        }
        
        let payload: [String: String] = [
            "first": first,
            "last": last,
            "username": username
        ]
        
        self.ref.child("users").child((user?.uid)!).setValue(payload)
        
        
        
        
        
        
    }
    
    
}
