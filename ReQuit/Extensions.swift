//
//  Extensions.swift
//  ReQuit
//
//  Created by Winston Van on 4/9/17.
//  Copyright © 2017 Winston Van. All rights reserved.
//

import UIKit

extension NSLayoutConstraint {
    override open var description: String {
        
        return "firstItem: \(firstItem), firstAttribute: \(firstAttribute), secondItem: \(secondItem), secondAttribute: \(secondAttribute), constant: \(constant)"
    }
}
