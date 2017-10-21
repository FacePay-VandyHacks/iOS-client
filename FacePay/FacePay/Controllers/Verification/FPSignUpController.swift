//
//  FPSignUpController.swift
//  FacePay
//
//  Created by Bruce Brookshire on 10/20/17.
//  Copyright © 2017 VandyHacks. All rights reserved.
//

import Foundation
import UIKit

class FPSignUpController: UIViewController {
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var pswdField: UITextField!
    @IBOutlet weak var pswdAgainField: UITextField!
    @IBOutlet weak var errorLbl: UILabel!
    @IBOutlet weak var getStartedBtn: UIButton!
    
    override func viewDidLoad() {
        self.title = "Sign Up"
        
        getStartedBtn.layer.borderWidth = 2
        getStartedBtn.layer.borderColor = Colors.FPGreen.cgColor
        getStartedBtn.layer.cornerRadius = 5
    }
    
    @IBAction func tappedGetStarted() {
        let VC = FPSignUpPhotosController(nibName: XIBFiles.SIGNUPPHOTOSVIEW, bundle: nil)
        self.navigationController?.pushViewController(VC, animated: true)
    }
}
