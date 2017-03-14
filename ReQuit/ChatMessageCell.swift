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
    
    let textView: UITextView = {
        let tv = UITextView()
        tv.backgroundColor = UIColor.orange
        tv.textColor = UIColor.purple
        return tv
    }()
}
