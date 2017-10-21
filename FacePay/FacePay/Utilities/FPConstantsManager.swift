//
//  FPConstantsManager.swift
//  FacePay
//
//  Created by Bruce Brookshire on 10/20/17.
//  Copyright © 2017 VandyHacks. All rights reserved.
//

import Foundation

class FPConstantsManager {
    static let sharedInstance = FPConstantsManager()
    
    var accountSecret: String?
    var userName: String?
    
}

struct CapitalOneAPIKeys {
    static let appID = ""
    static let key = ""
}


struct DefaultsKeys {
    static let accountSecret = "accountSecret"
}

struct XIBFiles {
    static let PAYMENTVIEW = "FPPaymentView"
    static let DISAMBIGUATIONVIEW = "FPDisambiguationView"
    static let SIGNUPVIEW = "FPSignUpView"
    static let SIGNINVIEW = "FPSignInView"
}
