//
//  FPAccountViewController.swift
//  FacePay
//
//  Created by Bruce Brookshire on 10/21/17.
//  Copyright © 2017 VandyHacks. All rights reserved.
//

import Foundation
import UIKit


class FPAccountViewController : UIViewController {
    
    @IBOutlet weak var logoutBtn: UIButton!
    @IBOutlet weak var balanceLabel: UILabel!
    
    override func viewDidLoad() {
        balanceLabel.text = "$1,000.00"
        
        self.title = "Preferences"
        
        logoutBtn.layer.borderColor = UIColor.red.cgColor
        logoutBtn.layer.borderWidth = 2
        logoutBtn.layer.cornerRadius = 5
    }
    
    
    
    
    @IBAction func logout() {
        let defaults = UserDefaults.standard
        defaults.removeObject(forKey: DefaultsKeys.accountSecret)
        defaults.synchronize()
        
        FPConstantsManager.sharedInstance.window?.rootViewController = UINavigationController(rootViewController: FPDisambiguationController(nibName: XIBFiles.DISAMBIGUATIONVIEW, bundle: nil))
        FPConstantsManager.sharedInstance.window?.makeKeyAndVisible()
        
    }
    
    
    
}
