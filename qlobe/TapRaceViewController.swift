//
//  TapRaceViewController.swift
//  qlobe
//
//  Created by allen rand on 11/10/15.
//  Copyright © 2015 qlobe. All rights reserved.
//

import UIKit
import AVFoundation

@IBDesignable

class TapRaceViewController: UIViewController {
    
    
    // MARK: Class variables
    var P1Taps : Int = 0 // number of taps for P1
    var P2Taps : Int = 0 // number of taps for P2
    var CS1Position: CGFloat = 0 // holds the current position of P1 racer
    var CS2Position: CGFloat = 0 // holds the current position of P1 racer
    let WIN_TAPS = 41 //number of taps needed to win 41
    var WinningPlayer : Int = 0 // player that wins the game is stored here
    var gameOver : Bool = false // is the game over ?
    
    // array of images for the running animation
    var imagesP1: [String] = ["RedRunner1@1x.png", "RedRunner2@1x.png", "RedRunner3@1x.png", "RedRunner4@1x.png"]
    var imagesP2: [String] = ["BlueRunner1@1x.png","BlueRunner2@1x.png","BlueRunner3@1x.png","BlueRunner4@1x.png"]
    // controls which animation image is next
    var imageP2 = 0
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
        // these contraints are for moving the runner across the screen
    @IBOutlet weak var RSG1X: NSLayoutConstraint!
    @IBOutlet weak var RSG2X: NSLayoutConstraint!
    // displays ready set go
    @IBOutlet weak var readySetGo1: UILabel!
    @IBOutlet weak var readySetGo2: UILabel!
    @IBOutlet weak var ReadySetGo1Bottom: NSLayoutConstraint!
    @IBOutlet weak var ReadySetGo2Top: NSLayoutConstraint!
    
    // layout contraints for the running guys
    @IBOutlet weak var P1ImageConstraintBottom: NSLayoutConstraint!
    @IBOutlet weak var P2ImageConstraintTop: NSLayoutConstraint!
    @IBOutlet weak var P1ImageConstraint: NSLayoutConstraint!
    @IBOutlet weak var P2ImageConstraint: NSLayoutConstraint!
    
    //place holder label
    @IBOutlet weak var TapRace: UILabel!
    
    // images for the running guy
    @IBOutlet weak var P2Image: UIImageView!
    @IBOutlet weak var P2ImageWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var P1ImageWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var P2ImageHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var P1ImageHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var P1Image: UIImageView!
    
    // used for when the game is over to display the winner
    @IBOutlet weak var BottomGameOverTextField: UITextView!
    @IBOutlet weak var TopGameOverTextFieldContraint: NSLayoutConstraint!
    @IBOutlet weak var BottomGameOverTextFieldContraint: NSLayoutConstraint!
    @IBOutlet weak var TopGameOverTextField: UITextView!

    // MARK: Button Actions
    
