//
//  TapRaceViewController.swift
//  qlobe
//
//  Created by allen rand on 11/10/15.
//  Copyright © 2015 qlobe. All rights reserved.
//

import UIKit
import AVFoundation

class TapRaceViewController: UIViewController {
    
    
    // MARK: Class variables
    var P1Taps : Int = 0 // number of taps for P1
    var P2Taps : Int = 0 // number of taps for P2
    let coloredSquare1 = UIView()// square that races across th screen for P1
    let coloredSquare2 = UIView()// square that races across th screen for P2
    var CS1Position: CGFloat = 0 // holds the current position of P1 racer
    var CS2Position: CGFloat = 0 // holds the current position of P1 racer
    let WIN_TAPS = 43 //number of taps needed to win 43
    var WinningPlayer : Int = 0 // player that wins the game is stored here
    
    var imagesP1: [String] = ["runner1@1x.png", "runner2@1x.png", "runner3@1x.png", "runner4@1x.png"]
    var imageP1 = 0
    
    // ready set go animation times
    let DELAY = 0.7
    let DURATION = 0.3
    let DURATION2 = 0.3
    
    // MARK: Sound effect variables
    var coundownAudio = try? AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("mk64_countdown", ofType: "wav")!))
    
    var backgroundAudio = try? AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("tapRace_background", ofType: "mp3")!))
    
    var victoryAudio = try? AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("tapRace_victory", ofType: "mp3")!))
    
    // MARK: Outlets
    //used for animation
    @IBOutlet weak var P2ImageConstraint: NSLayoutConstraint!
    @IBOutlet weak var RSG1X: NSLayoutConstraint!
    @IBOutlet weak var RSG2X: NSLayoutConstraint!
    // displays ready set go
    @IBOutlet weak var P2ImageConstaintTop: NSLayoutConstraint!
    @IBOutlet weak var P1ImageConstraint: NSLayoutConstraint!
    @IBOutlet weak var P1ImageConstraintBottom: NSLayoutConstraint!
    @IBOutlet weak var readySetGo1: UILabel!
    @IBOutlet weak var readySetGo2: UILabel!
    
    @IBOutlet weak var P2Image: UIImageView!
    //place holder label
    @IBOutlet weak var TapRace: UILabel!
    
    @IBOutlet weak var P1Image: UIImageView!
    // used for when the game is over to display the winner
    @IBOutlet weak var GameOverLabelBottom: UILabel!
    @IBOutlet weak var GameOverLabelTop: UILabel!
    
    // MARK: Button Actions
    
   @IBAction func Player1Tap(sender: AnyObject) {
        // button that P1 taps
        // increase the tap count
        P1Taps++
        // move the racer
        P1Animate()
    
        // if P1 gets to 50 taps then call winner
           if(P1Taps == WIN_TAPS){
            WinningPlayer = 1
            winner()
        }
    
    }
    @IBAction func Player2Tap(sender: AnyObject) {
        // button that P2 taps
        // increase the tap count
        P2Taps++
        // move the racer
        P2Animate()
        
        // if P1 gets to  taps then call winner
        if(P2Taps == WIN_TAPS){
            WinningPlayer = 2
            winner()
            
            // hide the tap buttons

        }
    }
 
    // MARK: Outlets

    
    // MARK: ViewController functions
    override func viewDidLoad() {
        super.viewDidLoad()
                // Do any additional setup after loading the view.
        
        // play the beginning sound effect
        //raceAudioPlayer!.play()
        
        // set up the game buttions
        Player1ButtonSetUp()
        Player2ButtonSetUp()
        
        //make sure nothing is visable until it should be
        Player2Tap.alpha = 0
        Player1Tap.alpha = 0
        coloredSquare2.alpha = 0
        coloredSquare1.alpha = 0
        TapRace.alpha = 0
        readySetGo1.alpha = 0
        readySetGo2.alpha = 0
        GameOverLabelBottom.alpha = 0
        GameOverLabelTop.alpha = 0
        
        // set the background color
        view.backgroundColor = UIColor(netHex:0x2c3e50)
        
        
        // GameOverLabelTop label styling
        GameOverLabelTop.font = UIFont(name: "Kankin", size: 40.0)
        GameOverLabelTop.textColor = UIColor(netHex: 0xeeeeee)
        GameOverLabelTop.textAlignment = NSTextAlignment.Center
        
        // GameOverLabelTop label styling
        GameOverLabelBottom.font = UIFont(name: "Kankin", size: 40.0)
        GameOverLabelBottom.textColor = UIColor(netHex: 0xeeeeee)
        GameOverLabelBottom.textAlignment = NSTextAlignment.Center
        
        // readySetGo1 styling
        
        readySetGo1.font = UIFont(name: "Kankin", size: 80.0)
        readySetGo1.textColor = UIColor(netHex: 0xeeeeee)
        readySetGo1.textAlignment = NSTextAlignment.Center
        
        // readySetGo2 styling
        readySetGo2.font = UIFont(name: "Kankin", size: 80.0)
        readySetGo2.textColor = UIColor(netHex: 0xeeeeee)
        readySetGo2.textAlignment = NSTextAlignment.Center
        
       
    }
    override func viewWillAppear(animated: Bool) {
        
        // set the top label off the screen to the right
        self.RSG2X.constant += self.view.bounds.width
        // set the bottom label off the screen to the right
        self.RSG1X.constant -= self.view.bounds.width
        // flip the ready set go label
        readySetGo2.transform = CGAffineTransformMakeRotation(CGFloat(M_PI))
    }
    
    override func viewDidAppear(animated: Bool) {
        // set up the animation to display ready set go.
        readySetGoAnimation()
        racerSetUp()

    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    // MARK: Helper Functons
    
    func readySetGoAnimation(){
        // displays ready set go before the start of the race

        // make the label to show ready set go visable
        self.readySetGo1.alpha = 1
        self.readySetGo2.alpha = 1
        
        //Start countdown sound effect
        coundownAudio!.play()

        // timers to controll when the animations should start
        _ = NSTimer.scheduledTimerWithTimeInterval(0, target: self, selector: "animateReady",
            userInfo: nil, repeats: false)
        
        _ = NSTimer.scheduledTimerWithTimeInterval(DURATION2 + DURATION + DELAY, target: self, selector: "animateSet",
            userInfo: nil, repeats: false)
        
        _ = NSTimer.scheduledTimerWithTimeInterval((DURATION2 + DURATION + DELAY) * 2, target: self, selector: "animateGo",
            userInfo: nil, repeats: false)
        
        _ = NSTimer.scheduledTimerWithTimeInterval((DURATION2 + DURATION + DELAY) * 3, target: self, selector: "showGame",
            userInfo: nil, repeats: false)
        
    }
    func showGame(){
        //fades the game in after ready,set,go has been displayed
        
        Player2Tap.fadeIn(0.3)
        Player1Tap.fadeIn(0.3)
        coloredSquare2.fadeIn(0.3)
        coloredSquare1.fadeIn(0.3)
        readySetGo1.removeFromSuperview()
        readySetGo2.removeFromSuperview()
        
        //play the background music
        backgroundAudio!.play()
        
    }
    func animateReady(){
        // animates text sliding in and then out for text "ready"
        
        readySetGo2.text = "Ready"
        readySetGo1.text = "Ready"

        // animate the top label in and then out
        UIView.animateWithDuration(self.DURATION, delay: 0.0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
            self.readySetGo2.alpha = 1
            self.RSG2X.constant -= self.view.bounds.width
            self.view.layoutIfNeeded()
            }, completion: { _ in
                UIView.animateWithDuration(self.DURATION2, delay: self.DELAY, options: UIViewAnimationOptions.CurveEaseIn, animations: {
                    self.RSG2X.constant -= self.view.bounds.width
                    self.view.layoutIfNeeded()
                    }, completion: nil)
                
        })
        
        // animate the bottom label in and then out
        UIView.animateWithDuration(self.DURATION, delay: 0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
            self.readySetGo1.alpha = 1
            self.RSG1X.constant += self.view.bounds.width
            self.view.layoutIfNeeded()
            }, completion: { _ in
                
                UIView.animateWithDuration(self.DURATION2, delay: self.DELAY, options: UIViewAnimationOptions.CurveEaseIn, animations: {
                    self.RSG1X.constant += self.view.bounds.width
                    self.view.layoutIfNeeded()
                    }, completion: nil)
                
        })
    }
    func animateSet(){
        
        // animates text sliding in and then out for text "set"
        
        readySetGo2.text = "Set"
        readySetGo1.text = "Set"
        
        // animate the top label in and then out
        UIView.animateWithDuration(self.DURATION, delay: 0.0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
            self.readySetGo2.alpha = 1
            
            self.RSG2X.constant += self.view.bounds.width
            
            self.view.layoutIfNeeded()
            }, completion: { _ in
                UIView.animateWithDuration(self.DURATION2, delay: self.DELAY, options: UIViewAnimationOptions.CurveEaseIn, animations: {
                    self.RSG2X.constant += self.view.bounds.width
                    self.view.layoutIfNeeded()
                    }, completion: nil)
                
        })
        
        // animate the bottom label in and then out
        UIView.animateWithDuration(self.DURATION, delay: 0.0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
            self.readySetGo1.alpha = 1
            self.RSG1X.constant -= self.view.bounds.width
            self.view.layoutIfNeeded()
            }, completion: { _ in
                
                UIView.animateWithDuration(self.DURATION2, delay: self.DELAY, options: UIViewAnimationOptions.CurveEaseIn, animations: {
                    self.RSG1X.constant -= self.view.bounds.width
                    self.view.layoutIfNeeded()
                    }, completion: nil)
                
        })
    }
    func animateGo(){
        
        // animates text sliding in and then out for text "go"

        
        readySetGo2.text = "Go!"
        readySetGo1.text = "Go!"
        
        // animate the top label in and then out
        UIView.animateWithDuration(self.DURATION, delay: 0.0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
            self.readySetGo2.alpha = 1
            
            self.RSG2X.constant -= self.view.bounds.width
            
            self.view.layoutIfNeeded()
            }, completion: { _ in
                UIView.animateWithDuration(self.DURATION2, delay: self.DELAY, options: UIViewAnimationOptions.CurveEaseIn, animations: {
                    self.RSG2X.constant -= self.view.bounds.width
                    self.view.layoutIfNeeded()
                    }, completion: nil)
                
        })
        
        // animate the bottom label in and then out
        UIView.animateWithDuration(self.DURATION, delay: 0.0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
            self.readySetGo1.alpha = 1
            self.RSG1X.constant += self.view.bounds.width
            self.view.layoutIfNeeded()
            }, completion: { _ in
                
                UIView.animateWithDuration(self.DURATION2, delay: self.DELAY, options: UIViewAnimationOptions.CurveEaseIn, animations: {
                    self.RSG1X.constant += self.view.bounds.width
                    self.view.layoutIfNeeded()
                    }, completion: nil)
                
        })
    }


    
    func winner(){
        
        // Stop the background music
        backgroundAudio!.stop()
        
        // Play the victory music
        victoryAudio!.play()
        
        // clear the view to display the winner, this is called when the racers makes it across the screen
        // i.e. when the player reaches the WINTAPS amount
        
        // fad out everything in view
        Player1Tap.fadeOut(1.0, delay: 0, completion: {_ in self.Player1Tap.removeFromSuperview()})
        Player2Tap.fadeOut(1.0, delay: 0, completion: {_ in self.Player2Tap.removeFromSuperview()})
        coloredSquare1.fadeOut(1.0, delay: 0, completion: {_ in  self.coloredSquare1.removeFromSuperview()})
        coloredSquare2.fadeOut(1.0, delay: 0, completion: {_ in  self.coloredSquare2.removeFromSuperview()})

        GameOverLabelTop.flipUpSideDown()
        
        
        // display who won
        // display the players distance
        _ = NSTimer.scheduledTimerWithTimeInterval(2, target: self, selector: "displayWinner",
            userInfo: nil, repeats: false)
        
        _ = NSTimer.scheduledTimerWithTimeInterval(5, target: self, selector: "displayDistance",
            userInfo: nil, repeats: false)
        
        _ = NSTimer.scheduledTimerWithTimeInterval(8, target: self, selector: "segue",
            userInfo: nil, repeats: false)
    }
    func displayWinner(){
        
        UIView.animateWithDuration(1.0, delay: 0, options: [],
            
            animations: {
                self.GameOverLabelTop.alpha = 1
                self.GameOverLabelBottom.alpha = 1
                
                self.GameOverLabelTop.text = "P\(self.WinningPlayer) Wins!"
                self.GameOverLabelBottom.text = "P\(self.WinningPlayer) Wins!"
                
            },
            
            completion: { _ in
                
                self.GameOverLabelBottom.fadeOut()
                self.GameOverLabelTop.fadeOut()
                }
        )
        
    }
    func displayDistance(){
        //animate the distance the players went
        self.GameOverLabelBottom.fadeIn()
        self.GameOverLabelTop.fadeIn()
        UIView.animateWithDuration(1.0, delay: 0, options: [], animations: {

            self.GameOverLabelTop.text = "Your distance: \((self.P2Taps) * 200) feet."
            self.GameOverLabelBottom.text = "Your distance: \((self.P1Taps) * 200) feet."
            },
            completion: { _ in
                self.GameOverLabelTop.fadeOut(1.0, delay: 3, completion:
                    {_ in self.GameOverLabelTop.removeFromSuperview()})
                
                self.GameOverLabelBottom.fadeOut(1.0, delay: 3, completion:
                    {_ in self.GameOverLabelBottom.removeFromSuperview()})

                

            })
        
    }
    func segue(){
        // segue to scoreboard view controller
        self.performSegueWithIdentifier("ScoreBoardFromTapRace", sender: self)
    }
    

    
    var image1 = UIImageView()
    func racerSetUp(){
        
        // Create and add both the racers
        
        // set background color to green
        coloredSquare2.backgroundColor = UIColor(patternImage: UIImage(imageLiteral: "runner1@1x.png"))
        
        // set frame (position and size) of the square
        P2ImageConstaintTop.constant = self.view.bounds.height/2 + 60

        coloredSquare2.frame = CGRect(x: 0, y: view.bounds.height/2 - 78, width: 40, height: 40)
       
        // finally, add the square to the screen
        //self.view.addSubview(coloredSquare2)
        
        P1ImageConstraintBottom.constant = self.view.bounds.height/2 - 60
        P1Image.image = UIImage(named: imagesP1[imageP1])
        
        // set frame (position and size) of the square
        //coloredSquare1.frame = CGRect(x: 0, y: view.bounds.height/2 + 30, width: 40, height: 40)
        
        // finally, add the square to the screen
        //self.view.addSubview(coloredSquare1)
        
    }
    
    func P1Animate(){
        
        // do the animation when a button is pressed. Move the racer across the screen 1/50th at a time
        imageP1 = (imageP1 + 1) % 4
        print(imageP1)
        
        UIView.animateWithDuration(0.5, animations: {
            
            
            // increment the distance of where the image is.
            self.CS1Position = self.CS1Position + self.view.bounds.width / 50

            // if statement will stop the animation from going off the screen
            if(self.CS1Position <= self.view.bounds.width - 60){
                self.P1ImageConstraint.constant = self.CS1Position
                self.P1Image.image = UIImage(named: self.imagesP1[self.imageP1])
            }
            
        })
        
    }
    
    func P2Animate(){
        
        // do the animation when a button is pressed. Move the racer across the screen 1/50th at a time
        
        UIView.animateWithDuration(0.5, animations: {
            if self.coloredSquare2.backgroundColor == UIColor.greenColor(){
                self.coloredSquare2.backgroundColor = UIColor.blueColor()
            }
            else{
                self.coloredSquare2.backgroundColor = UIColor.greenColor()
            }
            // increment the distance of where the image is.
            self.CS2Position = self.CS2Position + self.view.bounds.width / 50

            
            // if statement will stop the animation from going off the screen
            if(self.CS2Position <= self.view.bounds.width - 40){
                self.coloredSquare2.frame = CGRect(x: self.CS2Position, y: self.coloredSquare2.center.y - 25, width: 50, height: 50)
            }
            }, completion: {_ in
                
            })
        
    }
    
    
    // MARK: buttons
    
    // button 1 (bottom of the screen)
    var Player1Tap: UIButton!
    
    func Player1ButtonSetUp() {
        // set up and add the button programically
        Player1Tap = UIButton(type: UIButtonType.System) // .System
        
        // set button title
        Player1Tap.setTitle("TAP!", forState: UIControlState.Normal)

        // button text color, background and font
        Player1Tap.setTitleColor(UIColor(netHex: 0xeeeeee), forState: UIControlState.Normal)
        Player1Tap.backgroundColor = UIColor.redColor()
        Player1Tap.titleLabel!.font = UIFont(name: "Kankin", size: 50.0)

        // add the action
        Player1Tap.addTarget(self, action: Selector("Player1Tap:"), forControlEvents: UIControlEvents.TouchUpInside)

        // add the button to the view
        self.view.addSubview(Player1Tap)
        
        // disable all other autolayout constraints for this button
        Player1Tap.translatesAutoresizingMaskIntoConstraints = false
        
        // create the autolayout constraints programically
        // left edge
        let leftButtonEdgeConstraint = NSLayoutConstraint(item: Player1Tap, attribute: NSLayoutAttribute.Leading, relatedBy: NSLayoutRelation.Equal, toItem: view, attribute: NSLayoutAttribute.LeadingMargin, multiplier: 1.0, constant: 0)
        // right edge
        let rightButtonEdgeConstraint = NSLayoutConstraint(item: Player1Tap, attribute: NSLayoutAttribute.Trailing, relatedBy: NSLayoutRelation.Equal, toItem: view, attribute: NSLayoutAttribute.TrailingMargin, multiplier: 1.0, constant: 0)
        
        // bottom
        let bottomButtonConstraint = NSLayoutConstraint(item: Player1Tap, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: view, attribute: NSLayoutAttribute.BottomMargin, multiplier: 1.0, constant: -28)
        // top
        let topButtonConstraint = NSLayoutConstraint(item: Player1Tap, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: view, attribute: NSLayoutAttribute.CenterY, multiplier: 1.0, constant: 225)
        
        // add all constraints
        self.view.addConstraints([leftButtonEdgeConstraint, rightButtonEdgeConstraint, bottomButtonConstraint, topButtonConstraint])
        
        
    }
    
    // button 2 (top of the screen)
    var Player2Tap: UIButton!
    
    func Player2ButtonSetUp() {
        // set up and add the button programically
        Player2Tap = UIButton(type: UIButtonType.System) // .System
        // set button title
        Player2Tap.setTitle("TAP!", forState: UIControlState.Normal)
        
        // button text color, background and font
        Player2Tap.setTitleColor(UIColor(netHex: 0xeeeeee), forState: UIControlState.Normal)
        Player2Tap.backgroundColor = UIColor.blueColor()
        Player2Tap.titleLabel!.font = UIFont(name: "Kankin", size: 50.0)
        
        // add the action
        Player2Tap.addTarget(self, action: Selector("Player2Tap:"), forControlEvents: UIControlEvents.TouchUpInside)
        
        // add the button to the view
        self.view.addSubview(Player2Tap)
        
        // disable all other autolayout constraints for this button
        Player2Tap.translatesAutoresizingMaskIntoConstraints = false
        
        // create the autolayout constraints programically
        // left edge
        let leftButtonEdgeConstraint = NSLayoutConstraint(item: Player2Tap, attribute: NSLayoutAttribute.Leading, relatedBy: NSLayoutRelation.Equal, toItem: view, attribute: NSLayoutAttribute.LeadingMargin, multiplier: 1.0, constant: 0)
        // right edge
        let rightButtonEdgeConstraint = NSLayoutConstraint(item: Player2Tap, attribute: NSLayoutAttribute.Trailing, relatedBy: NSLayoutRelation.Equal, toItem: view, attribute: NSLayoutAttribute.TrailingMargin, multiplier: 1.0, constant: 0)

        // bottom
        let topButtonConstraint = NSLayoutConstraint(item: Player2Tap, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: view, attribute: NSLayoutAttribute.TopMargin, multiplier: 1.0, constant: 28)
        // top
        let bottomButtonConstraint = NSLayoutConstraint(item: Player2Tap, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: view, attribute: NSLayoutAttribute.CenterY, multiplier: 1.0, constant: -225)
        
        // add all constraints
        self.view.addConstraints([leftButtonEdgeConstraint, rightButtonEdgeConstraint, bottomButtonConstraint, topButtonConstraint])
        
        // flip the button
        Player2Tap.transform = CGAffineTransformMakeRotation(CGFloat(M_PI))
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
