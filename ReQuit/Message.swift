//
//  Message.swift
//  ReQuit
//
//  Created by Winston Van on 3/15/17.
//  Copyright © 2017 Winston Van. All rights reserved.
//

import UIKit

struct Message {
    let sender: String // If nil, anon
    let message: String
    let time: Int
    
    init (messageDetails: NSDictionary?) {
        self.sender = messageDetails?["sender"] as? String ?? "Anon" // If nil, anon
        self.message = messageDetails?["message"] as? String ?? "Message not found"
        self.time = messageDetails?["time"] as? Int ?? 0
    }
}
