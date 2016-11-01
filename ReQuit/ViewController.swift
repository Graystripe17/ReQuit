//
//  ViewController.swift
//  ReQuit
//
//  Created by Winston Van on 10/5/16.
//  Copyright © 2016 Winston Van. All rights reserved.
//

import UIKit



class IntroPageViewController: UIPageViewController, UIPageViewControllerDataSource {
    
    // MARK: Properties
    let slideNames = ["1 - Username", "2 - Phone", "3 - Email", "4 - Más"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//      The object that provides view controllers.
//      Methods of the data source are called in response to gesture-based navigation. If the value of this property is nil, then gesture-based navigation is disabled.
        dataSource = self
        
        let firstFragmentViewController = FragmentViewController()
        firstFragmentViewController.slideName = slideNames[0]
        
        let viewControllers = [firstFragmentViewController]
        
        setViewControllers(viewControllers, direction: .forward, animated: true, completion: nil)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        let currentSlideName = (viewController as! FragmentViewController).slideName
        
        let fragmentViewController = FragmentViewController()
        
        let index = slideNames.index(of: currentSlideName!)!
        
        if index < slideNames.count - 1 {
            // Move forward
            fragmentViewController.slideName = slideNames[index + 1]
            return fragmentViewController
        }
        
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        let currentSlideName = (viewController as! FragmentViewController).slideName
        
        let fragmentViewController = FragmentViewController()
        
        let index = slideNames.index(of: currentSlideName!)!
        
        if index > 0 {
            // Move backwards
            fragmentViewController.slideName = slideNames[index - 1]
            return fragmentViewController
        }
        
        
        
        return nil
    }
}





class FragmentViewController: UIViewController, UITextFieldDelegate, UIPageViewControllerDelegate {

    
    // MARK: Properties
    @IBOutlet weak var usernameInstructionLabel: UILabel!
    @IBOutlet weak var usernameInputField: UITextField!
    
    
    
    
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return cv
    }()
    
    
    
    var slideName: String? {
        didSet {
            // Complete setting up the ViewController
            print("new set")
            let trac = Double(arc4random_uniform(256)) / Double(255)
            self.view.backgroundColor = UIColor.init(red: CGFloat(trac), green: 50/255, blue: 70/255, alpha: 1)
        }
    }
    
    
    // MARK: UITextFieldDelegate
    
    
    
    // MARK: Actions
    
    
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        usernameInputField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        print(textField.text!)
    }
    
    @IBAction func saveUsername(_ sender: UIButton) {
        let username = usernameInputField.text
     
        let preferences = UserDefaults.standard
        let usernameKey = "username"
        preferences.set(username, forKey: usernameKey)
        preferences.synchronize()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.brown
        
        // usernameInputField.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    


}

