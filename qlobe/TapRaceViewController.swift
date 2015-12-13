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
    var CS1Position: CGFloat = -20 // holds the current position of P1 racer
    var CS2Position: CGFloat = -20// holds the current position of P1 racer
    let WIN_TAPS = 64 //number of taps needed to win 64
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
    
    // layout contraints for the running guys
    @IBOutlet weak var P1ImageConstraint: NSLayoutConstraint!
    @IBOutlet weak var P2ImageConstraint: NSLayoutConstraint!
    // button outlets
    @IBOutlet weak var Player1Tap: UIButton!
    @IBOutlet weak var Player2Tap: UIButton!

    // images for the running guy
    @IBOutlet weak var P2Image: UIImageView!
    @IBOutlet weak var P1Image: UIImageView!
    
    // MARK: Button Actions
    
   @IBAction func Player1Tap(sender: AnyObject) {
        // button that P1 taps
        // increase the tap count
        P1Taps++
        //print(P1Taps)
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
        readySetGo1.alpha = 0
        readySetGo2.alpha = 0
        
        //account for volume setting
        coundownAudio?.volume = settings.getVolume()
        backgroundAudio?.volume = settings.getVolume()
        victoryAudio?.volume = settings.getVolume()
        
        // set the background color
        view.backgroundColor = UIColor(netHex:0x2c3e50)
        
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
        readySetGo2.alpha = 0
        readySetGo1.alpha = 0
        self.RSG1X.constant -= self.view.bounds.width
        self.RSG2X.constant += self.view.bounds.width
        Player2Tap.fadeIn(0.3)
        Player1Tap.fadeIn(0.3)
        P1Image.fadeIn()
        P2Image.fadeIn()
        
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
                self.readySetGo1.alpha = 1
                self.readySetGo2.alpha = 1
                
                if(self.WinningPlayer == 1){
                    self.readySetGo1.textColor = UIColor(netHex: 0xe74c3c)
                    self.readySetGo2.textColor = UIColor(netHex: 0xe74c3c)
                    self.readySetGo2.text = "Red Wins!"
                    self.readySetGo1.text = "Red Wins!"
                }else{
                    self.readySetGo1.textColor = UIColor(netHex: 0x2980b9)
                    self.readySetGo2.textColor = UIColor(netHex: 0x2980b9)
                    self.readySetGo2.text = "Blue Wins!"
                    self.readySetGo1.text = "Blue Wins!"
                }
                                
            },
            
            completion: { _ in
                
                self.readySetGo2.fadeOut()
                self.readySetGo1.fadeOut()
                }
        )
        
    }
    func displayDistance(){
        //animate the distance the players went

        UIView.animateWithDuration(1.0, delay: 0, options: [], animations: {
            self.readySetGo1.alpha = 1
            self.readySetGo2.alpha = 1
            self.readySetGo1.textColor = UIColor(netHex: 0xe74c3c)
            self.readySetGo2.textColor = UIColor(netHex: 0x2980b9)
            self.readySetGo1.font = UIFont(name: "Kankin", size: 50.0)
            self.readySetGo2.font = UIFont(name: "Kankin", size: 50.0)
            self.readySetGo1.text = "distance: \((self.P1Taps) * 200) ft"
            self.readySetGo2.text = "distance: \((self.P2Taps) * 200) ft"
            },
            completion: { _ in
                self.readySetGo1.fadeOut(1.0, delay: 3, completion:
                    {_ in self.readySetGo1.removeFromSuperview()})
                
                self.readySetGo2.fadeOut(1.0, delay: 3, completion:
                    {_ in self.readySetGo2.removeFromSuperview()})

                

            })
        
    }
    func segue(){
        // segue to scoreboard view controller
        //print("Round #: \(ROUND) in \(numberOfRoundsPerMatch)")
        if(ROUND == numberOfRoundsPerMatch){
            performSegueWithIdentifier("TapRaceGameOver", sender: self)
        }else{
            self.performSegueWithIdentifier("ScoreBoardFromTapRace", sender: self)
            
        }
        
        //continue playing the game
        // end of the round so increment the round
        ROUND++
    }
    

    
    
    func racerSetUp(){
        
        // dynamically size the height, width and placement of the runners based off of screen size
        
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
            self.CS1Position = self.CS1Position + self.view.bounds.width / 80

            // if statement will stop the animation from going off the screen
            if(self.CS1Position <= self.view.bounds.width - 100){
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
            self.CS2Position = self.CS2Position + self.view.bounds.width / 80
            
            // if statement will stop the animation from going off the screen
            if(self.CS2Position <= self.view.bounds.width - 100){
                self.P2ImageConstraint.constant = self.CS2Position
                self.P2Image.image = UIImage(named: self.imagesP2[self.imageP2])
            }
            
        })

        
    }
    
    // MARK: buttons
    
    // button 1 (bottom of the screen)
    
  
    func Player1ButtonSetUp() {
        Player1Tap.setTitle("TAP!", forState: UIControlState.Normal)

        // button text color, background and font
        Player1Tap.setTitleColor(UIColor(netHex: 0xeeeeee), forState: UIControlState.Normal)
        Player1Tap.backgroundColor = UIColor(netHex: 0xc0392b)
        Player1Tap.titleLabel!.font = UIFont(name: "Kankin", size: 50.0)
    }
    
    // button 2 (top of the screen)
    

    
    func Player2ButtonSetUp() {
        
        // set button title
        Player2Tap.setTitle("TAP!", forState: UIControlState.Normal)
        
        // button text color, background and font
        Player2Tap.setTitleColor(UIColor(netHex: 0xeeeeee), forState: UIControlState.Normal)
        Player2Tap.backgroundColor = UIColor(netHex: 0x2980b9)
        Player2Tap.titleLabel!.font = UIFont(name: "Kankin", size: 50.0)
             
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
