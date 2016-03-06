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
    
    var faceOverlayView: UIView = {
        let view = UIView(frame: CGRectMake(0,0,50,50))
        view.backgroundColor = UIColor.redColor()
        view.alpha = 0.6
        
        return view
    }()
    
    let captureSession = AVCaptureSession()
    var faceDetector: CIDetector = CIDetector()
    
    var videoDataOutput : AVCaptureVideoDataOutput?
    var videoDataOutputQueue : dispatch_queue_t?
    var visageCameraView : UIView = UIView()
    var options : [NSObject : AnyObject]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        captureSetup()
        captureSession.startRunning()
       
        self.view.addSubview(visageCameraView)
        self.view.addSubview(self.faceOverlayView)
        
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    private func captureSetup() {
        self.faceDetector = CIDetector(ofType: CIDetectorTypeFace, context: nil, options:  nil)
        var captureDevice : AVCaptureDevice!
        
        for testedDevice in AVCaptureDevice.devicesWithMediaType(AVMediaTypeVideo) {
            if (testedDevice.position == .Front) {
                captureDevice = testedDevice as! AVCaptureDevice
            }
        }
        do {
            let deviceInput = try AVCaptureDeviceInput(device: captureDevice)
            captureSession.sessionPreset = AVCaptureSessionPresetHigh
            captureSession.addInput(deviceInput)
            
            self.videoDataOutput = AVCaptureVideoDataOutput()
            self.videoDataOutput!.videoSettings = [kCVPixelBufferPixelFormatTypeKey: Int(kCVPixelFormatType_32BGRA)]
            self.videoDataOutput!.alwaysDiscardsLateVideoFrames = true
            self.videoDataOutputQueue = dispatch_queue_create("VideoDataOutputQueue", DISPATCH_QUEUE_SERIAL)
            self.videoDataOutput!.setSampleBufferDelegate(self, queue: self.videoDataOutputQueue!)
            
            if (captureSession.canAddOutput(self.videoDataOutput)) {
                captureSession.addOutput(self.videoDataOutput)
            }

        } catch {
            
        }
        
        visageCameraView.frame = UIScreen.mainScreen().bounds
        
        let previewLayer: AVCaptureVideoPreviewLayer = AVCaptureVideoPreviewLayer(session: self.captureSession) 
        previewLayer.frame = UIScreen.mainScreen().bounds
        previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
        visageCameraView.layer.addSublayer(previewLayer)
        
        
    }
    
    func captureOutput(captureOutput: AVCaptureOutput!, didOutputSampleBuffer sampleBuffer: CMSampleBuffer!, fromConnection connection: AVCaptureConnection!) {
        let imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer)
        let opaqueBuffer = Unmanaged<CVImageBuffer>.passUnretained(imageBuffer!).toOpaque()
        let pixelBuffer = Unmanaged<CVPixelBuffer>.fromOpaque(opaqueBuffer).takeUnretainedValue()
        let sourceImage = CIImage(CVPixelBuffer: pixelBuffer, options: nil)
//        options = [CIDetectorSmile : true, CIDetectorEyeBlink: true, CIDetectorImageOrientation : 6]
        
        let features = self.faceDetector.featuresInImage(sourceImage)
        
        if features.count != 0 {
            for feature in features as [CIFeature] {
                if feature.type == CIFeatureTypeFace {
                    print("FACE BOUNDS \(feature.bounds)")
                    dispatch_async(dispatch_get_main_queue(),{

                    self.faceOverlayView.frame = CGRectMake((self.view.frame.width - feature.bounds.origin.x)/2, (self.view.frame.height - feature.bounds.origin.y)/2, feature.bounds.width/2, feature.bounds.height/2)
                    self.view.setNeedsDisplay()
                    })
                }
            }
        } else {
            print("NO FEATURES")
        }
        
    }


    @IBAction func launchFacetrackingCamera() {
        
        
        
        
        
    }
    

    
    
}

