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
            //analyze the image for the amount of red in it
            
            return inputImage
        }
        
        //turning flash on here causes issues DON"T DO IT AUTSIN! :)
        
        
    }
    
    //These two overrides ensure there is only one video manager running at a time in our application
    override func viewDidAppear(animated: Bool) {
        if !self.videoManager.isRunning{
            self.videoManager.start()
        }
        
    }
    
    
    override func viewDidDisappear(animated: Bool) {
        if(self.videoManager.isRunning){
            self.videoManager.turnOffFlash()
            self.videoManager.stop()
            self.videoManager.shutdown()
        }
    }
    
    @IBAction func toggleFlash(sender: AnyObject) {
        //turning the flash on
        //temporary solution because turning flash on too early in the lifecycle causes issues??
        self.videoManager.toggleFlash()
    }
    
}

