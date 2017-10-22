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
    var tempKeyName: String?
    
    func uploadImageToAWS(image: UIImage) {
        tempKeyName = String(arc4random()) + ".png"
        let uploadingFileURL = storeImage(image: image)
        let bucket = "facepaydemobucket1234567890"
        
        let uploadRequest = AWSS3TransferManagerUploadRequest()
        
        uploadRequest?.bucket = bucket
        uploadRequest?.key = tempKeyName
        uploadRequest?.body = uploadingFileURL
        
        transferManager.upload(uploadRequest!).continueWith(executor: AWSExecutor.mainThread(), block: { (task:AWSTask<AnyObject>) -> Any? in
            
            if let error = task.error as NSError? {
                if error.domain == AWSS3TransferManagerErrorDomain, let code = AWSS3TransferManagerErrorType(rawValue: error.code) {
                    switch code {
                    case .cancelled, .paused:
                        break
                    default:
                        print("Error uploading: \(uploadRequest?.key ?? "") Error: \(error)")
                    }
                } else {
                    print("Error uploading: \(uploadRequest?.key ?? "") Error: \(error)")
                }
                //self.removeImage(url: stringURL)
                return nil
            }
            
            FPVariablesManager.sharedInstance.currentUpload = "https://s3.amazonaws.com/" + bucket + "/" + self.tempKeyName!
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "aws-upload-complete") , object: nil)
            print("Upload complete for: \(uploadRequest?.key ?? "")")
            return nil
        })
    }
    
    func logIn() {
        
    }
    
    func signUp() {
        
    }
    
    private func storeImage(image: UIImage) -> URL {
        if let data = UIImagePNGRepresentation(image) {
            
            let filename = getDocumentsDirectory().appendingPathComponent(tempKeyName!)
            try? data.write(to: filename)
            return filename
        }
        return URL(string: "")!
    }
    
    private func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    private func removeImage(url: String) {
        let fileManager = FileManager.default
        
        do {
            try fileManager.removeItem(atPath: url)
        }
        catch {
            print("removing", error)
        }
    }
}
