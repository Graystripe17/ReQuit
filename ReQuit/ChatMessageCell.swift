//
//  ChatMessageCell.swift
//  ReQuit
//
//  Created by Winston Van on 3/13/17.
//  Copyright © 2017 Winston Van. All rights reserved.
//

import UIKit

class ChatMessageCell: UICollectionViewCell {
    
    @IBOutlet weak var cellMessage: UILabel!
    
    @IBOutlet weak var bubbleView: UIView!
    
    var authorId: String?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        // Make label text only
        cellMessage.backgroundColor = UIColor.clear
        
        // Make text go to top right of the bubble
        cellMessage.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        cellMessage.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        // Make the cellMessage as tall as the bubble
        cellMessage.widthAnchor.constraint(equalToConstant: 200).isActive = true
        cellMessage.widthAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        
        // Bubble View
        bubbleView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        bubbleView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        bubbleView.widthAnchor.constraint(equalToConstant: 200).isActive = true
        bubbleView.widthAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        
        
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}
