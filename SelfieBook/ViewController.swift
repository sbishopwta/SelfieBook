//
//  ViewController.swift
//  SelfieBook
//
//  Created by Steven Bishop on 2/13/16.
//  Copyright © 2016 Steven Bishop. All rights reserved.
//

import UIKit
import MobileCoreServices

class ViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }


    @IBAction func launchFacetrackingCamera() {
        if UIImagePickerController.isSourceTypeAvailable(.Camera) {
            UIImagePickerController.availableMediaTypesForSourceType(UIImagePickerControllerSourceType.Camera)
            let cameraController = UIImagePickerController()
            cameraController.mediaTypes = [kUTTypeLivePhoto as String, kUTTypeImage as String]
            cameraController.delegate = self
            cameraController.sourceType = UIImagePickerControllerSourceType.Camera
            self.presentViewController(cameraController, animated: true, completion: nil)
        }
    }
    
    
    //MARK - UIImagePickerController Delegate
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {

        } else {

        }
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
}

