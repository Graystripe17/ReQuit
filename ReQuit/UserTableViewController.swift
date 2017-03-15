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
    
    var chatsList = [Chat]()
    
    fileprivate var _refHandle: FIRDatabaseHandle!
    
    var chatsTable: UITableView
    
    var selectedChatId: String = "unselected"
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        // Properties must be initialized before super.init call
        
        self.ref = FIRDatabase.database().reference()
        
        // Beware of the force unwrapped user object
        self.currentUser = (FIRAuth.auth()?.currentUser)!
        
        self.chatsTable = UITableView(coder: aDecoder)!
        
        self.chatsTable.register(UserTableViewCell.self, forCellReuseIdentifier: "UserTableViewCell")
        
        
        super.init(coder: aDecoder)
        
        // Uses self in a closure, must follow super.init
        configureDatabase()
        
        // Variable captured by closure before being initialized,
        // Singular read of "users/username" which gives a list of chatIDs
        ref.child("users").child(currentUser.uid).observeSingleEvent(of: .value, with: { (snapshot) in
            guard snapshot.exists() else {
                print("Error: Path not found")
                return
            }
            
            let value = snapshot.value as? NSDictionary
            // Convert a dict of dicts into an array of dicts
            // You will lose chatID in the process, so be warned
            // Unless you would like to to keep the data in a struct
            for (chatIdKey, secondDict) in value?["chats"] as! [String: NSDictionary] {
                // TODO: Store the ChatID
                self.chatsList.append(Chat(chatId: chatIdKey, targetChat: secondDict))
            }
        })
        
    }
    
    func configureDatabase() {
        _refHandle = self.ref.child("messages").observe(.childAdded, with: {[weak self] (snapshot) -> Void in
            // Beware of forced unwrapping
            self?.messages.append(snapshot)
            self?.chatsTable.insertRows(at: [IndexPath(row: (self?.messages.count)!-1, section: 0)], with: .automatic)
            
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
        cell.messageLabel.text = targetChat.lastMessage
        cell.dateLabel.text = targetChat.updatedTime.description
        
        cell.setAppearance(disabled: targetChat.read)
        
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
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

}





















