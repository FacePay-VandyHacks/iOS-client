//
//  FPRequests.swift
//  FacePay
//
//  Created by Bruce Brookshire on 10/20/17.
//  Copyright © 2017 VandyHacks. All rights reserved.
//

import UIKit
import Foundation

class FPRequests {
    
    static let sharedInstance = FPRequests()
    
    
    func logIn() {
        
    }
    
    func signUp() {
        
    }
    
    func storeImage(image: UIImage) -> String? {
        do {
            let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            let fileURL = documentsURL.appendingPathComponent(String(arc4random()) + ".png")
            if let pngImageData = UIImagePNGRepresentation(image) {
                try pngImageData.write(to: fileURL, options: .atomic)
                return fileURL.absoluteString
            }
        } catch { print("storing", error) }
        
        return nil
    }
    
    func removeImage(url: String) {
        let fileManager = FileManager.default
        
        do {
            try fileManager.removeItem(atPath: url)
        }
        catch {
            print("removing", error)
        }
    }
}
