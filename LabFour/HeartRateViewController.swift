//
//  HeartRateViewController.swift
//
//  Microsloths - Austin Wells & Raymond Martin

import UIKit
import AVFoundation

class HeartRateViewController: UIViewController {
    var videoManager : VideoAnalgesic! = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        self.view.backgroundColor = nil
        
        self.videoManager = VideoAnalgesic.sharedInstance
        
        //controls which camera we use
        self.videoManager.setCameraPosition(AVCaptureDevicePosition.Back)
        
        //processing block to return the raw image
        self.videoManager.setProcessingBlock(){(inputImage:CIImage)->(CIImage) in
            return inputImage
        }
        
        //starting the video manager
        if !self.videoManager.isRunning{
            self.videoManager.start()
        }
        
    }
    
    
    /*
    //Eric's class and this function are fighting over the right to use AVCapture, so i am not sure how to turn the torch on with changing his code????? HALP?
    func toggleFlash() {
        let device = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
        if (device.hasTorch) {
            device.lockForConfiguration(nil)
            if (device.torchMode == AVCaptureTorchMode.On) {
                device.torchMode = AVCaptureTorchMode.Off
            } else {
                device.setTorchModeOnWithLevel(1.0, error: nil)
            }
            device.unlockForConfiguration()
        }
    }*/

    
    
    //These two overrides ensure there is only one video manager running at a time in our application
    override func viewDidAppear(animated: Bool) {
        if !self.videoManager.isRunning{
            self.videoManager.start()
        }
        
        //toggleFlash()
    }
    
    
    override func viewDidDisappear(animated: Bool) {
        if(self.videoManager.isRunning){
            self.videoManager.stop()
            self.videoManager.shutdown()
        }
        
        //toggleFlash()
    }
    
    
}

