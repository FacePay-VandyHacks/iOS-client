//
//  FPConstantsManager.swift
//  FacePay
//
//  Created by Bruce Brookshire on 10/20/17.
//  Copyright © 2017 VandyHacks. All rights reserved.
//

import Foundation
import UIKit

//Manages data that should persist in session, but not between sessions
class FPVariablesManager {
    static let sharedInstance = FPVariablesManager()
    
    var currentUser: CurrentUser?
    
    var window: UIWindow?
    var userName: String?
    
}

//Colors used in the app
struct Colors {
    static let FPGreen = UIColor(red: 46/256, green: 216/256, blue: 139/256, alpha: 1.0)
    static let FPBlue = UIColor(red: 76/256, green: 139/256, blue: 191/256, alpha: 1.0)
}

//API keys to access capital one
//TODO: subject to change
struct FPAPIKeys {
    static let baseURL = "http://api.reimaginebanking.com"
    static let appID = "3dc98b7092849aee4831c2d8a79b4b89"
}

//Keys to return user defaults information
struct DefaultsKeys {
    static let accountSecret = "accountSecret"
}

//Names for all of the XIB files used in the app
struct XIBFiles {
    //HOME/PAYMENT
    static let PAYMENTVIEW = "FPPaymentView"
    static let HOMEVIEW = "FPHomeView"
    static let ACCOUNTVIEW = "FPAccountView"
    static let AMOUNTCONFIRMATIONVIEW = "FPAmountConfirmationView"
    static let TRANSACTIONCONFIRMATIONVIEW = "FPConfirmTransactionView"
    
    //SIGNUP/SIGNIN
    static let DISAMBIGUATIONVIEW = "FPDisambiguationView"
    static let SIGNUPVIEW = "FPSignUpView"
    static let SIGNINVIEW = "FPSignInView"
    static let SIGNUPPHOTOSVIEW = "FPSignUpPhotosView"
}

//API keys for Kairos
struct KairosAPI {
    static let AppID = "0576e4d2"
    static let AppKey = "7a6536f9999c8571429e4819dd7b7732"
}

//Fix to make an image rotate to the correct orientation before sending to FP API
extension UIImage {
    func correctlyOrientedImage() -> UIImage {
        if self.imageOrientation == UIImageOrientation.up {
            return self
        }
        
        UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)
        self.draw(in: CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height))
        let normalizedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!;
        UIGraphicsEndImageContext();
        
        return normalizedImage;
    }
}

