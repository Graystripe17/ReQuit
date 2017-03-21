//
//  ConversationViewController.swift
//  ReQuit
//
//  Created by Winston Van on 3/13/17.
//  Copyright © 2017 Winston Van. All rights reserved.
//

import UIKit
import Firebase


class ConversationViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    private let cellId = "cellId"
    var chatId: String!
    @IBOutlet var conversationView: UICollectionView!
    
    @IBOutlet weak var messageField: UITextField!
    
    @IBOutlet weak var bottomBar: UIView!
    
    let screenSize = UIScreen.main.bounds
    
    
    var currentUser: FIRUser {
        didSet {
            // This is called in the same thread as init
            // observeMessages()
        }
    }
    var ref: FIRDatabaseReference!
    var messages = [Message]()
 
    required init?(coder: NSCoder) {
        currentUser = (FIRAuth.auth()?.currentUser)!

        self.ref = FIRDatabase.database().reference()
        
        super.init(coder: coder)
        
    }
    
    func observeMessages() {
        
        // Load messages of chatId
        // Should be .childAdded
        ref.child("chats").child(chatId).observe(.childAdded, with: { (snapshot) in
            guard snapshot.exists() else {
                return
            }
            
            let value = snapshot.value as? NSDictionary
            
            self.messages.append(Message(messageDetails: value))

            // After messages is populated, load data
            DispatchQueue.main.async(execute: {
                // Sort messages ascending
                self.messages.sort(by: {
                    (m1, m2) in
                    return m1.time < m2.time
                })
                
                self.conversationView.reloadData()
            })

            
        })
//        self.conversationView.performBatchUpdates({
//            let location = [IndexPath(row: (self.messages.count) - 1, section: 0)]
//            self.conversationView.insertItems(at: location)
//        }, completion: {(success) in print(success)})
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        observeMessages()
        
        conversationView.bringSubview(toFront: bottomBar)

    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! ChatMessageCell
        cell.cellMessage.text = messages[indexPath.row].message
        
        cell.frame.size = CGSize(width: Constants.Screen.subWidth, height: (cell.cellMessage.text?.getEstimatedHeight(width: Constants.Screen.subWidth, font: UIFont(name: "Helvetica", size: 16)!))!)
        
        // Center
        cell.cellMessage.textAlignment = .center
        
        
        if messages[indexPath.row].sender == currentUser.uid {
            // You sent this message
            cell.backgroundColor = UIColor.purple
        } else {
            cell.backgroundColor = UIColor.yellow
        }
        
        return cell
    }
    
    // Do not specify number of items in section until table fully loaded.
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 80)
    }
    
    @IBAction func sendButtonPressed(_ sender: Any) {
        if messageField.text == "" { return }
        guard let intentMessage = messageField.text else { return }
        
        messageField.text = ""
        
        let payload = [
            "message": intentMessage,
            "sender": currentUser.uid,
            "time": NSDate().timeIntervalSince1970
        ] as [String : Any]
        
        self.ref.child("chats").child(chatId).childByAutoId().setValue(payload)
        
    }
    
    

}


extension String {
    func getEstimatedHeight(width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)

        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSFontAttributeName: font], context: nil)

        return boundingBox.height + 60
    }
}












