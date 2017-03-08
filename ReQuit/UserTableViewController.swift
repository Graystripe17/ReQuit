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
    var currentUser: FIRUser?
    
    var users = [User]()
    
    var newName: String?
    
    var ref: FIRDatabaseReference!
    
    var messages: [FIRDataSnapshot]! = [FIRDataSnapshot()]
    
    fileprivate var _refHandle: FIRDatabaseHandle!
    
    var chatsTable: UITableView
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureDatabase()
        
        ref = FIRDatabase.database().reference()
        
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        
        self.currentUser = FIRAuth.auth()?.currentUser
        
        self.chatsTable = UITableView(coder: aDecoder)!
        
        self.chatsTable.register(UserTableViewCell.self, forCellReuseIdentifier: "UserTableViewCell")
        
        super.init(coder: aDecoder)
        
    }
    
    func configureDatabase() {
        ref = FIRDatabase.database().reference()
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
         return 13
    }

    // Data Source
    // Configure the cell
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UserTableViewCell {

        // What we named in the storyboard
        let cellIdentifier = "UserTableViewCell"
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! UserTableViewCell
        
        ref.child("users").child(currentUser.displayName).observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? NSDictionary
            let username = value?["Username"] as? String ?? ""
            
        })
        
        let messageSnapshot: FIRDataSnapshot! = self.messages.removeFirst()
//        let message = messageSnapshot.value as! Dictionary<String, String>
//        let name = message["Names"] as String?
//        let text = message["Text"] as String?
//        
//        
//        cell.nameLabel.text = name
//        cell.messageLabel.text = text

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
