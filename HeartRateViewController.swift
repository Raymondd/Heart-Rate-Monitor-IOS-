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
        self.videoManager.setCameraPosition(AVCaptureDevicePosition.Front)
        
        //starting the video manager
        self.videoManager.start()
    }
    
    
}

