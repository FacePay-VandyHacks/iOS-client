//
//  FPRequests.swift
//  FacePay
//
//  Created by Bruce Brookshire on 10/20/17.
//  Copyright © 2017 VandyHacks. All rights reserved.
//

import UIKit
import Foundation
import AWSS3

class FPRequests {
    
    static let sharedInstance = FPRequests()
    let transferManager = AWSS3TransferManager.default()
    
    func uploadImageToAWS(image: UIImage) {
        let stringURL = storeImage(image: image)!
        let uploadingFileURL = URL(fileURLWithPath: stringURL)
        
        let uploadRequest = AWSS3TransferManagerUploadRequest()
        
        uploadRequest?.bucket = "myBucket"
        uploadRequest?.key = "myTestFile.txt"
        uploadRequest?.body = uploadingFileURL
        
        transferManager.upload(uploadRequest!).continueWith(executor: AWSExecutor.mainThread(), block: { (task:AWSTask<AnyObject>) -> Any? in
            
            if let error = task.error as? NSError {
                if error.domain == AWSS3TransferManagerErrorDomain, let code = AWSS3TransferManagerErrorType(rawValue: error.code) {
                    switch code {
                    case .cancelled, .paused:
                        break
                    default:
                        print("Error uploading: \(uploadRequest?.key) Error: \(error)")
                    }
                } else {
                    print("Error uploading: \(uploadRequest?.key) Error: \(error)")
                }
                self.removeImage(url: stringURL)
                return nil
            }
            
            let uploadOutput = task.result
            print("Upload complete for: \(uploadRequest?.key)")
            return nil
        })
    }
    
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
