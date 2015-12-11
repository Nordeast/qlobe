//
//  GameOverParentViewController.swift
//  qlobe
//
//  Created by allen rand on 12/9/15.
//  Copyright © 2015 qlobe. All rights reserved.
//

import UIKit
import AVFoundation

class GameOverParentViewController: UIViewController {
    var upsidedown = false
    
    // MARK: outlets
    
    @IBOutlet weak var GameOverView: UIView!
    @IBOutlet weak var ContinueTop: UIButton!
    @IBOutlet weak var ContinueBottom: UIButton!
    
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
}
