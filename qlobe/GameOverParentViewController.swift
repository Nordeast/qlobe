//
//  GameOverParentViewController.swift
//  qlobe
//
//  Created by allen rand on 12/9/15.
//  Copyright © 2015 qlobe. All rights reserved.
//
//
//  GameOverParentViewController.swift
//  qlobe
//
//  Created by allen rand on 12/9/15.
//  Copyright © 2015 qlobe. All rights reserved.
//
//

import UIKit
import AVFoundation
import Social

class GameOverParentViewController: UIViewController {
    var upsidedown = false
    var redImages : [String] = [ "RedFlex0.png", "RedFlex1.png", "RedFlex2.png", "RedFlex3.png", "RedFlex4.png", "RedFlex5.png", "RedFlex7.png", "RedFlex7.png",]
    var blueImages : [String] = [ "BlueFlex0.png", "BlueFlex1.png", "BlueFlex2.png", "BlueFlex3.png", "BlueFlex4.png", "BlueFlex5.png", "BlueFlex7.png", "BlueFlex7.png",]
    var picture = 0
    var showStats = 0
    var timer = NSTimer()
    var whoWon = -1 // if this is a 1 then p1 won the game
                    // if this is a 2 then p2 won the game
                    // if this is a 3 then the game was a tie
    // MARK: outlets
    
    @IBOutlet weak var ShowFinalGamResults: UIView!
    @IBOutlet weak var WinnerLabel: UILabel!
    @IBOutlet weak var AnimationView: UIView!
    @IBOutlet weak var GameOverView: UIView!
    @IBOutlet weak var ContinueTop: UIButton!
    @IBOutlet weak var ContinueBottom: UIButton!
    @IBOutlet weak var VictoryImage: UIImageView!
    @IBOutlet weak var fbBtnBottom: UIButton!
    @IBOutlet weak var fbBtnTop: UIButton!
    @IBOutlet weak var blueSheepImage: UIImageView!
    
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
        blueSheepImage.flipUpSideDown()
        
        ContinueTop.titleLabel!.font = UIFont(name: "Kankin", size: 25)!
        ContinueTop.setTitleColor(UIColor(netHex: 0xeeeeee), forState: UIControlState.Normal)
        ContinueTop.titleLabel!.text = "Continue"
        ContinueTop.flipUpSideDown()
        
        ContinueBottom.titleLabel!.font = UIFont(name: "Kankin", size: 25)!
        ContinueBottom.setTitleColor(UIColor(netHex: 0xeeeeee), forState: UIControlState.Normal)
        ContinueBottom.titleLabel!.text = "Continue"
        
        
        
        //winner label styling
        
        WinnerLabel.font = UIFont(name: "Kankin", size: 40)
        WinnerLabel.textColor = UIColor(netHex: 0xe74c3c)
        WinnerLabel.textAlignment = NSTextAlignment.Center
        
        // style the facebook button
        fbBtnTop.flipUpSideDown()
        
        // Do any additional setup after loading the view.
        gameOverAudio?.volume = settings.getVolume()
        gameOverAudio!.play()
        
        
        // set victory animation background color
        AnimationView.backgroundColor  = UIColor(netHex: 0x2c3e50)
        
        // hide everything else until the animatin is over
        ShowFinalGamResults.alpha = 0
        ContinueBottom.alpha = 0
        ContinueTop.alpha = 0
        
        // depending on which player won a red or blue animation will play
        // if there is a tie then no animation will play
        
        if(Player1.getTotalPlayerScore() > Player2.getTotalPlayerScore()){
            // say who the winner is
            WinnerLabel.text = "Red is the winner!"
            WinnerLabel.textColor = UIColor(netHex: 0xe74c3c)
            // set the winner variablbe
            whoWon = 1
            // start he flex animation
            runAnimation()
            timer = NSTimer.scheduledTimerWithTimeInterval( ((0.3) * 5) + 1, target: self, selector: "runAnimation",
                userInfo: nil, repeats: true)
            
        }else if( Player1.getTotalPlayerScore() < Player2.getTotalPlayerScore()){
            // say who the winner is
            WinnerLabel.text = "Blue is the Winner!"
            WinnerLabel.textColor = UIColor(netHex: 0x2980b9)
            // set the winner variablbe
            whoWon = 2
            // blue views the screen upside down so show the animation that way
            AnimationView.flipUpSideDown()
            runAnimation()
            // start he flex animation
            timer = NSTimer.scheduledTimerWithTimeInterval( ((0.3) * 5) + 1, target: self, selector: "runAnimation",
                userInfo: nil, repeats: true)
        }else{
            // on a tie then do not show an animation
            AnimationView.alpha = 0
            // set the winner variablbe
            whoWon = 3
            // fade in the results page and continue buttons
            ShowFinalGamResults.fadeIn()
            ContinueBottom.fadeIn()
            ContinueTop.fadeIn()

        }
        
    }
    override func viewDidAppear(animated: Bool) {
        if(whoWon == 3){
            // if its a tie then start the animation for flipping the results page right away
            // because no winner animation will play
            // other wise it will get called when the animation is over
            animateInfinitelyWithDelay(5, duration: 1)

        }
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
    
    
    
    func runAnimation(){
        // run the animation at 70 ms per image
        
        _ = NSTimer.scheduledTimerWithTimeInterval((0.07), target: self, selector: "changeImage",
            userInfo: nil, repeats: false)
        _ = NSTimer.scheduledTimerWithTimeInterval((0.07) * 2, target: self, selector: "changeImage",
            userInfo: nil, repeats: false)
        _ = NSTimer.scheduledTimerWithTimeInterval((0.07) * 3, target: self, selector: "changeImage",
            userInfo: nil, repeats: false)
        _ = NSTimer.scheduledTimerWithTimeInterval((0.07) * 4, target: self, selector: "changeImage",
            userInfo: nil, repeats: false)
        _ = NSTimer.scheduledTimerWithTimeInterval((0.07) * 5, target: self, selector: "changeImage",
            userInfo: nil, repeats: false)
        _ = NSTimer.scheduledTimerWithTimeInterval((0.07) * 6, target: self, selector: "changeImage",
            userInfo: nil, repeats: false)
        _ = NSTimer.scheduledTimerWithTimeInterval((0.07) * 7, target: self, selector: "changeImage",
            userInfo: nil, repeats: false)
        _ = NSTimer.scheduledTimerWithTimeInterval((0.07) * 8, target: self, selector: "changeImage",
            userInfo: nil, repeats: false)
        
        
        
    }
    func changeImage(){
        // change to the next image in the aray
        // if red won then use the red images and if blue won etc...
        if(whoWon == 1){
            picture = (picture + 1) % redImages.count
            VictoryImage.image = UIImage(named: redImages[picture])
        }else{
            picture = (picture + 1) % blueImages.count
            VictoryImage.image = UIImage(named: blueImages[picture])
        }
        
        // increment show stats. when it reaches 40 that means the animation has played long enough
        // and we no longer need to play it
        showStats++
        // fade the animation out and fade in the continue buttons and 
        // the final results
        if(showStats == 40){
            
            ShowFinalGamResults.fadeIn(3, delay: 0, completion: {_ in
                self.animateInfinitelyWithDelay(5, duration: 1)
                self.ContinueTop.fadeIn()
                self.ContinueBottom.fadeIn()
            })
            AnimationView.fadeOut()
            
            timer.invalidate()
        }
    }
    
    
    
    
}
