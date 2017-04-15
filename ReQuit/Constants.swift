//
//  Constants.swift
//  ReQuit
//
//  Created by Winston Van on 1/8/17.
//  Copyright © 2017 Winston Van. All rights reserved.
//

import UIKit

struct Constants {
    
    struct NotificationKeys {
        static let SignedIn = "onSignInCompleted"
    }
    
    struct Segues {
        static let SignIn = "signInSegue"
        static let SignUp = "signUpSegue"
    }
    
    struct Screen {
        static let screenSize = UIScreen.main.bounds
        static let subWidth = screenSize.width * 0.75
        static let screenWidth = screenSize.width
    }
    
}
