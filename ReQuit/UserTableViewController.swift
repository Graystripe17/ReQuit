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
    
    var chatsList = [NSDictionary]()
    
    fileprivate var _refHandle: FIRDatabaseHandle!
    
    var chatsTable: UITableView
    
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
            let value = snapshot.value as? NSDictionary
            // An array of dictionaries
            // Forced unwrap early
            self.chatsList = (value?["chats"] as? [NSDictionary])!
            print(self.chatsList)
            
        })
        
    }
    
    func configureDatabase() {
        _refHandle = self.ref.child("messages").observe(.childAdded, with: {[weak self] (snapshot) -> Void in
            // Beware of forced unwrapping
            self?.messages.append(snapshot)
            self?.chatsTable.insertRows(at: [IndexPath(row: (self?.messages.count)!-1, section: 0)], with: .automatic)
            print("configuring")
            print(String(describing: self?.messages.count))
            
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
        // This force unwrap should be guaranteed if chatsList works
        // Consider forcing chatsList to exist and handling the error further up the chain
         return self.chatsList.count
    }

    // Data Source
    // Configure the cell
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UserTableViewCell {

        // What we named in the storyboard
        let cellIdentifier = "UserTableViewCell"
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! UserTableViewCell
        

        
        // The init code should have configured chatsList optional
        let targetChat = self.chatsList[indexPath.row]
        let name = targetChat["name"] as? String // If nil, anon
        let last = targetChat["last"] as? String
        let read = targetChat["read"] as? Bool
        let updated = targetChat["updated"] as? Int
        
        cell.nameLabel.text = name
        cell.messageLabel.text = last
        cell.dateLabel.text = updated?.description
        
        cell.setAppearance(disabled: read ?? false)
        
        return cell
    }
    
    
    deinit {
        // Remove observer
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