   @IBAction func Player1Tap(sender: AnyObject) {
        // button that P1 taps
        // increase the tap count
        P1Taps++
        // move the racer
        P1Animate()
    
        // if P1 gets to 50 taps then call winner
           if(P1Taps == WIN_TAPS){
            Player1Tap.enabled = false
            Player2Tap.enabled = false
            
            if(gameOver == false){
                gameOver      = true
                WinningPlayer = 1
                winner()
            }
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
            Player1Tap.enabled = false
            Player2Tap.enabled = false
            
            if(gameOver == false){
                gameOver      = true
                WinningPlayer = 2
                winner()
            }
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
        P1Image.alpha = 0
        P2Image.alpha = 0
        TapRace.alpha = 0
        readySetGo1.alpha = 0
        readySetGo2.alpha = 0
        BottomGameOverTextField.alpha = 0
        TopGameOverTextField.alpha = 0
        
        //account for volume setting
        coundownAudio?.volume = settings.getVolume()
        backgroundAudio?.volume = settings.getVolume()
        victoryAudio?.volume = settings.getVolume()
        
        // set the background color
        view.backgroundColor = UIColor(netHex:0x2c3e50)
        
        // no Idea why but the editable and selectable fields must be set to true
        // while changing the display properties of a textview then they must be 
        // reset to false after they have been changed
        TopGameOverTextField.editable = true
        BottomGameOverTextField.editable = true
        TopGameOverTextField.selectable = true
        BottomGameOverTextField.selectable = true
        
        // GameOverLabelTop label styling
        TopGameOverTextField.font = UIFont(name: "Kankin", size: 40.0)
        TopGameOverTextField.textColor = UIColor(netHex: 0xeeeeee)
        TopGameOverTextField.textAlignment = NSTextAlignment.Center
        TopGameOverTextField.backgroundColor = UIColor(netHex:0x2c3e50)
        
        // GameOverLabelTop label styling
        BottomGameOverTextField.font = UIFont(name: "Kankin", size: 40.0)
        BottomGameOverTextField.textColor = UIColor(netHex: 0xeeeeee)
        BottomGameOverTextField.textAlignment = NSTextAlignment.Center
        BottomGameOverTextField.backgroundColor = UIColor(netHex:0x2c3e50)
        
        // set them back to false
        TopGameOverTextField.editable = false
        BottomGameOverTextField.editable = false
        TopGameOverTextField.selectable = false
        BottomGameOverTextField.selectable = false
        
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
        readySetGo2.flipUpSideDown()
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
        
        // set were the ready set go should be placed
        ReadySetGo1Bottom.constant = (view.bounds.height/4)
        ReadySetGo2Top.constant = (view.bounds.height/4)
        
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
        P1Image.fadeIn()
        P2Image.fadeIn()
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
        P1Image.fadeOut(1.0, delay: 0, completion: {_ in  self.P1Image.removeFromSuperview()})
        P2Image.fadeOut(1.0, delay: 0, completion: {_ in  self.P2Image.removeFromSuperview()})

        TopGameOverTextField.flipUpSideDown()
        
        // maximum score is 2500 for a perfect game. Basically if the other side doesnt move
        // per step the winning player wins by they get 2500/41 points
        var addToWinnersScore = 0
        
        if(WinningPlayer == 1){
            addToWinnersScore = (2500/41) * (P1Taps - P2Taps)
            Player2.addScore(ROUND - 1, game : "TapRace", score: 0)
            Player1.addScore(ROUND - 1, game : "TapRace", score: addToWinnersScore)

        }else{
            addToWinnersScore = (2500/41) * (P2Taps - P1Taps)
            Player2.addScore(ROUND - 1, game : "TapRace", score: addToWinnersScore)
            Player1.addScore(ROUND - 1, game : "TapRace", score: 0)
        }
        
        
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
                self.TopGameOverTextField.alpha = 1
                self.BottomGameOverTextField.alpha = 1
                
                if(self.WinningPlayer == 1){
                    self.TopGameOverTextField.text = "Red Wins!"
                    self.BottomGameOverTextField.text = "Red Wins!"
                }else{
                    self.TopGameOverTextField.text = "Blue Wins!"
                    self.BottomGameOverTextField.text = "Blue Wins!"
                }
                                
            },
            
            completion: { _ in
                
                self.BottomGameOverTextField.fadeOut()
                self.TopGameOverTextField.fadeOut()
                }
        )
        
    }
    func displayDistance(){
        //animate the distance the players went
        self.BottomGameOverTextField.fadeIn()
        self.TopGameOverTextField.fadeIn()
        UIView.animateWithDuration(1.0, delay: 0, options: [], animations: {

            self.TopGameOverTextField.text = "Your distance: \((self.P2Taps) * 200) feet."
            self.BottomGameOverTextField.text = "Your distance: \((self.P1Taps) * 200) feet."
            },
            completion: { _ in
                self.TopGameOverTextField.fadeOut(1.0, delay: 3, completion:
                    {_ in self.TopGameOverTextField.removeFromSuperview()})
                
                self.BottomGameOverTextField.fadeOut(1.0, delay: 3, completion:
                    {_ in self.BottomGameOverTextField.removeFromSuperview()})

                

            })
        
    }
    func segue(){
        // segue to scoreboard view controller
        if(ROUND == numberOfRoundsPerMatch){
            performSegueWithIdentifier("TapRaceGameOver", sender: self)
        }else{
            self.performSegueWithIdentifier("ScoreBoardFromTapRace", sender: self)
            
        }
    }
    

    
    
    func racerSetUp(){
        
        // dynamically size the height, width and placement of the runners based off of screen size
        P2ImageHeightConstraint.constant = (view.bounds.width / 6) - 10
        P1ImageHeightConstraint.constant = (view.bounds.width / 6) -  10
        P2ImageWidthConstraint.constant = (view.bounds.width / 6) - 10
        P1ImageWidthConstraint.constant = (view.bounds.width / 6) - 10
        P1ImageConstraintBottom.constant = view.bounds.height/3 + 10 + 28
        P2ImageConstraintTop.constant = view.bounds.height/3 + 10 + 30
        
        // load the images in to the image view
        
        P2Image.image = UIImage(named: imagesP2[imageP2])
        P2Image.flipUpSideDown()
        // load the images into the image view
        
        P1Image.image = UIImage(named: imagesP1[imageP1])
        
    }
    
    func P1Animate(){
        
        // do the animation when a button is pressed. Move the racer across the screen 1/50th at a time
        imageP1 = (imageP1 + 1) % 4 // cycle through the images
        
        
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
        imageP2 = (imageP2 + 1) % 4 // cycle throught the images
        
        UIView.animateWithDuration(0.5, animations: {
            
            
            // increment the distance of where the image is.
            self.CS2Position = self.CS2Position + self.view.bounds.width / 50
            
            // if statement will stop the animation from going off the screen
            if(self.CS2Position <= self.view.bounds.width - 60){
                self.P2ImageConstraint.constant = self.CS2Position
                self.P2Image.image = UIImage(named: self.imagesP2[self.imageP2])
            }
            
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
        Player1Tap.backgroundColor = UIColor(netHex: 0xc0392b)
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
        let bottomButtonConstraint = NSLayoutConstraint(item: Player1Tap, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: view, attribute: NSLayoutAttribute.Bottom, multiplier: 1.0, constant: -28)
        // top
        let topButtonHeight = NSLayoutConstraint(item: Player1Tap, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1.0, constant: (view.bounds.height / 3))
        //let topButtonConstraint = NSLayoutConstraint(item: Player1Tap, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: view, attribute: NSLayoutAttribute.CenterY, multiplier: 1.0, constant: 200)
        // add all constraints
        Player1Tap.addConstraints([topButtonHeight])
        self.view.addConstraints([leftButtonEdgeConstraint, rightButtonEdgeConstraint, bottomButtonConstraint])
        
        
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
        Player2Tap.backgroundColor = UIColor(netHex: 0x2980b9)
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

        //top
        let topButtonConstraint = NSLayoutConstraint(item: Player2Tap, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: view, attribute: NSLayoutAttribute.Top, multiplier: 1.0, constant: 40)
        
        //bottom
        let bottomButtonHeight = NSLayoutConstraint(item: Player2Tap, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1.0, constant: (view.bounds.height / 3))
        
        // add all constraints
        Player2Tap.addConstraints([bottomButtonHeight])
        
        self.view.addConstraints([leftButtonEdgeConstraint, rightButtonEdgeConstraint, topButtonConstraint])
        
        // flip the button
        Player2Tap.flipUpSideDown()
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
