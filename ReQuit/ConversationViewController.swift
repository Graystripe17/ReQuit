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
    var chatId: String = ""
    var currentUser: FIRUser
 
    required init?(coder: NSCoder) {
        currentUser = (FIRAuth.auth()?.currentUser)!
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! ChatMessageCell
        
        cell.cellMessage.text = chatId + "asdfasdjkahrgsejkrhgsekjrhgsjkdfhgsdjkf\n\nusfhdasu"
        

        
        // Height frame
        let fixedHeight = cell.cellMessage.frame.size.height
        let bestFit = cell.cellMessage.sizeThatFits(CGSize(width: CGFloat.greatestFiniteMagnitude, height: fixedHeight))
        
        cell.frame.size = CGSize(width: bestFit.width, height: max(bestFit.height, fixedHeight))
        
        
        if cell.authorId == currentUser.uid {
            // You sent this message
            cell.backgroundColor = UIColor.purple
        } else {
            cell.backgroundColor = UIColor.yellow
        }
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // Return the number of cells here
        return 10
    }

}











