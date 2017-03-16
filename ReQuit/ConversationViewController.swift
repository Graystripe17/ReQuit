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
    var currentUser: FIRUser {
        didSet {
            // THIS DONT WORK
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
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            guard snapshot.exists() else { return }
            let value = snapshot.value
        })
        
        
        ref.child("chats").child(chatId).observe(.value, with: { (snapshot) in
            guard snapshot.exists() else {
                return
            }
            
            let value = snapshot.value as? NSDictionary
            
            self.messages.append(Message(messageDetails: value))
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        observeMessages()
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! ChatMessageCell
        cell.cellMessage.text = messages[indexPath.row].message
        
        // Height frame
//        let fixedHeight = cell.cellMessage.frame.size.height
//        let bestFit = cell.cellMessage.sizeThatFits(CGSize(width: CGFloat.greatestFiniteMagnitude, height: fixedHeight))
        
        cell.frame.size = CGSize(width: 500, height: (cell.cellMessage.text?.getEstimatedHeight(width: 500, font: UIFont(name: "Helvetica", size: 16)!))!)
        
        if messages[indexPath.row].sender == currentUser.uid {
            // You sent this message
            cell.backgroundColor = UIColor.purple
        } else {
            cell.backgroundColor = UIColor.yellow
        }
        
        return cell
    }
    
    // Do not specify number of items in section until table fully loaded.
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 80)
    }

}


extension String {
    func getEstimatedHeight(width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)

        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSFontAttributeName: font], context: nil)

        return boundingBox.height
    }
}












