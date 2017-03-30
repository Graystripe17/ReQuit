//
//  ChatSummary.swift
//  ReQuit
//
//  Created by Winston Van on 3/13/17.
//  Copyright © 2017 Winston Van. All rights reserved.
//

import Foundation

struct ChatSummary {
    let name: String
    let read: Bool
    let isAnon: Bool
    let chatId: String
    
    // Meta data for table
    // Meta data is NOT going to change
    let message: String
    let sender: String
    let time: Double
    
    
    init (chatId: String, targetChat: NSDictionary, metaData: NSDictionary) {
        self.name = targetChat["name"] as? String ?? "Anon" // If nil, anon
        self.isAnon = targetChat["isAnon"] as? Bool ?? false
        self.read = targetChat["read"] as? Bool ?? false
        self.chatId = chatId
        
        self.message = metaData["message"] as? String ?? "No message found"
        self.sender = metaData["sender"] as? String ?? "No sender found"
        self.time = metaData["time"] as? Double ?? 0
    }
    
}
