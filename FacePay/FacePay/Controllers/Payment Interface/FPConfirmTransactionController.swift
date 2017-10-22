//
//  FPConfirmTransactionController.swift
//  FacePay
//
//  Created by Bruce Brookshire on 10/22/17.
//  Copyright © 2017 VandyHacks. All rights reserved.
//

import Foundation
import UIKit

class FPConfirmTransactionController : UIViewController {
    @IBOutlet weak var amountlbl: UILabel!
    @IBOutlet weak var destinationLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var acceptBtn: UIButton!
    
    var amount: String!
    var username: String!
    
    override func viewDidLoad() {
        amountlbl.text = amount
        destinationLabel.text = username
        activityIndicator.isHidden = true
        
    }
    
    @IBAction func tappedConfirm() {
        
        FPRequests.sharedInstance.sendRequest(username, Double(amount)!) { (success) in
//            DispatchQueue.main.async(execute: {
//                let window = FPVariablesManager.sharedInstance.window
//                let VC = FPHomeViewController(nibName: XIBFiles.HOMEVIEW, bundle: nil)
//                let navController = FPNavigationController(rootViewController: VC)
//                window?.rootViewController = navController
//                window?.makeKeyAndVisible()
//            })
        }
    }
    
    
    
    
}
