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
        accountBtn.layer.borderColor = UIColor.white.cgColor
        accountBtn.layer.borderWidth = 1
        accountBtn.layer.cornerRadius = 5
        
        transactionBtn.layer.borderColor = UIColor.white.cgColor
        transactionBtn.layer.borderWidth = 1
        transactionBtn.layer.cornerRadius = 5
        
    }
    
    @IBAction func tappedAccount() {
        
        
        
    }
    
    
    @IBAction func tappedTransaction() {
        
    }
    
    
}
