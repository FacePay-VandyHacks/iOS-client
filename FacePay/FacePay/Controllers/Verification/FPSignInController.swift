//
//  FPSignInController.swift
//  FacePay
//
//  Created by Bruce Brookshire on 10/20/17.
//  Copyright © 2017 VandyHacks. All rights reserved.
//

import Foundation
import UIKit


class FPSignInController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var pswdField: UITextField!
    @IBOutlet weak var signInBtn: UIButton!
    @IBOutlet weak var errorLbl: UILabel!
    
    override func viewDidLoad() {
        self.title = "Sign In"
        
        signInBtn.layer.borderWidth = 2
        signInBtn.layer.borderColor = Colors.FPGreen.cgColor
        signInBtn.layer.cornerRadius = 5
    }
    
    //Next text field behavior upon return
    func textFieldShouldReturn(_ textField:UITextField) -> Bool{
        if textField == usernameField {
            pswdField.becomeFirstResponder()
        } else {
            pswdField.resignFirstResponder()
        }
        return false
    }
    
    @IBAction func signedIn() {
        usernameField.resignFirstResponder()
        pswdField.resignFirstResponder()
        
        self.errorLbl.isHidden = true
        if let username = usernameField.text, let password = pswdField.text {
            FPRequests.sharedInstance.logIn(username, password, { (success) in
                if success {
                    DispatchQueue.main.async(execute: {
                        let window = FPVariablesManager.sharedInstance.window
                        let VC = FPHomeViewController(nibName: XIBFiles.HOMEVIEW, bundle: nil)
                        let navController = FPNavigationController(rootViewController: VC)
                        window?.rootViewController = navController
                        window?.makeKeyAndVisible()
                    })
                } else {
                    DispatchQueue.main.async(execute: {
                        self.errorLbl.isHidden = false
                    })
                }
            })
        }
    }
}
