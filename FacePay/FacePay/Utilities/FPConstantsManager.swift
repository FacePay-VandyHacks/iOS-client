//
//  FPConstantsManager.swift
//  FacePay
//
//  Created by Bruce Brookshire on 10/20/17.
//  Copyright © 2017 VandyHacks. All rights reserved.
//

import Foundation
import UIKit

class FPConstantsManager {
    static let sharedInstance = FPConstantsManager()
    
    var accountSecret: String?
    var window: UIWindow?
    var userName: String?
    
}

struct Colors {
    static let FPGreen = UIColor(red: 46/256, green: 216/256, blue: 139/256, alpha: 1.0)
    static let FPBlue = UIColor(red: 76/256, green: 139/256, blue: 191/256, alpha: 1.0)
}

struct FPAPIKeys {
    static let baseURL = "http://api.reimaginebanking.com"
    static let appID = "3dc98b7092849aee4831c2d8a79b4b89"
}

struct DefaultsKeys {
    static let accountSecret = "accountSecret"
}

struct XIBFiles {
    //HOME/PAYMENT
    static let PAYMENTVIEW = "FPPaymentView"
    static let HOMEVIEW = "FPHomeView"
    static let ACCOUNTVIEW = "FPAccountView"
    
    //SIGNUP/SIGNIN
    static let DISAMBIGUATIONVIEW = "FPDisambiguationView"
    static let SIGNUPVIEW = "FPSignUpView"
    static let SIGNINVIEW = "FPSignInView"
    static let SIGNUPPHOTOSVIEW = "FPSignUpPhotosView"
    
}

