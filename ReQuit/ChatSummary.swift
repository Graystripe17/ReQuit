//
//  ChatSummary.swift
//  ReQuit
//
//  Created by Winston Van on 3/13/17.
//  Copyright © 2017 Winston Van. All rights reserved.
//

import Foundation

struct ChatSummary {
    
    let chatId: String
    
    let isAnon: Bool
    let read: Bool
    let partnerName: String
    
    // Meta data for table
    // Must be dug up in a second query
    let message: String
    let sender: String
    let time: Double
    
    
    init (chatId: String, targetChat: NSDictionary, metaData: NSDictionary) {
        self.chatId = chatId
        
        self.isAnon = targetChat["isAnon"] as? Bool ?? false
        self.read = targetChat["read"] as? Bool ?? false
        self.partnerName = targetChat["partnerName"] as? String ?? "Anon"
        
        let lastMessageData = metaData.allValues.first as! NSDictionary
        
        self.message = lastMessageData["message"] as? String ?? "No message found"
        self.sender = lastMessageData["sender"] as? String ?? "No sender found"
        self.time = lastMessageData["time"] as? Double ?? 0
    }
    
}
