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
        
        
        self.title = "Preferences"
        
        logoutBtn.layer.borderColor = UIColor.red.cgColor
        logoutBtn.layer.borderWidth = 2
        logoutBtn.layer.cornerRadius = 5
        
        guard let balance = FPVariablesManager.sharedInstance.currentUser?.balance else {
            balanceLabel.text = ""
            return
        }
        
        let balanceString = String(format: "$%f0.2", balance)
        balanceLabel.text = balanceString
    }
    
    
    
    
    @IBAction func logout() {
        let defaults = UserDefaults.standard
        defaults.removeObject(forKey: DefaultsKeys.accountSecret)
        defaults.synchronize()
        
        FPVariablesManager.sharedInstance.window?.rootViewController = FPNavigationController(rootViewController: FPDisambiguationController(nibName: XIBFiles.DISAMBIGUATIONVIEW, bundle: nil))
        FPVariablesManager.sharedInstance.window?.makeKeyAndVisible()
        
    }
    
    
    
}
