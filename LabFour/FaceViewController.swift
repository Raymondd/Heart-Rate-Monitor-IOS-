//
//  FaceViewController.swift
//
//  Microsloths - Austin Wells & Raymond Martin

import UIKit
import AVFoundation

class FaceViewController: UIViewController {
    var videoManager : VideoAnalgesic! = nil
    let faceFilter :CIFilter = CIFilter(name: "CIRadialGradient")
    let eyeFilter :CIFilter = CIFilter(name: "CIRadialGradient")
    let mouthFilter :CIFilter = CIFilter(name: "CIRadialGradient")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.view.backgroundColor = nil
        
        self.videoManager = VideoAnalgesic.sharedInstance
        
        //controls which camera we use
        self.videoManager.setCameraPosition(AVCaptureDevicePosition.Front)
        
        let redColor = CIColor(red: 2.0, green: 0.2, blue: 0.2, alpha: 0.5)
        let blueColor = CIColor(red: 0.2, green: 0.2, blue: 2.0, alpha: 0.5)
        let greenColor = CIColor(red: 0.2, green: 2.0, blue: 0.2, alpha: 0.2)
        let clear = CIColor(red: 1, green: 1, blue: 1, alpha: 0.0)
        self.faceFilter.setValue(clear, forKey: "inputColor0")
        self.faceFilter.setValue(greenColor, forKey: "inputColor1")
        self.eyeFilter.setValue(clear, forKey: "inputColor0")
        self.eyeFilter.setValue(redColor, forKey: "inputColor1")
        self.mouthFilter.setValue(clear, forKey: "inputColor0")
        self.mouthFilter.setValue(blueColor, forKey: "inputColor1")
        
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
            var imageBuffer = imageInput
            
            for f in features as [CIFaceFeature]{
                let faceWidth = f.bounds.size.width;
                let faceHeight = f.bounds.size.height;
                swappedPoint.x = f.bounds.midX
                swappedPoint.y = f.bounds.midY
                
                //setting up the face gradient
                self.faceFilter.setValue(CIVector(CGPoint: swappedPoint), forKey: "inputCenter")
                self.faceFilter.setValue(faceWidth/2 , forKey: "inputRadius0")
                self.faceFilter.setValue(faceWidth/2 - 10, forKey: "inputRadius1")
                let combineFilter :CIFilter = CIFilter(name: "CISourceOverCompositing")
                combineFilter.setValue(self.faceFilter.outputImage, forKey: "inputImage")
                combineFilter.setValue(imageBuffer, forKey: "inputBackgroundImage")
                imageBuffer = combineFilter.outputImage
                
                if (f.hasLeftEyePosition){
                    //println("Left eye: ", f.leftEyePosition.x, f.leftEyePosition.y);
                    swappedPoint.x = f.leftEyePosition.x
                    swappedPoint.y = f.leftEyePosition.y
                    self.eyeFilter.setValue(CIVector(CGPoint: swappedPoint), forKey: "inputCenter")
                    self.eyeFilter.setValue(faceWidth/12, forKey: "inputRadius0")
                    self.eyeFilter.setValue(faceWidth/12 - 5, forKey: "inputRadius1")
                    
                    
                    combineFilter.setValue(self.eyeFilter.outputImage, forKey: "inputImage")
                    combineFilter.setValue(imageBuffer, forKey: "inputBackgroundImage")
                    imageBuffer = combineFilter.outputImage
                }
                
                if (f.hasRightEyePosition){
                    //println("Right eye: ", f.rightEyePosition.x, f.rightEyePosition.y);
                    swappedPoint.x = f.rightEyePosition.x
                    swappedPoint.y = f.rightEyePosition.y
                    self.eyeFilter.setValue(CIVector(CGPoint: swappedPoint), forKey: "inputCenter")
                    self.eyeFilter.setValue(faceWidth/12, forKey: "inputRadius0")
                    self.eyeFilter.setValue(faceWidth/12 - 5, forKey: "inputRadius1")
                    
                    
                    combineFilter.setValue(self.eyeFilter.outputImage, forKey: "inputImage")
                    combineFilter.setValue(imageBuffer, forKey: "inputBackgroundImage")
                    imageBuffer = combineFilter.outputImage
                }
                
                
                if (f.hasMouthPosition){
                    //print("Mouth: ", f.mouthPosition.x, f.mouthPosition.y);
                    swappedPoint.x = f.mouthPosition.x
                    swappedPoint.y = f.mouthPosition.y
                    self.mouthFilter.setValue(CIVector(CGPoint: swappedPoint), forKey: "inputCenter")
                    self.mouthFilter.setValue(faceWidth/7, forKey: "inputRadius0")
                    self.mouthFilter.setValue(faceWidth/7 - 10, forKey: "inputRadius1")
                    
                    
                    combineFilter.setValue(self.mouthFilter.outputImage, forKey: "inputImage")
                    combineFilter.setValue(imageBuffer, forKey: "inputBackgroundImage")
                    imageBuffer = combineFilter.outputImage
                }
            }
            
            
            return imageBuffer
        })
        
        
        //starting the video manager
        if !self.videoManager.isRunning{
            self.videoManager.start()
        }
    }
    
    //These two overrides ensure there is only one video manager running at a time in our application
    override func viewDidAppear(animated: Bool) {
        if !self.videoManager.isRunning{
            self.videoManager.start()
        }
    }
    
    override func viewDidDisappear(animated: Bool) {
        if(self.videoManager.isRunning){
            self.videoManager.stop()
            self.videoManager.shutdown()
        }
    }


}

