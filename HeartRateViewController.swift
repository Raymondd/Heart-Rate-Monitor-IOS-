//
//  HeartRateViewController.swift
//
//  Microsloths - Austin Wells & Raymond Martin

import UIKit
import AVFoundation

class HeartRateViewController: UIViewController {
    var videoManager : VideoAnalgesic! = nil
    let filter :CIFilter = CIFilter(name: "CIBumpDistortion")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        self.view.backgroundColor = nil
        
        self.videoManager = VideoAnalgesic.sharedInstance
        
        //controls which camera we use
        self.videoManager.setCameraPosition(AVCaptureDevicePosition.Front)
        
        //filter adjustments
        self.filter.setValue(-0.5, forKey: "inputScale")
        filter.setValue(75, forKey: "inputRadius")
        
        //creting a detection shceme for you faces
        let optsDetector = [CIDetectorAccuracy:CIDetectorAccuracyLow]
        
        let detector = CIDetector(ofType: CIDetectorTypeFace,
            context: self.videoManager.getCIContext(),
            options: optsDetector)
        
        var optsFace = [CIDetectorImageOrientation:self.videoManager.getImageOrientationFromUIOrientation(UIApplication.sharedApplication().statusBarOrientation)]
        
        //creator our face detection block here
        self.videoManager.setProcessingBlock( { (imageInput) -> (CIImage) in
            
            var features = detector.featuresInImage(imageInput, options: optsFace)
            var swappedPoint = CGPoint()
            for f in features as [CIFaceFeature]{
                NSLog("%@",f)
                swappedPoint.x = f.bounds.midX
                swappedPoint.y = f.bounds.midY
                self.filter.setValue(CIVector(CGPoint: swappedPoint), forKey: "inputCenter")
            }
            
            self.filter.setValue(imageInput, forKey: kCIInputImageKey)
            return self.filter.outputImage
        })
        
        //starting the video manager
        self.videoManager.start()
        

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
        if(!self.videoManager.isRunning){
            self.videoManager.start()
        }
        
        //toggleFlash()
    }
    
    override func viewDidDisappear(animated: Bool) {
        if(self.videoManager.isRunning){
            self.videoManager.stop()
        }
        //toggleFlash()
    }
    
    
}

