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
    
    
    @IBAction func signedIn() {
        let defaults = UserDefaults.standard
        defaults.set("59eacfa8a73e4942cdafe3ad", forKey: DefaultsKeys.accountSecret)
        defaults.synchronize()
    }
    
}
