//
//  Chat.swift
//  ReQuit
//
//  Created by Winston Van on 3/13/17.
//  Copyright © 2017 Winston Van. All rights reserved.
//

import Foundation

struct Chat {
    let name: String // If nil, anon
    let lastMessage: String
    let read: Bool
    let updatedTime: Int
    let chatID: String?
    
    init (targetChat: NSDictionary) {
        self.name = targetChat["name"] as? String ?? "Anon" // If nil, anon
        self.lastMessage = targetChat["last"] as? String ?? "Message not found"
        self.read = targetChat["read"] as? Bool ?? false
        self.updatedTime = targetChat["updated"] as? Int ?? 0
        self.chatID = "NO CHAT ID"
        
    }
    
    init (name: String?, lastMessage: String?, read: Bool?, updatedTime: Int?) {
        self.name = name ?? "Anon"
        self.lastMessage = lastMessage ?? "Message not found"
        self.read = read ?? false
        self.updatedTime = updatedTime ?? 0
        self.chatID = "NO CHAT ID"
    }
}
