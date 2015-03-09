//
//  FaceViewController.swift
//
//  Microsloths - Austin Wells & Raymond Martin

import UIKit
import AVFoundation

class FaceViewController: UIViewController {

    var videoManager : VideoAnalgesic! = nil
    let filter :CIFilter = CIFilter(name: "CIBumpDistortion")
    
   /* @IBAction func panRecognized(sender: AnyObject) {
        let point = sender.translationInView(self.view)
        
        var swappedPoint = CGPoint()
        
        // convert coordinates from UIKit to core image
        var transform = CGAffineTransformIdentity
        transform = CGAffineTransformConcat(transform, CGAffineTransformMakeRotation(CGFloat(M_PI_2)))
        transform = CGAffineTransformConcat(transform, CGAffineTransformMakeScale(-1.0, 1.0))
        transform = CGAffineTransformTranslate(transform, self.view.bounds.size.width/2,
            self.view.bounds.size.height/2)
        
        swappedPoint = CGPointApplyAffineTransform(point, transform);
        
//        filter.setValue(CIVector(CGPoint: swappedPoint), forKey: "inputCenter")

    }*/
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.view.backgroundColor = nil
        
        self.videoManager = VideoAnalgesic.sharedInstance
        
        //controls which camera we use
        self.videoManager.setCameraPosition(AVCaptureDevicePosition.Front)
        
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


}

