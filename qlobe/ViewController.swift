//
//  ViewController.swift
//  qlobe
//
//  Created by allen rand on 10/27/15.
//  Copyright © 2015 qlobe. All rights reserved.
//


// Colors
// pomegranete (redish)(horns) - #c0392b
// alizarin (lighter red)(eyes and nose) - #e74c3c
// gray (button backgrounds)- #464a53
// light gray (font) - #eeeeee
// Dark blue (app background) - #2c3e50
// custom font Kankin. to use letsBegin.titleLabel!.font = UIFont(name: "Kankin", size: 50)!

import UIKit

class ViewController: UIViewController {
    
    
    var picture = 0 // counter for the logo animation
    // array of the images in the animation
    var images : [String] = [ "qlobe_logo_smoke0@1x.png", "qlobe_logo_smoke1@1x.png", "qlobe_logo_smoke2@1x.png", "qlobe_logo_smoke3@1x.png", "qlobe_logo_smoke4@1x.png", "qlobe_logo_smoke5@1x.png", "qlobe_logo_smoke6@1x.png", "qlobe_logo_smoke7@1x.png", "qlobe_logo_smoke8@1x.png", "qlobe_logo_smoke9@1x.png", "qlobe_logo_smoke10@1x.png", "qlobe_logo_smoke11@1x.png", "qlobe_logo_smoke12@1x.png", "qlobe_logo_smoke13@1x.png"]
    

    // MARK: outlets
    @IBOutlet weak var qlobe_logo: UIImageView!
    
    
    @IBOutlet weak var letsBegin: UIButton!
    
    @IBOutlet weak var settings: UIButton!
    
    @IBOutlet weak var help: UIButton!
    
    @IBOutlet weak var spacer2: UILabel!
    
    @IBAction func LetsBegin(sender: AnyObject) {
        // kill all the animations when the button is pressed
        view.layer.removeAllAnimations()
    }
    
    // MARK: ViewControler functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        spacer2.alpha = 0
        stylePage()
        
        //run the logo animation every 4 seconds. 0.980 is 980ms which is the time the animation takes to run
        _ = NSTimer.scheduledTimerWithTimeInterval(0.980 + 3 , target: self, selector: "runLogoAnimation",
            userInfo: nil, repeats: true)
        
    }
    override func viewDidAppear(animated: Bool) {
        blinkingButtons()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    // MARK: Helper functions
    func stylePage(){
        // background
        view.backgroundColor = UIColor(netHex:0x2c3e50)
        
        // lets begin button
        letsBegin.titleLabel!.font = UIFont(name: "Kankin", size: 50)!
        letsBegin.setTitleColor(UIColor(netHex: 0xeeeeee), forState: UIControlState.Normal)
        //letsBegin.backgroundColor = UIColor(netHex: 0x464a53)
        letsBegin.titleLabel!.text = "Let's Begin"
        
        
        // settings button
        settings.titleLabel!.font = UIFont(name: "Kankin", size: 30)!
        settings.setTitleColor(UIColor(netHex: 0xeeeeee), forState: UIControlState.Normal)
        //settings.backgroundColor = UIColor(netHex: 0x464a53)
        settings.titleLabel!.text = "Settings"
        
        // help button
        help.titleLabel!.font = UIFont(name: "Kankin", size: 30)!
        help.setTitleColor(UIColor(netHex: 0xeeeeee), forState: UIControlState.Normal)
        //help.backgroundColor = UIColor(netHex: 0x464a53)
        help.titleLabel!.text = "Help"
    }
    
    func blinkingButtons(){
        
        
        UIView.animateWithDuration(0.6, delay: 0, options: [.Repeat, .Autoreverse, .AllowUserInteraction],
            
            animations: {
                
                self.letsBegin.titleLabel!.alpha = 0.4
                
            },
            
            completion: nil)
        
    }
    
    func runLogoAnimation(){
        // run the animation at 70 ms per image
        
        _ = NSTimer.scheduledTimerWithTimeInterval(0.07, target: self, selector: "changeImage",
                userInfo: nil, repeats: false)
        _ = NSTimer.scheduledTimerWithTimeInterval(0.07 * 2, target: self, selector: "changeImage",
            userInfo: nil, repeats: false)
        _ = NSTimer.scheduledTimerWithTimeInterval(0.07 * 3, target: self, selector: "changeImage",
            userInfo: nil, repeats: false)
        _ = NSTimer.scheduledTimerWithTimeInterval(0.07 * 4, target: self, selector: "changeImage",
            userInfo: nil, repeats: false)
        _ = NSTimer.scheduledTimerWithTimeInterval(0.07 * 5, target: self, selector: "changeImage",
            userInfo: nil, repeats: false)
        _ = NSTimer.scheduledTimerWithTimeInterval(0.07 * 6, target: self, selector: "changeImage",
            userInfo: nil, repeats: false)
        _ = NSTimer.scheduledTimerWithTimeInterval(0.07 * 7, target: self, selector: "changeImage",
            userInfo: nil, repeats: false)
        _ = NSTimer.scheduledTimerWithTimeInterval(0.07 * 8, target: self, selector: "changeImage",
            userInfo: nil, repeats: false)
        _ = NSTimer.scheduledTimerWithTimeInterval(0.07 * 9, target: self, selector: "changeImage",
            userInfo: nil, repeats: false)
        _ = NSTimer.scheduledTimerWithTimeInterval(0.07 * 10, target: self, selector: "changeImage",
            userInfo: nil, repeats: false)
        _ = NSTimer.scheduledTimerWithTimeInterval(0.07 * 11, target: self, selector: "changeImage",
            userInfo: nil, repeats: false)
        _ = NSTimer.scheduledTimerWithTimeInterval(0.07 * 12, target: self, selector: "changeImage",
            userInfo: nil, repeats: false)
        _ = NSTimer.scheduledTimerWithTimeInterval(0.07 * 13, target: self, selector: "changeImage",
            userInfo: nil, repeats: false)

        
    }
    func changeImage(){
        // change to the next image in the aray
        
        picture = (picture + 1) % 13
        qlobe_logo.image = UIImage(named: images[picture])

    }
}

