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
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        self.title = "Preferences"
        
        logoutBtn.layer.borderColor = UIColor.red.cgColor
        logoutBtn.layer.borderWidth = 2
        logoutBtn.layer.cornerRadius = 5
        
        activityIndicator.isHidden = false
        activityIndicator.hidesWhenStopped = true
        activityIndicator.startAnimating()
        
        FPRequests.sharedInstance.getBalance { (success) in
            if success {
                if let balance = FPVariablesManager.sharedInstance.currentUser?.balance {
                    let balanceString = String(format: "$%.2f", balance)
                    DispatchQueue.main.async(execute: {
                        self.balanceLabel.text = balanceString
                        self.activityIndicator.stopAnimating()
                    })
                }
            }
        }
    }
    
    
    
    
    @IBAction func logout() {
        let defaults = UserDefaults.standard
        defaults.removeObject(forKey: DefaultsKeys.accountSecret)
        defaults.synchronize()
        
        FPVariablesManager.sharedInstance.window?.rootViewController = FPNavigationController(rootViewController: FPDisambiguationController(nibName: XIBFiles.DISAMBIGUATIONVIEW, bundle: nil))
        FPVariablesManager.sharedInstance.window?.makeKeyAndVisible()
    }
}
