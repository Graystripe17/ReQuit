//
//  AppState.swift
//  ReQuit
//
//  Created by Winston Van on 1/8/17.
//  Copyright © 2017 Winston Van. All rights reserved.
//

import Foundation

class AppState: NSObject {
    static let sharedInstance = AppState()
    
    var signedIn = false
    var displayName: String?
    var photoURL: URL?
}
