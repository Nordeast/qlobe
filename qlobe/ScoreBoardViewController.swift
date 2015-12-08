//
//  ScoreBoardViewController.swift
//  qlobe
//
//  Created by allen rand on 11/17/15.
//  Copyright © 2015 qlobe. All rights reserved.
//

import UIKit
import AVFoundation

var triviaGameCount = 0
//current round number
var roundNumber = 0
//number of rounds the match will have, default = 10.
var numberOfRoundsPerMatch = 10

class ScoreBoardViewController: UIViewController {
    var segues : [String] = ["Trivia", "TapRace", "SimonSays"]
    //var segues : [String] = ["Trivia"]
    //var segues : [String] = ["TapRace"]
    //var segues : [String] = ["SimonSays"]
    var rand = 0
    
    var tapRaceAudio = try? AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("mk64_racestart", ofType: "wav")!))
    
    var triviaAudio = try? AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("trivia", ofType: "wav")!))
    
    
    // MARK: Outlets
    
    @IBOutlet weak var P1ScoreTop: UITextView!
    @IBOutlet weak var P2ScoreTop: UITextView!
    @IBOutlet weak var P1ScoreBottom: UITextView!
    @IBOutlet weak var P2ScoreBottom: UITextView!
    @IBOutlet weak var displayLabelBottom: UILabel!
    @IBOutlet weak var displayLabelTop: UILabel!
    @IBOutlet weak var ContinueButtonBottom: UIButton!
    @IBOutlet weak var ContinueButtonTop: UIButton!
    @IBOutlet weak var ChangeGameButtonBottom: UIButton!
    @IBOutlet weak var ChangeGameButtonTop: UIButton!
    
    
    // MARK: Actions
    @IBAction func ChangeGameButtonBottom(sender: AnyObject) {
        // allow user to change the next game
        
        // make sure the game isnt the same as the one they had before they pressed change game
        let previousRand = rand
        while(previousRand == rand){
            rand = Int(arc4random_uniform(UInt32(segues.count)))
        }
        
        displayLabelBottom.text = "Next game: \(segues[rand])"
        displayLabelTop.text = "Next game: \(segues[rand])"
    }
    
    @IBAction func ChangeGameButtonTop(sender: AnyObject) {
        // allow user to change the next game
        
        // make sure the game isnt the same as the one they had before they pressed change game
        let previousRand = rand
        while(previousRand == rand){
            rand = Int(arc4random_uniform(UInt32(segues.count)))
        }
        
        displayLabelBottom.text = segues[rand]
        displayLabelTop.text = segues[rand]
    }
    
    
    @IBAction func ContinueButtonTop(sender: AnyObject) {
        //continue playing the game
        segueToNextGame()

    }
    @IBAction func ContinueButtonBottom(sender: AnyObject) {
        //continue playing the game
        
        var segueDelay = 0.0

        //Play sound effect for TapRace
        if(segues[rand] == "TapRace"){
            segueDelay = 5.0
            tapRaceAudio!.play()
        }else if(segues[rand] == "Trivia"){
            triviaAudio!.play()
        }else if(segues[rand] == "SimonSays"){
                    tapRaceAudio!.play()
        }
        
        // perform segue with delay for the audio to play
        _ = NSTimer.scheduledTimerWithTimeInterval(segueDelay, target: self, selector: "segueToNextGame",
            userInfo: nil, repeats: false)
        }
    
    
    // MARK: ViewControler functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //add one to the roundNumber to indicate the next round
        roundNumber++
        
        // style the page
        style()
        // Do any additional setup after loading the view.
        
        
        //reset triviaGameCount to 0
        triviaGameCount = 0
        // intially everything should be hidden
        ContinueButtonBottom.alpha = 0
        ContinueButtonTop.alpha = 0
        ChangeGameButtonBottom.alpha = 0
        ChangeGameButtonTop.alpha = 0
        P1ScoreTop.alpha = 0
        P2ScoreTop.alpha = 0
        P1ScoreBottom.alpha = 0
        P2ScoreBottom.alpha = 0
        displayLabelBottom.alpha = 0
        displayLabelTop.alpha = 0
        
        //load the score
        displayScore()
        
                   }
    override func viewDidAppear(animated: Bool) {
        
        //fade in to display score
        P1ScoreTop.fadeIn()
        P2ScoreTop.fadeIn()
        P1ScoreBottom.fadeIn()
        P2ScoreBottom.fadeIn()
        displayLabelBottom.fadeIn()
        displayLabelTop.fadeIn()

        
        // show the score for 7 seconds then show the change game and continue buttons
        _ = NSTimer.scheduledTimerWithTimeInterval(7, target: self, selector: "buttons",
            userInfo: nil, repeats: false)
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Helper Functions
    func segueToNextGame(){
        
        // segue to the random next game
        performSegueWithIdentifier(segues[rand], sender: self)
    }
    
    func style(){
        // sets the styling of the view to match the rest of the app
        
        view.backgroundColor = UIColor(netHex:0x2c3e50)
        
        // set text view styling
        P1ScoreTop.selectable = true
        P1ScoreTop.editable = true
        P2ScoreTop.selectable = true
        P2ScoreTop.editable = true
        P1ScoreBottom.selectable = true
        P1ScoreBottom.editable = true
        P2ScoreBottom.selectable = true
        P2ScoreBottom.editable = true
        
        P1ScoreTop.font = UIFont(name: "Kankin", size: 25)
        P1ScoreTop.textColor = UIColor(netHex: 0xeeeeee)
        P1ScoreTop.textAlignment = NSTextAlignment.Center
        P1ScoreTop.backgroundColor = UIColor(netHex:0x2c3e50)
      
        P2ScoreTop.font = UIFont(name: "Kankin", size: 25)
        P2ScoreTop.textColor = UIColor(netHex: 0xeeeeee)
        P2ScoreTop.textAlignment = NSTextAlignment.Center
        P2ScoreTop.backgroundColor = UIColor(netHex:0x2c3e50)

        P1ScoreBottom.font = UIFont(name: "Kankin", size: 25)
        P1ScoreBottom.textColor = UIColor(netHex: 0xeeeeee)
        P1ScoreBottom.textAlignment = NSTextAlignment.Center
        P1ScoreBottom.backgroundColor = UIColor(netHex:0x2c3e50)

        P2ScoreBottom.font = UIFont(name: "Kankin", size: 25)
        P2ScoreBottom.textColor = UIColor(netHex: 0xeeeeee)
        P2ScoreBottom.textAlignment = NSTextAlignment.Center
        P2ScoreBottom.backgroundColor = UIColor(netHex:0x2c3e50)
        
        P1ScoreTop.selectable = false
        P1ScoreTop.editable = false
        P2ScoreTop.selectable = false
        P2ScoreTop.editable = false
        P1ScoreBottom.selectable = false
        P1ScoreBottom.editable = false
        P2ScoreBottom.selectable = false
        P2ScoreBottom.editable = false
        
        // set label styling
        displayLabelBottom.font = UIFont(name: "Kankin", size: 40)
        displayLabelBottom.textColor = UIColor(netHex: 0xe74c3c)
        displayLabelBottom.textAlignment = NSTextAlignment.Center
        displayLabelBottom.text = "Round \(roundNumber)"

        displayLabelTop.font = UIFont(name: "Kankin", size: 40)
        displayLabelTop.textColor = UIColor(netHex: 0xe74c3c)
        displayLabelTop.textAlignment = NSTextAlignment.Center
        displayLabelTop.text = "Round \(roundNumber)"
        
        // set button styling
        ContinueButtonBottom.titleLabel!.font = UIFont(name: "Kankin", size: 25)!
        ContinueButtonBottom.setTitleColor(UIColor(netHex: 0xeeeeee), forState: UIControlState.Normal)
        ContinueButtonBottom.titleLabel!.text = "Continue"
        
        ContinueButtonTop.titleLabel!.font = UIFont(name: "Kankin", size: 25)!
        ContinueButtonTop.setTitleColor(UIColor(netHex: 0xeeeeee), forState: UIControlState.Normal)
        ContinueButtonTop.titleLabel!.text = "Continue"
        
        ChangeGameButtonBottom.titleLabel!.font = UIFont(name: "Kankin", size: 25)!
        ChangeGameButtonBottom.setTitleColor(UIColor(netHex: 0xeeeeee), forState: UIControlState.Normal)
        ChangeGameButtonBottom.titleLabel!.text = "Change game)"
        
        ChangeGameButtonTop.titleLabel!.font = UIFont(name: "Kankin", size: 25)!
        ChangeGameButtonTop.setTitleColor(UIColor(netHex: 0xeeeeee), forState: UIControlState.Normal)
        ChangeGameButtonTop.titleLabel!.text = "Change game"
        
        
        // flip the buttons and labels that need to be flipped
        displayLabelTop.transform = CGAffineTransformMakeRotation(CGFloat(M_PI))
        P1ScoreTop.transform = CGAffineTransformMakeRotation(CGFloat(M_PI))
        ContinueButtonTop.transform = CGAffineTransformMakeRotation(CGFloat(M_PI))
        ChangeGameButtonTop.transform = CGAffineTransformMakeRotation(CGFloat(M_PI))
        P2ScoreTop.transform = CGAffineTransformMakeRotation(CGFloat(M_PI))
        P1ScoreTop.transform = CGAffineTransformMakeRotation(CGFloat(M_PI))
    }
    
    func displayScore(){
        // displays the current score of the match

        
        P1ScoreBottom.text = "Red's Score: \(Player1.getPlayerScore())"
        P1ScoreTop.text = "Red's Score: \(Player1.getPlayerScore())"
        P2ScoreBottom.text = "Blue's Score: \(Player2.getPlayerScore())"
        P2ScoreTop.text = "Blue's Score: \(Player2.getPlayerScore())"
    }
    
    func buttons(){
        
        displayLabelBottom.fadeOut(1, delay: 0, completion: {_ in
            self.displayLabelBottom.text = "Next game: \(self.segues[self.rand])"
            self.displayLabelBottom.fadeIn()
        })
        displayLabelTop.fadeOut(1, delay: 0, completion: {_ in
            self.displayLabelTop.text = "Next game: \(self.segues[self.rand])"
            self.displayLabelTop.fadeIn()
        })
        
        //fade out score displays and fade in buttons
        P1ScoreTop.fadeOut(1, delay: 0, completion: {_ in
            self.ContinueButtonBottom.fadeIn()
            self.ContinueButtonTop.fadeIn()
            self.ChangeGameButtonBottom.fadeIn()
            self.ChangeGameButtonTop.fadeIn()
        })
        
        P2ScoreTop.fadeOut()
        P1ScoreBottom.fadeOut()
        P2ScoreBottom.fadeOut()
        blinkingButtons()
    }
    
    func blinkingButtons(){
        
        
        UIView.animateWithDuration(0.6, delay: 0, options: [.Repeat, .Autoreverse, .AllowUserInteraction],
            
            animations: {
                
                self.ContinueButtonBottom.titleLabel!.alpha = 0.4
                self.ContinueButtonTop.titleLabel!.alpha = 0.4

                
            },
            
            completion: nil)
        
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
