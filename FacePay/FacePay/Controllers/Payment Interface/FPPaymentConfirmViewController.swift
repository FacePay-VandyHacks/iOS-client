//
//  FPPaymentConfirmViewController.swift
//  FacePay
//
//  Created by Bruce Brookshire on 10/21/17.
//  Copyright © 2017 VandyHacks. All rights reserved.
//

import Foundation
import UIKit

class FPPaymentConfirmViewController : UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var amountField: UITextField!
    @IBOutlet weak var confirmButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var uploadURL: String?
    var handle: String?
    
    override func viewDidLoad() {
        confirmButton.layer.borderColor = Colors.FPGreen.cgColor
        confirmButton.layer.borderWidth = 2
        confirmButton.layer.cornerRadius = 5
    }
    
    
    @IBAction func sendTransaction() {
        amountField.resignFirstResponder()
        guard let amount = amountField.text else {
            errorLabel.isHidden = false
            return
        }
        
        if uploadURL != nil {
            activityIndicator.isHidden = false
            activityIndicator.startAnimating()
            FPRequests.sharedInstance.sendRequest(uploadURL!) { (success) in
                if success {
                    DispatchQueue.main.async(execute: {
                        let window = FPVariablesManager.sharedInstance.window
                        let VC = FPHomeViewController(nibName: XIBFiles.HOMEVIEW, bundle: nil)
                        let navController = FPNavigationController(rootViewController: VC)
                        window?.rootViewController = navController
                        window?.makeKeyAndVisible()
                    })
                }
            }
        } else if handle != nil {
            activityIndicator.isHidden = false
            activityIndicator.startAnimating()
            FPRequests.sharedInstance.sendRequestHandle(handle!) { (success) in
                if success {
                    DispatchQueue.main.async(execute: {
                        let window = FPVariablesManager.sharedInstance.window
                        let VC = FPHomeViewController(nibName: XIBFiles.HOMEVIEW, bundle: nil)
                        let navController = FPNavigationController(rootViewController: VC)
                        window?.rootViewController = navController
                        window?.makeKeyAndVisible()
                    })
                }
            }
        }
    }
}
