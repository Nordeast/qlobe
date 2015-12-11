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
import AVFoundation

var menuAudio = try? AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("main_menu", ofType: "mp3")!))

class ViewController: UIViewController {
    
    
    var picture = 0 // counter for the logo animation
    // array of the images in the animation
    var images : [String] = [ "qlobe_logo_smoke0@1x.png", "qlobe_logo_smoke1@1x.png", "qlobe_logo_smoke2@1x.png", "qlobe_logo_smoke3@1x.png", "qlobe_logo_smoke4@1x.png", "qlobe_logo_smoke5@1x.png", "qlobe_logo_smoke6@1x.png", "qlobe_logo_smoke7@1x.png", "qlobe_logo_smoke8@1x.png", "qlobe_logo_smoke9@1x.png", "qlobe_logo_smoke10@1x.png", "qlobe_logo_smoke11@1x.png", "qlobe_logo_smoke12@1x.png", "qlobe_logo_smoke13@1x.png"]

    //var menuAudio = try? AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("main_menu", ofType: "mp3")!))

    // MARK: outlets
    @IBOutlet weak var qlobe_logo: UIImageView!
    @IBOutlet weak var letsBegin: UIButton!
    @IBOutlet weak var settingBtn: UIButton!
    @IBOutlet weak var help: UIButton!
    @IBOutlet weak var muteBtn: UIButton!
    
    // MARK: actions
    
    @IBAction func LetsBegin(sender: AnyObject) {
        //Stop the sound effect
        menuAudio!.stop()
        
        // kill all the animations when the button is pressed
        view.layer.removeAllAnimations()
        
        //reset player scores and rounds
        Player1.NewGame()
        Player2.NewGame()
        ROUND = 1
    }
    
    // MARK: ViewControler functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        stylePage()
        
        // Display the mute icon
        if(settings.isMute()){
            muteBtn.setImage(UIImage(named: "sound_off"), forState: .Normal)
        }
        else{
            muteBtn.setImage(UIImage(named: "sound_on"), forState: .Normal)
        }
        muteBtn.backgroundColor = UIColor(netHex:0x2c3e50)
        
        // Play the main menu sound effect
        menuAudio?.volume = settings.getVolume()
        if(menuAudio!.playing == false){
            menuAudio!.play()
        }
        
        //run the logo animation every 4 seconds. 0.980 is 980ms which is the time the animation takes to run
        _ = NSTimer.scheduledTimerWithTimeInterval(0.980 + 3 , target: self, selector: "runLogoAnimation",
            userInfo: nil, repeats: true)
        
    }
    override func viewDidAppear(animated: Bool) {
        letsBegin.blinkingButton()
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
        settingBtn.titleLabel!.font = UIFont(name: "Kankin", size: 30)!
        settingBtn.setTitleColor(UIColor(netHex: 0xeeeeee), forState: UIControlState.Normal)
        //settingBtn.backgroundColor = UIColor(netHex: 0x464a53)
        settingBtn.titleLabel!.text = "Settings"
        
        // help button
        help.titleLabel!.font = UIFont(name: "Kankin", size: 30)!
        help.setTitleColor(UIColor(netHex: 0xeeeeee), forState: UIControlState.Normal)
        //help.backgroundColor = UIColor(netHex: 0x464a53)
        help.titleLabel!.text = "Help"
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
    
    @IBAction func muteChange(sender: AnyObject) {
        if(settings.isMute() == false){
            settings.setVolumePre(settings.getVolume())
            settings.setVolume(0.0)
            muteBtn.setImage(UIImage(named: "sound_off"), forState: .Normal)
        }
        else{
            settings.setVolume(settings.getVolumePre())
            muteBtn.setImage(UIImage(named: "sound_on"), forState: .Normal)
        }
        menuAudio?.volume = settings.getVolume()
    }
    
    @IBAction func helpBtnPressed(sender: AnyObject) {
        //menuAudio!.stop()
    }
    
    @IBAction func settingBtnPressed(sender: AnyObject) {
        //menuAudio!.stop()
    }
}

