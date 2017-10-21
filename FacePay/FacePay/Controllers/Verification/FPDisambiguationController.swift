//
//  FPDisambiguationController.swift
//  FacePay
//
//  Created by Bruce Brookshire on 10/20/17.
//  Copyright © 2017 VandyHacks. All rights reserved.
//

import Foundation
import UIKit

class FPDisambiguationController: UIViewController {
    
    @IBOutlet weak var logInBtn: UIButton!
    @IBOutlet weak var signUpBtn: UIButton!
    
    override func viewDidLoad() {
        self.title = "Welcome!"
        
        logInBtn.layer.borderColor = self.view.tintColor.cgColor
        logInBtn.layer.borderWidth = 1
        logInBtn.layer.cornerRadius = 5
        
        signUpBtn.layer.borderColor = self.view.tintColor.cgColor
        signUpBtn.layer.borderWidth = 1
        signUpBtn.layer.cornerRadius = 5
    }
    
    @IBAction func tappedLogIn() {
        self.navigationController?.pushViewController(FPSignInController(nibName: XIBFiles.SIGNINVIEW, bundle: nil), animated: true)
    }
    
    @IBAction func tappedSignUp() {
        self.navigationController?.pushViewController(FPSignUpController(nibName: XIBFiles.SIGNUPVIEW, bundle: nil), animated: true)
    }
    
    
}
