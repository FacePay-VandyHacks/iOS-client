//
//  FPAccountViewController.swift
//  FacePay
//
//  Created by Bruce Brookshire on 10/21/17.
//  Copyright © 2017 VandyHacks. All rights reserved.
//

import Foundation
import UIKit


class FPAccountViewController : UIViewController {
    
    @IBOutlet weak var logoutBtn: UIButton!
    
    override func viewDidLoad() {
        logoutBtn.layer.borderColor = UIcolor.white.cgcolor
        logoutBtn.layer.borderWidth = 1
        logoutBtn.layer.cornerRadius = 5
    }
    
    
    
    
    @IBAction func logout() {
        self.navigationController?.push()
        
        
        
    }
    
    
    
}
