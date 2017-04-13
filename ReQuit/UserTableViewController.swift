//
//  UserTableViewController.swift
//  ReQuit
//
//  Created by Winston Van on 11/27/16.
//  Copyright © 2016 Winston Van. All rights reserved.
//

import UIKit
import Firebase


class User {
    // MARK: Properties
    var name: String
    var image: String
    
    init(name: String, image: String) {
        self.name = name
        self.image = image
    }
}


class UserTableViewController: UITableViewController, UICollectionViewDelegateFlowLayout {
    
    // MARK: Properties
    var currentUser: FIRUser
    
    var users = [User]()
    
    var ref: FIRDatabaseReference!
    
    var messages: [FIRDataSnapshot]! = [FIRDataSnapshot()]
    
    var chatsList = [ChatSummary]()
    
    fileprivate var _refHandle: FIRDatabaseHandle!
    
    @IBOutlet var chatsTable: UITableView!
    
    var selectedChatId: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    

    
    
    required init?(coder aDecoder: NSCoder) {
        // Properties must be initialized before super.init call
        
        self.ref = FIRDatabase.database().reference()
        
        // Beware of the force unwrapped user object
        self.currentUser = (FIRAuth.auth()?.currentUser)!
        
//        self.chatsTable.register(UserTableViewCell.self, forCellReuseIdentifier: "UserTableViewCell")
        
        
        super.init(coder: aDecoder)
        
        // Uses self in a closure, must follow super.init
        // Sets up table and messages
        setUpTable()
        
        updateAndReload()
    }
    
    func setUpTable() {
        _refHandle = self.ref.child("messages").observe(.childAdded, with: {[weak self] (snapshot) -> Void in
            // Beware of forced unwrapping
            self?.messages.append(snapshot)
        })
    }
    
    func updateAndReload() {
        // Variable captured by closure before being initialized,
        // Singular read of "users/username" which gives a list of chatIDs
        // Possible change to .childAdded
        ref.child("users").child(currentUser.uid).child("chats").queryOrdered(byChild: "time").observeSingleEvent(of: .value, with: { (snapshot) in
            guard snapshot.exists() else {
                print("Error: Path not found")
                return
            }
            
            let value = snapshot.value as? NSDictionary
            
            var chatsReturned = 0;
            
            // Convert a dict of dicts into an array of dicts
            for (chatIdKey, secondDict) in value as! [String: NSDictionary] {
                
                self.ref.child("chats").child(chatIdKey).queryLimited(toLast: 1).observeSingleEvent(of: .value, with: { (snapshot) in
                    let metaValue = snapshot.value as? NSDictionary
                    
                    // This only appends metadata for the last chat
                    // Does not load every chat message
                    self.chatsList.append(ChatSummary(chatId: chatIdKey, targetChat: secondDict, metaData: metaValue!))
                    chatsReturned += 1
                    
                    // Reload only if this callback is the final one to return
                    if chatsReturned == value?.count {
                        // Check to see if it is the last iteration of the for loop
                        // After all of them have been appended, refresh the table.
                        DispatchQueue.main.async(execute: {
                            self.chatsTable.reloadData()
                        })
                    }
                    
                })
                
            }
        })
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return self.chatsList.count
    }

    // Data Source
    // Configure the cell
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UserTableViewCell {

        // What we named in the storyboard
        let cellIdentifier = "UserTableViewCell"
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! UserTableViewCell
        
        let targetChat = chatsList[indexPath.row]
        
        
        
        
        cell.nameLabel.text = targetChat.name
        cell.messageLabel.text = targetChat.message
        cell.dateLabel.text = convertToReadableElapsed(seconds: targetChat.time)
        
        cell.setAppearance(disabled: targetChat.read)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Set value of chatId
        selectedChatId = chatsList[indexPath.row].chatId
        performSegue(withIdentifier: "openConversation", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "openConversation" {
            let conversationViewController = segue.destination as! ConversationViewController
            conversationViewController.chatId = selectedChatId
        }
    }
    
    deinit {
        // Remove observer
    }

    func convertToReadableElapsed(seconds: Double) -> String {
        
        let elapsed = NSDate().timeIntervalSinceNow - seconds
        
        let seconds = elapsed
        let minutes = seconds / 60
        let hours = minutes / 60
        let days = hours / 24
        let weeks = days / 7
        
        if weeks > 1 {
            return "1+ weeks"
        }
        else if weeks == 1 {
            return "1 week"
        }
        else if days > 1 {
            return String(days) + " days"
        }
        else if days == 1{
            return "1 day"
        }
        else if hours > 1 {
            return String(hours) + " hours"
        }
        else if hours == 1 {
            return "1 hour"
        }
        else if minutes > 1 {
            return String(minutes) + " minutes"
        }
        else if minutes == 1 {
            return "1 minute"
        }
        else {
            return "Now"
        }
        
    }
    
}





















