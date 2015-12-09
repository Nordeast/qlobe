//
//  Simon2PlyViewController.swift
//  qlobe
//
//  Created by Aaron Knaack on 11/11/15.
//  Copyright © 2015 Simon Says All rights reserved.
//

import Foundation
import UIKit
import Darwin
import AVFoundation

class SimonSaysViewController: UIViewController {
    
    //////////////////////
    //  MARK: variables //
    //////////////////////
    
    //timers
    var countToBegin = 3                    // number of seconds before game
    var countDownTimer = NSTimer()          // timer used for countdown at start
    
    var buttonHoldTimer = NSTimer()         // helps maintain button color for short duration (during 'present' or user push)
    
    var cycleTimerRunning = false
    var cycleTimer = NSTimer()              // timer used during each 'Cycle'
    
    //rewards - points
    var totalTaps = 0                       //to reward points after round (each tap is worth 10 points)
    var reward = 0                          //the amount of points gathered
    
    var degree : CGFloat = 180.0            //the degree of rotation for reward pot transformation
    
    var sequence : [Int] = []               // sequence of button presses, randomly generated at start up
    
    //for keeping track of game play status
    var gameOver = false                    //represents ENTIRE game
    var cycle = 1
    var plays = 0                           //2 plays for each cycle
    var currPlay = 0
    var presentPatternCount = 0
    
    //DURING GAME PLAY
    var hasSelectedP1 = false               // used to check that p1 has made a selection
    var selectP1 = 0                        // used to determine which color p1 selected
    
    var hasSelectedP2 = false               // used to check that p2 has made a selection
    var selectP2 = 0                        // used to determine which color p2 selected
    
    var turn = 1                            // 1 for player 1's turn 2 for player 2's turn
    var index = 0                           // index used for sequence
    
