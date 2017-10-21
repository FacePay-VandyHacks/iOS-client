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
    static let baseURL = "http://api.reimaginebanking.com"
    static let appID = "3dc98b7092849aee4831c2d8a79b4b89"
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

struct User : Decodable {
    let _id: String
    let type: String
    let nickname: String
    let rewards: Double
    let balance: Double
    let customer_id: String
}
