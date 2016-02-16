//
//  ViewController.swift
//  SelfieBook
//
//  Created by Steven Bishop on 2/13/16.
//  Copyright © 2016 Steven Bishop. All rights reserved.
//

import UIKit
import MobileCoreServices
import AVFoundation

class ViewController: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate {

    lazy var cameraOverlayView: CameraOverlayView = {
        let view = NSBundle.mainBundle().loadNibNamed("CameraOverlayView", owner: nil, options: nil).first as! CameraOverlayView
        view.frame = UIScreen.mainScreen().bounds
        return view;
    }()
    
    let captureSession = AVCaptureSession()
    let faceDetector: CIDetector = CIDetector()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    private func captureSetup() {
        
    }


    @IBAction func launchFacetrackingCamera() {
        
        
        captureSession.startRunning()
        
        
    }
    

    
    
}

