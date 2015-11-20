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
    
    ////////////////
    //  variables //
    ////////////////
    
    var countToBegin = 3                    // number of seconds before game
    var countDownTimer = NSTimer()          // timer used for countdown at start
    
    var buttonHoldTimer = NSTimer()         // helps maintain button color for short duration (during 'present' or user push)
    
    var cycleTimerRunning = false
    var cycleTimer = NSTimer()              // timer used during each 'Cycle'
    
    var totalTaps = 0                       //to reward points after round
    
    var sequence : [Int] = []               // sequence of button presses, randomly generated at start up
    
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
    var audioPlayer = AVAudioPlayer()
    
    var engine = AVAudioEngine()
    var playerNode = AVAudioPlayerNode()
    
    
    //////////////////////////
    //  end class variables //
    //////////////////////////
    
    
    /////////////
    // outlets //
    /////////////
    
    @IBOutlet weak var countDown: UILabel!
    
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
    
    /////////////////
    // end outlets //
    /////////////////
    
    func enableButtonPress(){
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
        enableButtonPress()
        cycleTimer = NSTimer.scheduledTimerWithTimeInterval(1.01, target: self, selector: Selector("presentPattern"), userInfo: nil, repeats: true)
    }
    
    //Player 2 button Actions
    @IBAction func P2RedButton(sender: AnyObject) {
        
        P2RedButton.backgroundColor = UIColor.redColor()
        
        if(!gameOver){
            if(turn == 2){
                if(sequence[index] == 1){
                    print("good job")
                    turn -= 1
                    index += 1
                }
                else{
                    gameOver = true
                    enableButtonPress()
                    print("Game over")
                }
            }else{
                print("not your turn")
            }
        }
        
        audioPlayer.play()
        buttonHoldTimer = NSTimer.scheduledTimerWithTimeInterval(0.25, target: self, selector: Selector("clearButtons"), userInfo: nil, repeats: false)
        
        //when each button has been reached for the cycle, reset cycle variables and begin cycle again
        if(index == plays){
            resetForCycle()
        }
        
    }
    
    @IBAction func P2YellowButton(sender: AnyObject) {
        
        P2YellowButton.backgroundColor = UIColor.yellowColor()
        
        if(!gameOver){
            if(turn == 2){
                if(sequence[index] == 2){
                    print("good job")
                    turn -= 1
                    index += 1
                }
                else{
                    gameOver = true
                    enableButtonPress()
                    print("Game over")
                }
            }else{
                print("not your turn")
            }
        }
        
        buttonHoldTimer = NSTimer.scheduledTimerWithTimeInterval(0.25, target: self, selector: Selector("clearButtons"), userInfo: nil, repeats: false)
        
        //when each button has been reached for the cycle, reset cycle variables and begin cycle again
        if(index == plays){
            resetForCycle()
        }
        
        
    }
    
    @IBAction func P2GreenButton(sender: AnyObject) {
        
        P2GreenButton.backgroundColor = UIColor.greenColor()
        
        if(!gameOver){
            if(turn == 2){
                if(sequence[index] == 3){
                    print("good job")
                    turn -= 1
                    index += 1
                }
                else{
                    gameOver = true
                    enableButtonPress()
                    print("Game over")
                }
            }else{
                print("not your turn")
            }
        }
        
        buttonHoldTimer = NSTimer.scheduledTimerWithTimeInterval(0.25, target: self, selector: Selector("clearButtons"), userInfo: nil, repeats: false)
        
        //when each button has been reached for the cycle, reset cycle variables and begin cycle again
        if(index == plays){
            resetForCycle()
        }
        
        
    }
    
    @IBAction func P2BlueButton(sender: AnyObject) {
        
        P2BlueButton.backgroundColor = UIColor.blueColor()
        
        
        if(!gameOver){
            if(turn == 2){
                if(sequence[index] == 4){
                    print("good job")
                    turn -= 1
                    index += 1
                }
                else{
                    gameOver = true
                    enableButtonPress()
                    print("Game over")
                }
            }else{
                print("not your turn")
            }
        }
        
        buttonHoldTimer = NSTimer.scheduledTimerWithTimeInterval(0.25, target: self, selector: Selector("clearButtons"), userInfo: nil, repeats: false)
        
        //when each button has been reached for the cycle, reset cycle variables and begin cycle again
        if(index == plays){
            resetForCycle()
        }
        
    }
    
    //Player 1 button Actions
    @IBAction func P1RedButton(sender: AnyObject) {
        
        P1RedButton.backgroundColor = UIColor.redColor()
        
        if(!gameOver){
            if(turn == 1){
                if(sequence[index] == 1){
                    print("good job")
                    turn += 1
                    index += 1
                }
                else{
                    gameOver = true
                    enableButtonPress()
                    print("Game over")
                }
            }else{
                print("not your turn")
            }
        }
        
        audioPlayer.play()
        buttonHoldTimer = NSTimer.scheduledTimerWithTimeInterval(0.25, target: self, selector: Selector("clearButtons"), userInfo: nil, repeats: false)
        
    }
    
    @IBAction func P1YellowButton(sender: AnyObject) {
        P1YellowButton.backgroundColor = UIColor.yellowColor()
        
        if(!gameOver){
            if(turn == 1){
                if(sequence[index] == 2){
                    print("good job")
                    turn += 1
                    index += 1
                }
                else{
                    gameOver = true
                    enableButtonPress()
                    print("Game over")
                }
            }else{
                print("not your turn")
            }
        }
        
        buttonHoldTimer = NSTimer.scheduledTimerWithTimeInterval(0.25, target: self, selector: Selector("clearButtons"), userInfo: nil, repeats: false)
        
    }
    
    @IBAction func P1GreenButton(sender: AnyObject) {
        P1GreenButton.backgroundColor = UIColor.greenColor()
        
        if(!gameOver){
            if(turn == 1){
                if(sequence[index] == 3){
                    print("good job")
                    turn += 1
                    index += 1
                }
                else{
                    gameOver = true
                    enableButtonPress()
                    print("Game over")
                }
            }else{
                print("not your turn")
            }
        }
        
        buttonHoldTimer = NSTimer.scheduledTimerWithTimeInterval(0.25, target: self, selector: Selector("clearButtons"), userInfo: nil, repeats: false)
        
    }
    
    @IBAction func P1BlueButton(sender: AnyObject) {
        P1BlueButton.backgroundColor = UIColor.blueColor()
        
        if(!gameOver){
            if(turn == 1){
                if(sequence[index] == 4){
                    print("good job")
                    turn += 1
                    index += 1
                }
                else{
                    gameOver = true
                    enableButtonPress()
                    print("Game over")
                }
            }else{
                print("not your turn")
            }
        }
        
        buttonHoldTimer = NSTimer.scheduledTimerWithTimeInterval(0.25, target: self, selector: Selector("clearButtons"), userInfo: nil, repeats: false)
    }
    
    func outletDesign(){
        
        //Adjust for upside-down labels
        Player2ScoreLabel.transform = CGAffineTransformMakeRotation(CGFloat(M_PI))
        Player2ScoreValue.transform = CGAffineTransformMakeRotation(CGFloat(M_PI))
        
        //Player 2's buttons (top player)
        //red
        P2RedButton.backgroundColor = UIColor.clearColor()
        P2RedButton.layer.cornerRadius = P2RedButton.frame.size.width / 2
        P2RedButton.layer.borderWidth = 1
        P2RedButton.layer.borderColor = UIColor.redColor().CGColor
        //yellow
        P2YellowButton.backgroundColor = UIColor.clearColor()
        P2YellowButton.layer.cornerRadius = 0.5 * P2YellowButton.bounds.size.width
        P2YellowButton.layer.borderWidth = 1
        P2YellowButton.layer.borderColor = UIColor.yellowColor().CGColor
        //green
        P2GreenButton.backgroundColor = UIColor.clearColor()
        P2GreenButton.layer.cornerRadius = 0.5 * P2GreenButton.bounds.size.width
        P2GreenButton.layer.borderWidth = 1
        P2GreenButton.layer.borderColor = UIColor.greenColor().CGColor
        //blue
        P2BlueButton.backgroundColor = UIColor.clearColor()
        P2BlueButton.layer.cornerRadius = 50
        P2BlueButton.layer.borderWidth = 1
        P2BlueButton.layer.borderColor = UIColor.blueColor().CGColor
        
        //Player 1's buttons (bottom player)
        //red
        P1RedButton.backgroundColor = UIColor.clearColor()
        P1RedButton.layer.cornerRadius = 50
        P1RedButton.layer.borderWidth = 1
        P1RedButton.layer.borderColor = UIColor.redColor().CGColor
        //yellow
        P1YellowButton.backgroundColor = UIColor.clearColor()
        P1YellowButton.layer.cornerRadius = 50
        P1YellowButton.layer.borderWidth = 1
        P1YellowButton.layer.borderColor = UIColor.yellowColor().CGColor
        //green
        P1GreenButton.backgroundColor = UIColor.clearColor()
        P1GreenButton.layer.cornerRadius = 50
        P1GreenButton.layer.borderWidth = 1
        P1GreenButton.layer.borderColor = UIColor.greenColor().CGColor
        //blue
        P1BlueButton.backgroundColor = UIColor.clearColor()
        P1BlueButton.layer.cornerRadius = 50
        P1BlueButton.layer.borderWidth = 1
        P1BlueButton.layer.borderColor = UIColor.blueColor().CGColor
    }
    
    func clearButtons(){
        P1RedButton.backgroundColor = UIColor.clearColor()
        P2RedButton.backgroundColor = UIColor.clearColor()
        P1YellowButton.backgroundColor = UIColor.clearColor()
        P2YellowButton.backgroundColor = UIColor.clearColor()
        P1GreenButton.backgroundColor = UIColor.clearColor()
        P2GreenButton.backgroundColor = UIColor.clearColor()
        P1BlueButton.backgroundColor = UIColor.clearColor()
        P2BlueButton.backgroundColor = UIColor.clearColor()
        
    }
    
    func presentP1Move(){
        if(sequence[currPlay] == 1){
            self.P1RedButton.backgroundColor = UIColor.redColor()
            self.P2RedButton.backgroundColor = UIColor.redColor().colorWithAlphaComponent(0.15)
        }
        if(sequence[currPlay] == 2){
            self.P1YellowButton.backgroundColor = UIColor.yellowColor()
            self.P2YellowButton.backgroundColor = UIColor.yellowColor().colorWithAlphaComponent(0.15)
        }
        if(sequence[currPlay] == 3){
            self.P1GreenButton.backgroundColor = UIColor.greenColor()
            self.P2GreenButton.backgroundColor = UIColor.greenColor().colorWithAlphaComponent(0.15)
        }
        if(sequence[currPlay] == 4){
            self.P1BlueButton.backgroundColor = UIColor.blueColor()
            self.P2BlueButton.backgroundColor = UIColor.blueColor().colorWithAlphaComponent(0.15)
        }
        if(currPlay == sequence.count - 1){
        }
        currPlay += 1
    }
    
    func presentP2Move(){
        if(sequence[currPlay] == 1){
            self.P1RedButton.backgroundColor = UIColor.redColor().colorWithAlphaComponent(0.15)
            self.P2RedButton.backgroundColor = UIColor.redColor()
        }
        if(sequence[currPlay] == 2){
            self.P1YellowButton.backgroundColor = UIColor.yellowColor().colorWithAlphaComponent(0.15)
            self.P2YellowButton.backgroundColor = UIColor.yellowColor()
        }
        if(sequence[currPlay] == 3){
            self.P1GreenButton.backgroundColor = UIColor.greenColor().colorWithAlphaComponent(0.15)
            self.P2GreenButton.backgroundColor = UIColor.greenColor()
        }
        if(sequence[currPlay] == 4){
            self.P1BlueButton.backgroundColor = UIColor.blueColor().colorWithAlphaComponent(0.15)
            self.P2BlueButton.backgroundColor = UIColor.blueColor()
        }
        if(currPlay == sequence.count - 1){
        }
        currPlay += 1
    }
    
    
    //presents the Pattern users need to remember.
    //First called after countdown from counting(), all other times called after P2 finnishes last Play during cycle in resetForCycle()
    func presentPattern(){
        
        plays = cycle * 2
        
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
    
    //called from countDownTimer in viewDidLoad()
    func Counting(){
        if(countToBegin >= 0){
            countDown.text = "\(countToBegin)"
            countToBegin -= 1
        }
        if(countToBegin == -1){
            countDown.hidden = true;        // hide countdown
            countDownTimer.invalidate()     // stop countdown timer from loop
            cycleTimer = NSTimer.scheduledTimerWithTimeInterval(1.01, target: self, selector: Selector("presentPattern"), userInfo: nil, repeats: true)                    // Begin the game
            
        }
    }
    
    //creates random sequence of 'notes'
    //the sequence is of 1,2,3,4 = red, yellow, green, blue respectivly
    func generateRandSequence(){
        let range = 4
        while(sequence.count < 75){
            let rand = Int(arc4random_uniform(UInt32(range)) + 1)
            sequence.append(rand)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        do{
            audioPlayer = try AVAudioPlayer(contentsOfURL: ping_sound)
        }catch{
            print("error")
        }
        audioPlayer.prepareToPlay()
        
        outletDesign()
        
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
}
