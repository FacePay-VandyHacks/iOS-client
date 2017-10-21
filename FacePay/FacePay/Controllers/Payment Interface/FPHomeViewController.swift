//
//  FPHomeViewController.swift
//  FacePay
//
//  Created by Bruce Brookshire on 10/21/17.
//  Copyright © 2017 VandyHacks. All rights reserved.
//

import Foundation
import UIKit

class FPHomeViewController : UIViewController {
    
    
    
    @IBOutlet weak var accountBtn: UIButton!
    @IBOutlet weak var transactionBtn: UIButton!
    
    override func viewDidLoad() {
        
        self.title = "Welcome"
        
        accountBtn.layer.borderColor = Colors.FPGreen.cgColor
        accountBtn.layer.borderWidth = 2
        accountBtn.layer.cornerRadius = 5
        
        transactionBtn.layer.borderColor = Colors.FPGreen.cgColor
        transactionBtn.layer.borderWidth = 2
        transactionBtn.layer.cornerRadius = 5
        
    }
    
    @IBAction func tappedAccount() {
        
        self.navigationController?.pushViewController(FPAccountViewController(nibName: XIBFiles.ACCOUNTVIEW, bundle: nil) , animated: true)
        
    }
    
    
    @IBAction func tappedTransaction() {
        self.navigationController?.pushViewController(FPPaymentViewController(nibName: XIBFiles.PAYMENTVIEW, bundle: nil), animated: true)
    }
    
    
}
