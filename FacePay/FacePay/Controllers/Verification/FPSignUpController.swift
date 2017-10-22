//
//  FPSignUpController.swift
//  FacePay
//
//  Created by Bruce Brookshire on 10/20/17.
//  Copyright © 2017 VandyHacks. All rights reserved.
//

import Foundation
import UIKit

class FPSignUpController: UIViewController, UITextFieldDelegate {
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
        usernameField.resignFirstResponder()
        pswdField.resignFirstResponder()
        pswdAgainField.resignFirstResponder()
        
        guard let username = usernameField.text as? String, let password = pswdField.text as? String, let password2 = pswdAgainField.text as? String else {
            badInput("Please fill in all fields")
            return
        }
        
        //Check all inputs
        if username.characters.contains(Character(" ")) {
            badInput("Username should have no spaces")
            return
        }
        else if username.characters.count > 16 {
            badInput("Username is too long")
            return
        }
        else if username.characters.count < 6 {
            badInput("Username is too short")
            return
        }
        else if password != password2 {
            badInput("Please enter the same password")
            return
        }
        else if password.characters.count < 8 {
            badInput("Password length must be greater than 7 characters")
            return
        }
        else if !capRegEx(text: password) {
            badInput("Password must contain a capital letter")
            return
        }
        else if !lwrRegEx(text: password) {
            badInput("Password must contain a lowercase letter")
            return
        }
        else if !numRegEx(text: password) {
            badInput("Password must contain a numeral")
            return
        }
        
        
        let VC = FPSignUpPhotosController(nibName: XIBFiles.SIGNUPPHOTOSVIEW, bundle: nil)
        VC.username = username
        VC.password = password
        
        self.navigationController?.pushViewController(VC, animated: true)
    }
    
    func badInput(_ message: String) {
        errorLbl.isHidden = false
        errorLbl.text = message
        pswdField.text = ""
        pswdAgainField.text = ""
    }
    
    func capRegEx(text: String) -> Bool {
        let capitalLetterRegEx  = ".*[A-Z]+.*"
        let texttest = NSPredicate(format:"SELF MATCHES %@", capitalLetterRegEx)
        return texttest.evaluate(with: text)
    }
    
    func lwrRegEx(text: String) -> Bool {
        let lwrRegEx  = ".*[a-z]+.*"
        let texttest = NSPredicate(format:"SELF MATCHES %@", lwrRegEx)
        return texttest.evaluate(with: text)
    }
    
    func numRegEx(text: String) -> Bool {
        let numRegEx  = ".*[0-9]+.*"
        let texttest = NSPredicate(format:"SELF MATCHES %@", numRegEx)
        return texttest.evaluate(with: text)
    }
    
    //Next text field behavior upon return
    func textFieldShouldReturn(_ textField: UITextField) -> Bool{
        if textField == usernameField {
            pswdField.becomeFirstResponder()
        } else if textField == pswdField {
            pswdAgainField.becomeFirstResponder()
        } else {
            pswdAgainField.resignFirstResponder()
        }
        
        return false
    }
}
