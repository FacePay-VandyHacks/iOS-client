//
//  FPPaymentPage.swift
//  FacePay
//
//  Created by Bruce Brookshire on 10/20/17.
//  Copyright © 2017 VandyHacks. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation

class FPPaymentViewController:  UIViewController, AVCapturePhotoCaptureDelegate {
    
    var captureSession: AVCaptureSession?
    var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    var capturePhotoOutput: AVCapturePhotoOutput?
    var isUploading = false
    
    @IBOutlet weak var previewView: UIView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var cameraCapture: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var handleField: UITextField!
    
    override func viewDidLoad() {
        self.title = "Make a Transaction"
        NotificationCenter.default.addObserver(self, selector: #selector(uploadComplete), name: NSNotification.Name(rawValue: "aws-upload-complete"), object: nil)
        activityIndicator.hidesWhenStopped = true
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidLayoutSubviews() {
        cameraCapture.layer.borderColor = Colors.FPGreen.cgColor
        cameraCapture.layer.borderWidth = 2
        cameraCapture.layer.cornerRadius = 5
        
        nextButton.layer.borderColor = Colors.FPGreen.cgColor
        nextButton.layer.borderWidth = 2
        nextButton.layer.cornerRadius = 5
        
        previewView.clipsToBounds = true
        previewView.layer.cornerRadius = previewView.frame.width/2
        
        loadCamera()
    }
    
    @objc func uploadComplete() {
        if isUploading {
            isUploading = false
            let tempURL = FPConstantsManager.sharedInstance.currentUpload
            FPConstantsManager.sharedInstance.currentUpload = nil
            let VC = FPPaymentConfirmViewController(nibName: XIBFiles.AMOUNTCONFIRMATIONVIEW, bundle: nil)
            VC.uploadURL = tempURL
            self.navigationController?.pushViewController(VC, animated: true)
        }
    }
    
    @IBAction func tappedNext() {
        
    }
    
    @IBAction func tappedCapture () {
        cameraCapture.isEnabled = false
        nextButton.isEnabled = false
        handleField.isEnabled = false
        previewView.alpha = 0.5
        
        activityIndicator.startAnimating()
        
        // Make sure capturePhotoOutput is valid
        guard let capturePhotoOutput = self.capturePhotoOutput else { return }
        // Get an instance of AVCapturePhotoSettings class
        let photoSettings = AVCapturePhotoSettings()
        // Set photo settings for our need
        photoSettings.isAutoStillImageStabilizationEnabled = true
        photoSettings.isHighResolutionPhotoEnabled = true
        photoSettings.flashMode = .auto
        // Call capturePhoto method by passing our photo settings and a
        // delegate implementing AVCapturePhotoCaptureDelegate
        capturePhotoOutput.capturePhoto(with: photoSettings, delegate: self)
    }
    
    func loadCamera() {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        previewView.backgroundColor = Colors.FPBlue
        
        DispatchQueue.global(qos: .userInitiated).async {
            DispatchQueue.main.async {
                
                do {
                    let input = try AVCaptureDeviceInput(device: self.cameraWithPosition(.back)!)
                    self.captureSession = AVCaptureSession()
                    self.captureSession?.addInput(input)
                    
                    self.videoPreviewLayer = AVCaptureVideoPreviewLayer(session: self.captureSession!)
                    self.videoPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
                    self.videoPreviewLayer?.frame = self.previewView.layer.bounds
                    self.previewView.layer.addSublayer(self.videoPreviewLayer!)
                    
                    self.captureSession?.startRunning()
                    
                    self.capturePhotoOutput = AVCapturePhotoOutput()
                    self.capturePhotoOutput?.isHighResolutionCaptureEnabled = true
                    
                    self.captureSession?.addOutput(self.capturePhotoOutput!)
                } catch {
                    print(error)
                }
                
                self.activityIndicator.stopAnimating()
                UIView.animate(withDuration: 0.5, animations: {
                    self.previewView.backgroundColor = .white
                    self.activityIndicator.isHidden = true
                })
            }
        }
        
    }
    
    func photoOutput(_ captureOutput: AVCapturePhotoOutput,
                     didFinishProcessingPhoto photoSampleBuffer: CMSampleBuffer?,
                     previewPhoto previewPhotoSampleBuffer: CMSampleBuffer?,
                     resolvedSettings: AVCaptureResolvedPhotoSettings,
                     bracketSettings: AVCaptureBracketedStillImageSettings?,
                     error: Error?) {
        // Make sure we get some photo sample buffer
        guard error == nil,
            let photoSampleBuffer = photoSampleBuffer else {
                print("Error capturing photo: \(String(describing: error))")
                return
        }
        
        // Convert photo same buffer to a jpeg image data by using // AVCapturePhotoOutput
        guard let imageData =
            AVCapturePhotoOutput.jpegPhotoDataRepresentation(forJPEGSampleBuffer: photoSampleBuffer, previewPhotoSampleBuffer: previewPhotoSampleBuffer) else {
                return
        }
        // Initialise a UIImage with our image data
        let capturedImage = UIImage.init(data: imageData , scale: 1.0)?.correctlyOrientedImage()
        isUploading = true
        FPRequests.sharedInstance.uploadImageToAWS(image: capturedImage!)
    }
    
    // Find a camera with the specified AVCaptureDevicePosition, returning nil if one is not found
    func cameraWithPosition(_ position: AVCaptureDevice.Position) -> AVCaptureDevice?
    {
        let devices = AVCaptureDevice.devices(for: AVMediaType.video)
        for device in devices {
            if device.position == position {
                return device
            }
        }
        return nil
    }
}
