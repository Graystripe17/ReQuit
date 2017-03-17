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
        
        // Make text go to top right of the Cell
        cellMessage.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        cellMessage.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        // Make the cellMessage as tall as the Cell
        cellMessage.widthAnchor.constraint(equalToConstant: 400).isActive = true
        cellMessage.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true

        // Bubble View
        bubbleView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        bubbleView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        bubbleView.widthAnchor.constraint(equalToConstant: 400).isActive = true
        bubbleView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
//
        // Decorate bubble view
        bubbleView.layer.cornerRadius = 50
        bubbleView.layer.borderColor = UIColor.gray.withAlphaComponent(0.5).cgColor
        bubbleView.layer.borderWidth = 0.5
        bubbleView.layer.masksToBounds = true
        bubbleView.clipsToBounds = true
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}
