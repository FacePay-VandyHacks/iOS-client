//
//  FPSignInController.swift
//  FacePay
//
//  Created by Bruce Brookshire on 10/20/17.
//  Copyright © 2017 VandyHacks. All rights reserved.
//

import Foundation
import UIKit


class FPSignInController: UIViewController {
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var pswdField: UITextField!
    @IBOutlet weak var signInBtn: UIButton!
    
    override func viewDidLoad() {
        self.title = "Sign In"
        
        signInBtn.layer.borderWidth = 2
        signInBtn.layer.borderColor = Colors.FPGreen.cgColor
        signInBtn.layer.cornerRadius = 5
    }
    
    @IBAction func signedIn() {
        let defaults = UserDefaults.standard
        defaults.set("59eacfa8a73e4942cdafe3ad", forKey: DefaultsKeys.accountSecret)
        defaults.synchronize()
    }
    
}
