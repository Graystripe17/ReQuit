//
//  AddDataViewController.swift
//  ReQuit
//
//  Created by Winston Van on 1/2/17.
//  Copyright © 2017 Winston Van. All rights reserved.
//

import UIKit

class AddDataViewController: UIViewController {
    
    @IBOutlet weak var newNameLabel: UITextField!
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addNameSegue" {
            let destinationController = segue.destination as! UserTableViewController
            destinationController.newName = newNameLabel.text
        }
    }
}
