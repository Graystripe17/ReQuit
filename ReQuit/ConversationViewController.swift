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
    
    @IBOutlet weak var sendButton: UIButton!
    
    
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
                
                let item = self.collectionView(self.conversationView, numberOfItemsInSection: 0) - 1
                let lastItemIndex = NSIndexPath(item: item, section: 0)
                self.collectionView?.scrollToItem(at: lastItemIndex as IndexPath, at: UICollectionViewScrollPosition.top, animated: false)
                
                
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
        
        
        // Setup BottomBar
        bottomBar.backgroundColor = UIColor.white
        bottomBar.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(bottomBar)
        
        
        //x,y,w,h
        bottomBar.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        bottomBar.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        bottomBar.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        bottomBar.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        sendButton.translatesAutoresizingMaskIntoConstraints = false
        bottomBar.addSubview(sendButton)
        

        //x,y,w,h
        sendButton.rightAnchor.constraint(equalTo: bottomBar.rightAnchor).isActive = true
        sendButton.centerYAnchor.constraint(equalTo: bottomBar.centerYAnchor).isActive = true
        sendButton.widthAnchor.constraint(equalToConstant: 80).isActive = true
        sendButton.heightAnchor.constraint(equalTo: bottomBar.heightAnchor).isActive = true
        
        
        //x,y,w,h
        messageField.leftAnchor.constraint(equalTo: bottomBar.leftAnchor, constant: 8).isActive = true
        messageField.centerYAnchor.constraint(equalTo: bottomBar.centerYAnchor).isActive = true
        messageField.rightAnchor.constraint(equalTo: bottomBar.leftAnchor).isActive = true
        messageField.heightAnchor.constraint(equalTo: bottomBar.heightAnchor).isActive = true
        
        // Line entirely programatically
        let separatorLineView = UIView()
        separatorLineView.backgroundColor = UIColor(red: 220, green: 220, blue: 220, alpha: 1)
        separatorLineView.translatesAutoresizingMaskIntoConstraints = false
        messageField.addSubview(separatorLineView)
        
        //x,y,w,h
        separatorLineView.leftAnchor.constraint(equalTo: messageField.leftAnchor).isActive = true
        separatorLineView.topAnchor.constraint(equalTo: messageField.topAnchor).isActive = true
        separatorLineView.widthAnchor.constraint(equalTo: messageField.widthAnchor).isActive = true
        separatorLineView.heightAnchor.constraint(equalToConstant: 5).isActive = true
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        print(bottomBar.bottomAnchor)
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