    //for sound
    var ping_sound = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("airplanding", ofType: "wav")!)
    var elev_sound = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("elevatording", ofType: "wav")!)
    var pingPlayer = AVAudioPlayer()
    var elevPlayer = AVAudioPlayer()

    var engine = AVAudioEngine()
    var playerNode = AVAudioPlayerNode()
    
    ///////////////////
    // MARK: outlets //
    ///////////////////
    
    @IBOutlet weak var countDown_Reward: UILabel!
    
    @IBOutlet weak var P2Message: UILabel!
    @IBOutlet weak var P1Message: UILabel!
    
    //score labels
    @IBOutlet weak var Player2ScoreLabel: UILabel!
    @IBOutlet weak var Player2ScoreValue: UILabel!
    
    @IBOutlet weak var Player1ScoreValue: UILabel!
    @IBOutlet weak var Player1ScoreLabel: UILabel!
    
    //Player 2 Buttons (top player)
    @IBOutlet weak var P2RedButton: UIButton!
    @IBOutlet weak var P2YellowButton: UIButton!
    @IBOutlet weak var P2GreenButton: UIButton!
    @IBOutlet weak var P2BlueButton: UIButton!
    
    
    //Player 1 Buttons (bottom player)
    @IBOutlet weak var P1RedButton: UIButton!
    @IBOutlet weak var P1YellowButton: UIButton!
    @IBOutlet weak var P1GreenButton: UIButton!
    @IBOutlet weak var P1BlueButton: UIButton!
    
    
    ////////////////////
    // MARK: Start UP //
    ////////////////////
    
    func design(){
        //Design for all views to occur in viewDidLoad
        
        //controller design
        view.backgroundColor = UIColor(netHex:0x2c3e50)
        
        //outlet designs
        //Adjust for upside-down labels
        Player2ScoreLabel.transform = CGAffineTransformMakeRotation(CGFloat(M_PI))
        Player2ScoreValue.transform = CGAffineTransformMakeRotation(CGFloat(M_PI))
        P2Message.transform = CGAffineTransformMakeRotation(CGFloat(M_PI))

        //countdown
        countDown_Reward.font = UIFont(name: "Kankin", size: 30.0)
        countDown_Reward.textColor = UIColor(netHex: 0xeeeeee)
        
        //font and color for scores and score values
        Player2ScoreLabel.font = UIFont(name: "Kankin", size: 25.0)
        Player2ScoreLabel.textColor = UIColor(netHex: 0xeeeeee)
        Player2ScoreValue.font = UIFont(name: "Kankin", size:  25.0)
        Player2ScoreValue.textColor = UIColor(netHex: 0xeeeeee)

        
        Player1ScoreLabel.font = UIFont(name: "Kankin", size: 25.0)
        Player1ScoreLabel.textColor = UIColor(netHex: 0xeeeeee)
        Player1ScoreValue.font = UIFont(name: "Kankin", size:  25.0)
        Player1ScoreValue.textColor = UIColor(netHex: 0xeeeeee)

        
        
        //Message Labels
        P2Message.hidden = true;        //hidden until an alert is needed
        P1Message.hidden = true;        //hidden until an alert is needed
        
        //font and color
        P2Message.font = UIFont(name: "Kankin", size: 25.0)
        P2Message.textColor = UIColor(netHex: 0xeeeeee)
        P1Message.font = UIFont(name: "Kankin", size: 25.0)
        P1Message.textColor = UIColor(netHex: 0xeeeeee)
        
        //Player 2's buttons (top player)
        //red
        P2RedButton.backgroundColor = UIColor.clearColor()
        P2RedButton.layer.cornerRadius = P2RedButton.frame.size.width / 2
        P2RedButton.layer.borderWidth = 4
        P2RedButton.layer.borderColor = UIColor(netHex: 0xc0392b).CGColor
        //yellow
        P2YellowButton.backgroundColor = UIColor.clearColor()
        P2YellowButton.layer.cornerRadius = 0.5 * P2YellowButton.bounds.size.width
        P2YellowButton.layer.borderWidth = 4
        P2YellowButton.layer.borderColor = UIColor(netHex: 0xa4a200).CGColor
        //green
        P2GreenButton.backgroundColor = UIColor.clearColor()
        P2GreenButton.layer.cornerRadius = 0.5 * P2GreenButton.bounds.size.width
        P2GreenButton.layer.borderWidth = 4
        P2GreenButton.layer.borderColor = UIColor(netHex: 0x3d6451).CGColor
        //blue
        P2BlueButton.backgroundColor = UIColor.clearColor()
        P2BlueButton.layer.cornerRadius = 50
        P2BlueButton.layer.borderWidth = 4
        P2BlueButton.layer.borderColor = UIColor(netHex: 0x662a5b).CGColor
        
        //Player 1's buttons (bottom player)
        //red
        P1RedButton.backgroundColor = UIColor.clearColor()
        P1RedButton.layer.cornerRadius = 50
        P1RedButton.layer.borderWidth = 4
        P1RedButton.layer.borderColor = UIColor(netHex: 0xc0392b).CGColor
        //yellow
        P1YellowButton.backgroundColor = UIColor.clearColor()
        P1YellowButton.layer.cornerRadius = 50
        P1YellowButton.layer.borderWidth = 4
        P1YellowButton.layer.borderColor = UIColor(netHex: 0xa4a200).CGColor
        //green
        P1GreenButton.backgroundColor = UIColor.clearColor()
        P1GreenButton.layer.cornerRadius = 50
        P1GreenButton.layer.borderWidth = 4
        P1GreenButton.layer.borderColor = UIColor(netHex: 0x3d6451).CGColor
        //blue
        P1BlueButton.backgroundColor = UIColor.clearColor()
        P1BlueButton.layer.cornerRadius = 50
        P1BlueButton.layer.borderWidth = 4
        P1BlueButton.layer.borderColor = UIColor(netHex: 0x662a5b).CGColor
    }
    
    func generateRandSequence(){
        //creates random sequence of 'notes'
        //the sequence is of 1,2,3,4 = red, yellow, green, blue respectivly
        
        let range = 4
        while(sequence.count < 75){
            let rand = Int(arc4random_uniform(UInt32(range)) + 1)
            sequence.append(rand)
        }
    }
    
    func Counting(){
        //called from countDownTimer in viewDidLoad()
        //represents the countdown at start of game
        
        if(countToBegin >= 0){
            countDown_Reward.text = "\(countToBegin)"
            countToBegin -= 1
        }
        if(countToBegin == -1){
            countDownTimer.invalidate()     // stop countdown timer from loop
            cycleTimer = NSTimer.scheduledTimerWithTimeInterval(1.01, target: self, selector: Selector("presentPattern"), userInfo: nil, repeats: true)                    // Begin the game
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //account for volume settings
        //pingPlayer.volume = settings.getVolume()
        //elevPlayer.volume = settings.getVolume()
        
        Player1ScoreValue.text = "\(Player1.getPlayerScore())"
        Player2ScoreValue.text = "\(Player2.getPlayerScore())"
        
        do{
            pingPlayer = try AVAudioPlayer(contentsOfURL: ping_sound)
            elevPlayer = try AVAudioPlayer(contentsOfURL: elev_sound)
        }catch{
            print("error")
        }
        pingPlayer.prepareToPlay()
        elevPlayer.prepareToPlay()
        
        design()
        
        //disable all buttons until game is in play
        P2RedButton.enabled = false
        P2YellowButton.enabled = false
        P2GreenButton.enabled = false
        P2BlueButton.enabled = false
        P1RedButton.enabled = false
        P1YellowButton.enabled = false
        P1GreenButton.enabled = false
        P1BlueButton.enabled = false
        
        //begin countdown
        countDownTimer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: Selector("Counting"), userInfo: nil, repeats: true)
        
        generateRandSequence()
        
    }
    
    ///////////////////////////
    // MARK: Present Pattern //
    ///////////////////////////
    
    func presentP1Move(){
        //Check which button to show from sequence, play corresponding sound and, change corresponding buttons Look
        
        if(sequence[currPlay] == 1){
            //            if(pingPlayer.playing){     //allows for overlap
            //                pingPlayer.stop()
            //                pingPlayer.currentTime = 0
            //                pingPlayer.play()
            //            }else{
            //                pingPlayer.play()
            //            }
            self.P1RedButton.backgroundColor = UIColor(netHex: 0xc0392b)
            self.P2RedButton.backgroundColor = UIColor(netHex: 0xc0392b).colorWithAlphaComponent(0.15)
        }
        if(sequence[currPlay] == 2){
            //            if(elevPlayer.playing){     //allows for overlap
            //                elevPlayer.stop()
            //                elevPlayer.currentTime = 0
            //                elevPlayer.play()
            //            }else{
            //                elevPlayer.play()
            //            }
            self.P1YellowButton.backgroundColor = UIColor(netHex: 0xa4a200)
            self.P2YellowButton.backgroundColor = UIColor(netHex: 0xa4a200).colorWithAlphaComponent(0.15)
        }
        if(sequence[currPlay] == 3){
            self.P1GreenButton.backgroundColor = UIColor(netHex: 0x3d6451)
            self.P2GreenButton.backgroundColor = UIColor(netHex: 0x3d6451).colorWithAlphaComponent(0.15)
        }
        if(sequence[currPlay] == 4){
            self.P1BlueButton.backgroundColor = UIColor(netHex: 0x662a5b)
            self.P2BlueButton.backgroundColor = UIColor(netHex: 0x662a5b).colorWithAlphaComponent(0.15)
        }
        if(currPlay == sequence.count - 1){
        }
        currPlay += 1
    }
    
    func presentP2Move(){
        //Check which button to show from sequence, play corresponding sound and, change corresponding buttons Look
        
        if(sequence[currPlay] == 1){
            //            if(pingPlayer.playing){     //allows for overlap
            //                pingPlayer.stop()
            //                pingPlayer.currentTime = 0
            //                pingPlayer.play()
            //            }else{
            //                pingPlayer.play()
            //            }
            self.P1RedButton.backgroundColor = UIColor(netHex: 0xc0392b).colorWithAlphaComponent(0.15)
            self.P2RedButton.backgroundColor = UIColor(netHex: 0xc0392b)
        }
        if(sequence[currPlay] == 2){
            //            if(elevPlayer.playing){     //allows for overlap
            //                elevPlayer.stop()
            //                elevPlayer.currentTime = 0
            //                elevPlayer.play()
            //            }else{
            //                elevPlayer.play()
            //            }
            self.P1YellowButton.backgroundColor = UIColor(netHex: 0xa4a200).colorWithAlphaComponent(0.15)
            self.P2YellowButton.backgroundColor = UIColor(netHex: 0xa4a200)
        }
        if(sequence[currPlay] == 3){
            self.P1GreenButton.backgroundColor = UIColor(netHex: 0x3d6451).colorWithAlphaComponent(0.15)
            self.P2GreenButton.backgroundColor = UIColor(netHex: 0x3d6451)
        }
        if(sequence[currPlay] == 4){
            self.P1BlueButton.backgroundColor = UIColor(netHex: 0x662a5b).colorWithAlphaComponent(0.15)
            self.P2BlueButton.backgroundColor = UIColor(netHex: 0x662a5b)
        }
        if(currPlay == sequence.count - 1){
        }
        currPlay += 1
    }
    
    func presentPattern(){
        //presents the Pattern users need to remember.
        //First called after countdown from counting(), all other times called after P2 finnishes last Play during cycle in resetForCycle()
        
        plays = cycle * 2       // a play represents each individual button (2 plays for each cycle)
        
        if(presentPatternCount < plays){
            if(presentPatternCount == 0 || presentPatternCount % 2 == 0){
                presentP1Move()
                buttonHoldTimer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: Selector("clearButtons"), userInfo: nil, repeats: false)
            }
            else{
                presentP2Move()
                buttonHoldTimer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: Selector("clearButtons"), userInfo: nil, repeats: false)
            }
            presentPatternCount += 1
        }else{
            
            //enable buttons for game play
            P2RedButton.enabled = true
            P2YellowButton.enabled = true
            P2GreenButton.enabled = true
            P2BlueButton.enabled = true
            
            P1RedButton.enabled = true
            P1YellowButton.enabled = true
            P1GreenButton.enabled = true
            P1BlueButton.enabled = true
            
            cycleTimer.invalidate()
        }
    }
    
    /////////////////////////
    // MARK: Intermediates //
    /////////////////////////
    
    func clearButtons(){
        //clear buttons and message labels
        
        //If the game is over, allow "Game Over" to remain on screen, otherwise hide messages
        if(!gameOver){
            P1Message.hidden = true;
            P2Message.hidden = true;
        }
        
        P1RedButton.backgroundColor = UIColor.clearColor()
        P2RedButton.backgroundColor = UIColor.clearColor()
        P1YellowButton.backgroundColor = UIColor.clearColor()
        P2YellowButton.backgroundColor = UIColor.clearColor()
        P1GreenButton.backgroundColor = UIColor.clearColor()
        P2GreenButton.backgroundColor = UIColor.clearColor()
        P1BlueButton.backgroundColor = UIColor.clearColor()
        P2BlueButton.backgroundColor = UIColor.clearColor()
        
    }
    
    func disableButtonPress(){
        P2RedButton.enabled = false
        P2YellowButton.enabled = false
        P2GreenButton.enabled = false
        P2BlueButton.enabled = false
        P1RedButton.enabled = false
        P1YellowButton.enabled = false
        P1GreenButton.enabled = false
        P1BlueButton.enabled = false
    }
    
    func resetForCycle(){
        currPlay = 0
        cycleTimerRunning = false
        presentPatternCount = 0
        cycle += 1
        turn = 1
        index = 0
        disableButtonPress()
        cycleTimer = NSTimer.scheduledTimerWithTimeInterval(1.01, target: self, selector: Selector("presentPattern"), userInfo: nil, repeats: true)
    }
    
    /////////////////////
    // MARK: Game Play //
    /////////////////////
    
    //MARK: Player 2 button Actions
    @IBAction func P2RedButton(sender: AnyObject) {
        
        P2RedButton.backgroundColor = UIColor(netHex: 0xc0392b)
        
        if(!gameOver){
            if(turn == 2){
                if(sequence[index] == 1){
                    print("good job")
                    totalTaps += 1
                    reward = totalTaps * 100
                     countDown_Reward.text = "\(reward)"
                    degree += 180.0
                    UIView.animateWithDuration(0.15,animations:({
                        self.countDown_Reward.transform = CGAffineTransformMakeRotation(self.degree)
                    }))
                    turn -= 1
                    index += 1
                }
                else{
                    gameOver = true
                    disableButtonPress()
                    P2Message.text = "Game Over!"
                    P2Message.hidden = false;
                    Player1.addScore(reward)
                    _ = NSTimer.scheduledTimerWithTimeInterval(3, target: self, selector: "segue",
                        userInfo: nil, repeats: false)
                }
            }else{
                P2Message.text = "Not Your Turn"
                P2Message.hidden = false;
            }
        }
        
        //play sound
        //        if(pingPlayer.playing){     //allows for overlap
        //            pingPlayer.stop()
        //            pingPlayer.currentTime = 0
        //            pingPlayer.play()
        //        }else{
        //            pingPlayer.play()
        //        }
        buttonHoldTimer = NSTimer.scheduledTimerWithTimeInterval(0.25, target: self, selector: Selector("clearButtons"), userInfo: nil, repeats: false)
        
        //when each button has been reached for the cycle, reset cycle variables and begin cycle again
        if(index == plays){
            resetForCycle()
        }
        
    }
    
    @IBAction func P2YellowButton(sender: AnyObject) {
        
        P2YellowButton.backgroundColor = UIColor(netHex: 0xa4a200)
        
        if(!gameOver){
            if(turn == 2){
                if(sequence[index] == 2){
                    print("good job")
                    totalTaps += 1
                    reward = totalTaps * 100
                    countDown_Reward.text = "\(reward)"
                    degree += 180.0
                    UIView.animateWithDuration(0.15,animations:({
                        self.countDown_Reward.transform = CGAffineTransformMakeRotation(self.degree)
                    }))
                    turn -= 1
                    index += 1
                }
                else{
                    gameOver = true
                    disableButtonPress()
                    P2Message.text = "Game Over!"
                    P2Message.hidden = false;
                    Player1.addScore(reward)
                    _ = NSTimer.scheduledTimerWithTimeInterval(3, target: self, selector: "segue",
                        userInfo: nil, repeats: false)
                }
            }else{
                P2Message.text = "Not Your Turn"
                P2Message.hidden = false;
            }
        }
        
        //        if(elevPlayer.playing){     //allows for overlap
        //            elevPlayer.stop()
        //            elevPlayer.currentTime = 0
        //            elevPlayer.play()
        //        }else{
        //            elevPlayer.play()
        //        }
        
        buttonHoldTimer = NSTimer.scheduledTimerWithTimeInterval(0.25, target: self, selector: Selector("clearButtons"), userInfo: nil, repeats: false)
        
        //when each button has been reached for the cycle, reset cycle variables and begin cycle again
        if(index == plays){
            resetForCycle()
        }
        
        
    }
    
    @IBAction func P2GreenButton(sender: AnyObject) {
        
        P2GreenButton.backgroundColor = UIColor(netHex: 0x3d6451)
        
        if(!gameOver){
            if(turn == 2){
                if(sequence[index] == 3){
                    print("good job")
                    totalTaps += 1
                    reward = totalTaps * 100
                    countDown_Reward.text = "\(reward)"
                    degree += 180.0
                    UIView.animateWithDuration(0.15,animations:({
                        self.countDown_Reward.transform = CGAffineTransformMakeRotation(self.degree)
                    }))
                    turn -= 1
                    index += 1
                }
                else{
                    gameOver = true
                    disableButtonPress()
                    P2Message.text = "Game Over!"
                    P2Message.hidden = false;
                    Player1.addScore(reward)
                    _ = NSTimer.scheduledTimerWithTimeInterval(3, target: self, selector: "segue",
                        userInfo: nil, repeats: false)
                }
            }else{
                P2Message.text = "Not Your Turn"
                P2Message.hidden = false;
            }
        }
        
        buttonHoldTimer = NSTimer.scheduledTimerWithTimeInterval(0.25, target: self, selector: Selector("clearButtons"), userInfo: nil, repeats: false)
        
        //when each button has been reached for the cycle, reset cycle variables and begin cycle again
        if(index == plays){
            resetForCycle()
        }
        
        
    }
    
    @IBAction func P2BlueButton(sender: AnyObject) {
        
        P2BlueButton.backgroundColor = UIColor(netHex: 0x662a5b)
        
        
        if(!gameOver){
            if(turn == 2){
                if(sequence[index] == 4){
                    print("good job")
                    totalTaps += 1
                    reward = totalTaps * 100
                    countDown_Reward.text = "\(reward)"
                    degree += 180.0
                    UIView.animateWithDuration(0.15,animations:({
                        self.countDown_Reward.transform = CGAffineTransformMakeRotation(self.degree)
                    }))
                    turn -= 1
                    index += 1
                }
                else{
                    gameOver = true
                    disableButtonPress()
                    P2Message.text = "Game Over!"
                    P2Message.hidden = false;
                    Player1.addScore(reward)
                    _ = NSTimer.scheduledTimerWithTimeInterval(3, target: self, selector: "segue",
                        userInfo: nil, repeats: false)
                }
            }else{
                P2Message.text = "Not Your Turn"
                P2Message.hidden = false;
            }
        }
        
        buttonHoldTimer = NSTimer.scheduledTimerWithTimeInterval(0.25, target: self, selector: Selector("clearButtons"), userInfo: nil, repeats: false)
        
        //when each button has been reached for the cycle, reset cycle variables and begin cycle again
        if(index == plays){
            resetForCycle()
        }
        
    }
    
    //MARK: Player 1 button Actions
    @IBAction func P1RedButton(sender: AnyObject) {
        
        P1RedButton.backgroundColor = UIColor(netHex: 0xc0392b)
        
        if(!gameOver){
            if(turn == 1){
                if(sequence[index] == 1){
                    print("good job")
                    totalTaps += 1
                    reward = totalTaps * 100
                    countDown_Reward.text = "\(reward)"
                    degree += 180.0
                    UIView.animateWithDuration(0.15,animations:({
                        self.countDown_Reward.transform = CGAffineTransformMakeRotation(self.degree)
                    }))
                    turn += 1
                    index += 1
                }
                else{
                    gameOver = true
                    disableButtonPress()
                    P1Message.text = "Game Over!"
                    P1Message.hidden = false;
                    Player2.addScore(reward)
                    _ = NSTimer.scheduledTimerWithTimeInterval(3, target: self, selector: "segue",
                        userInfo: nil, repeats: false)
                }
            }else{
                P1Message.text = "Not Your Turn"
                P1Message.hidden = false;
            }
        }
        
        //play sound
        //        if(pingPlayer.playing){     //allows for overlap
        //            pingPlayer.stop()
        //            pingPlayer.currentTime = 0
        //            pingPlayer.play()
        //        }else{
        //            pingPlayer.play()
        //        }
        
        buttonHoldTimer = NSTimer.scheduledTimerWithTimeInterval(0.25, target: self, selector: Selector("clearButtons"), userInfo: nil, repeats: false)
        
    }
    
    @IBAction func P1YellowButton(sender: AnyObject) {
        P1YellowButton.backgroundColor = UIColor(netHex: 0xa4a200)
        
        if(!gameOver){
            if(turn == 1){
                if(sequence[index] == 2){
                    print("good job")
                    totalTaps += 1
                    reward = totalTaps * 100
                    countDown_Reward.text = "\(reward)"
                    degree += 180.0
                    UIView.animateWithDuration(0.15,animations:({
                        self.countDown_Reward.transform = CGAffineTransformMakeRotation(self.degree)
                    }))
                    turn += 1
                    index += 1
                }
                else{
                    gameOver = true
                    disableButtonPress()
                    P1Message.text = "Game Over!"
                    P1Message.hidden = false;
                    Player2.addScore(reward)
                    _ = NSTimer.scheduledTimerWithTimeInterval(3, target: self, selector: "segue",
                        userInfo: nil, repeats: false)
                }
            }else{
                P1Message.text = "Not Your Turn"
                P1Message.hidden = false;
            }
        }
        
        //        if(elevPlayer.playing){     //allows for overlap
        //            elevPlayer.stop()
        //            elevPlayer.currentTime = 0
        //            elevPlayer.play()
        //        }else{
        //            elevPlayer.play()
        //        }
        
        buttonHoldTimer = NSTimer.scheduledTimerWithTimeInterval(0.25, target: self, selector: Selector("clearButtons"), userInfo: nil, repeats: false)
        
    }
    
    @IBAction func P1GreenButton(sender: AnyObject) {
        P1GreenButton.backgroundColor = UIColor(netHex: 0x3d6451)
        
        if(!gameOver){
            if(turn == 1){
                if(sequence[index] == 3){
                    print("good job")
                    totalTaps += 1
                    reward = totalTaps * 100
                    countDown_Reward.text = "\(reward)"
                    degree += 180.0
                    UIView.animateWithDuration(0.15,animations:({
                        self.countDown_Reward.transform = CGAffineTransformMakeRotation(self.degree)
                    }))
                    turn += 1
                    index += 1
                }
                else{
                    gameOver = true
                    disableButtonPress()
                    P1Message.text = "Game Over!"
                    P1Message.hidden = false;
                    Player2.addScore(reward)
                    _ = NSTimer.scheduledTimerWithTimeInterval(3, target: self, selector: "segue",
                        userInfo: nil, repeats: false)
                }
            }else{
                P1Message.text = "Not Your Turn"
                P1Message.hidden = false;
            }
        }
        
        buttonHoldTimer = NSTimer.scheduledTimerWithTimeInterval(0.25, target: self, selector: Selector("clearButtons"), userInfo: nil, repeats: false)
        
    }
    
    @IBAction func P1BlueButton(sender: AnyObject) {
        P1BlueButton.backgroundColor = UIColor(netHex: 0x662a5b)
        
        if(!gameOver){
            if(turn == 1){
                if(sequence[index] == 4){
                    print("good job")
                    totalTaps += 1
                    reward = totalTaps * 100
                    countDown_Reward.text = "\(reward)"
                    degree += 180.0
                    UIView.animateWithDuration(0.15,animations:({
                        self.countDown_Reward.transform = CGAffineTransformMakeRotation(self.degree)
                    }))
                    turn += 1
                    index += 1
                }
                else{
                    gameOver = true
                    disableButtonPress()
                    P1Message.text = "Game Over!"
                    P1Message.hidden = false;
                    Player2.addScore(reward)
                    _ = NSTimer.scheduledTimerWithTimeInterval(3, target: self, selector: "segue",
                        userInfo: nil, repeats: false)
                }
            }else{
                P1Message.text = "Not Your Turn"
                P1Message.hidden = false;
            }
        }
        
        buttonHoldTimer = NSTimer.scheduledTimerWithTimeInterval(0.25, target: self, selector: Selector("clearButtons"), userInfo: nil, repeats: false)
    }
    
    func segue(){
        //func called by timer after Game Over on wrong button press
        self.performSegueWithIdentifier("ScoreBoardFromSimonSays", sender: self)
    }
    
    
}
