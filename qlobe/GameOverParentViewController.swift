//
//  GameOverParentViewController.swift
//  qlobe
//
//  Created by allen rand on 12/9/15.
//  Copyright © 2015 qlobe. All rights reserved.
//

import UIKit
import AVFoundation
import Social

class GameOverParentViewController: UIViewController {
    var upsidedown = false
    
    // MARK: outlets
    
    @IBOutlet weak var GameOverView: UIView!
    @IBOutlet weak var ContinueTop: UIButton!
    @IBOutlet weak var ContinueBottom: UIButton!
    
    @IBOutlet weak var fbBtnBottom: UIButton!
    @IBOutlet weak var fbBtnTop: UIButton!
    
    var gameOverAudio = try? AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("gameOver", ofType: "mp3")!))
    
    // MARK: actions
    @IBAction func ContinueTop(sender: AnyObject) {
        //segue to start screen
        performSegueWithIdentifier("ReturnToStartScreen", sender: self)
        gameOverAudio!.stop()
    }
    @IBAction func ContinueBottom(sender: AnyObject) {
        // segue to start screen
        performSegueWithIdentifier("ReturnToStartScreen", sender: self)
        gameOverAudio!.stop()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(netHex: 0x2c3e50)
        
        // style continue buttons they will take you to the start screen
        
        ContinueTop.titleLabel!.font = UIFont(name: "Kankin", size: 25)!
        ContinueTop.setTitleColor(UIColor(netHex: 0xeeeeee), forState: UIControlState.Normal)
        ContinueTop.titleLabel!.text = "Continue"
        ContinueTop.flipUpSideDown()
        
        ContinueBottom.titleLabel!.font = UIFont(name: "Kankin", size: 25)!
        ContinueBottom.setTitleColor(UIColor(netHex: 0xeeeeee), forState: UIControlState.Normal)
        ContinueBottom.titleLabel!.text = "Continue"
        
        // style the facebook button
        fbBtnTop.flipUpSideDown()
        
        // Do any additional setup after loading the view.
        gameOverAudio?.volume = settings.getVolume()
        gameOverAudio!.play()
    }
    override func viewDidAppear(animated: Bool) {
        animateInfinitelyWithDelay(5, duration: 1)
        
        ContinueTop.blinkingButton()
        ContinueBottom.blinkingButton()
    }
    
    func animateInfinitelyWithDelay(delay : NSTimeInterval, duration : NSTimeInterval) {
        
        UIView.animateWithDuration(duration, delay: delay, options:[ .CurveEaseInOut, .AllowUserInteraction],
            animations: { () -> Void in
                
                if(self.upsidedown == false){
                    self.GameOverView.transform = CGAffineTransformMakeRotation(CGFloat(M_PI))
                    self.upsidedown = true
                }else{
                    self.GameOverView.transform = CGAffineTransformMakeRotation(CGFloat(0))
                    self.upsidedown = false
                }
                
            } ,completion: { _ in
                
                self.animateInfinitelyWithDelay(delay, duration: duration)
                
        })
        
    }
    
    func takeScreenShot() -> UIImage{
        print("screenshot")
        
        //Create the UIImage
        UIGraphicsBeginImageContext(view!.frame.size)
        view!.layer.renderInContext(UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        //Save it to the camera roll
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
        
        return image
    }
    
    func postToFB(){
        let image = takeScreenShot()
        
        //First we have to check if the user has their Facebook Application installed and if they're logged in.
        if (SLComposeViewController.isAvailableForServiceType(SLServiceTypeFacebook)) {
            let fbShare:SLComposeViewController = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
            
            // Set initial text
            fbShare.setInitialText("- post from qLobe")
            fbShare.addImage(image)
            
            self.presentViewController(fbShare, animated: true, completion: nil)
            
        }
        else
        {
            //If the user has not installed the Facebook app or is not logged in, we create a UIAlertController and notify the user that they need to Login to Facebook to share
            let alert = UIAlertController(title: "Accounts", message: "Please login to a Facebook account to share.", preferredStyle: UIAlertControllerStyle.Alert)
            
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    @IBAction func postToFaceBookBottom(sender: AnyObject) {
        postToFB()
    }

    @IBAction func postToFaceBookTop(sender: AnyObject) {
        postToFB()
    }
}
