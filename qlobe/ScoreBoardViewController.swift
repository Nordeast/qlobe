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
var ROUND = 1
//number of rounds the match will have, default = 10.
var numberOfRoundsPerMatch = 3 // number of rounds is actually numberOfRoundsPerMatch
//because of off by one errors prevention

class ScoreBoardViewController: UIViewController {
    var segues : [String] = settings.getGamesSetting()
    //var segues : [String] = ["Trivia"]
    //var segues : [String] = ["TapRace"]
    //var segues : [String] = ["SimonSays"]
    var rand = 0
    
    var nextGamePressed = false
    
    var tapRaceAudio = try? AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("mk64_racestart", ofType: "wav")!))
    
    var triviaAudio = try? AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("trivia", ofType: "wav")!))
    
    var simonSaysAudio = try? AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("simonSaysStart", ofType: "mp3")!))
    
    var changeGameAudio = try? AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("boing", ofType: "wav")!))
    
    var roundAudio = try? AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("round", ofType: "mp3")!))
    
    // MARK: Outlets
    
    @IBOutlet weak var P1ScoreNameBottom: UILabel!
    @IBOutlet weak var P1ScoreValueBottom: UILabel!
    @IBOutlet weak var P1ScoreNameTop: UILabel!
    @IBOutlet weak var P1ScoreValueTop: UILabel!
    
    @IBOutlet weak var P2ScoreNameBottom: UILabel!
    @IBOutlet weak var P2ScoreValueBottom: UILabel!
    @IBOutlet weak var P2ScoreNameTop: UILabel!
    @IBOutlet weak var P2ScoreValueTop: UILabel!
    
    @IBOutlet weak var displayLabelBottom: UILabel!
    @IBOutlet weak var displayLabelTop: UILabel!
    @IBOutlet weak var ContinueButtonBottom: UIButton!
    @IBOutlet weak var ContinueButtonTop: UIButton!
    @IBOutlet weak var ChangeGameButtonBottom: UIButton!
    @IBOutlet weak var ChangeGameButtonTop: UIButton!
    @IBOutlet weak var muteBtnBottom: UIButton!
    @IBOutlet weak var muteBtnTop: UIButton!
    @IBOutlet weak var QuitButtonBottom: UIButton!
    @IBOutlet weak var QuitButtonTop: UIButton!
    @IBOutlet weak var BlueSheepImage: UIImageView!
    
    @IBOutlet weak var RedSheepImage: UIImageView!
    
    // MARK: Actions
    func quitGame(){
        
        roundAudio!.stop()
        // segue to the final results page
        performSegueWithIdentifier("GameOver", sender: self)
        
    }
    
    @IBAction func QuitButtonBottom(sender: AnyObject) {
        quitGame()
    }
    
    @IBAction func QuitButtonTop(sender: AnyObject) {
        quitGame()
    }
    
    
    
    func setAudioVolume(){
        tapRaceAudio?.volume = settings.getVolume()
        triviaAudio?.volume = settings.getVolume()
        simonSaysAudio?.volume = settings.getVolume()
        changeGameAudio?.volume = settings.getVolume()
        roundAudio?.volume = settings.getVolume()
    }
    
    func switchMute(){
        if(settings.isMute() == false){
            settings.setVolumePre(settings.getVolume())
            settings.setVolume(0.0)
            muteBtnBottom.setImage(UIImage(named: "sound_off"), forState: .Normal)
            muteBtnTop.setImage(UIImage(named: "sound_off"), forState: .Normal)
        }
        else{
            settings.setVolume(settings.getVolumePre())
            muteBtnBottom.setImage(UIImage(named: "sound_on"), forState: .Normal)
            muteBtnTop.setImage(UIImage(named: "sound_on"), forState: .Normal)
        }
        setAudioVolume()
    }
    
    @IBAction func muteBtnPressedBottom(sender: AnyObject) {
        switchMute()
    }
    
    @IBAction func muteBtnPressedTop(sender: AnyObject) {
        switchMute()
    }
    
    
    func changeGame(){
        // allow user to change the next game
        
        // make sure the game isnt the same as the one they had before they pressed change game
        rand = (rand+1) % segues.count
        
        displayLabelBottom.text = "\(segues[rand])"
        displayLabelTop.text = "\(segues[rand])"
        
        changeGameAudio!.play()
    }
    @IBAction func ChangeGameButtonBottom(sender: AnyObject) {
        changeGame()
    }
    
    @IBAction func ChangeGameButtonTop(sender: AnyObject) {
        changeGame()
    }
    
    
    func ContinueToNextGame(){
        var segueDelay = 0.0
        
        nextGamePressed = true
        
        //Play sound effect for TapRace
        if(segues[rand] == "TapRace" && (settings.isMute() == false)){
            segueDelay = 5.0
            tapRaceAudio!.play()
        }else if(segues[rand] == "Trivia" && (settings.isMute() == false)){
            segueDelay = 3.0
            triviaAudio!.play()
        }else if(segues[rand] == "SimonSays" && (settings.isMute() == false)){
            segueDelay = 3.0
            simonSaysAudio!.play()
        }
        
        // Disable the change game button
        ChangeGameButtonBottom.enabled = false
        ChangeGameButtonTop.enabled = false
        muteBtnBottom.enabled = false
        muteBtnTop.enabled = false
        ContinueButtonBottom.enabled = false
        ContinueButtonTop.enabled = false
        
        roundAudio!.stop()
        
        // perform segue with delay for the audio to play
        _ = NSTimer.scheduledTimerWithTimeInterval(segueDelay, target: self, selector: "segueToNextGame",
            userInfo: nil, repeats: false)
    }
    
    @IBAction func ContinueButtonTop(sender: AnyObject) {
        if(nextGamePressed == false){
            ContinueToNextGame()
        }
    }
    
    @IBAction func ContinueButtonBottom(sender: AnyObject) {
        if(nextGamePressed == false){
            ContinueToNextGame()
        }
    }
    
    
    // MARK: ViewControler functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Get random game type
        rand = Int(arc4random_uniform(UInt32(segues.count)))
        
        // style the page
        style()
        
        //account for volume settings
        setAudioVolume()
        roundAudio!.play()
        
        //reset triviaGameCount to 0
        triviaGameCount = 0
        // intially everything should be hidden
        ContinueButtonBottom.alpha = 0
        ContinueButtonTop.alpha = 0
        ChangeGameButtonBottom.alpha = 0
        ChangeGameButtonTop.alpha = 0
        displayLabelBottom.alpha = 0
        displayLabelTop.alpha = 0
        QuitButtonTop.alpha = 0
        QuitButtonBottom.alpha = 0
        P1ScoreNameBottom.alpha = 0
        P1ScoreValueBottom.alpha = 0
        P1ScoreNameTop.alpha = 0
        P1ScoreValueTop.alpha = 0
        P2ScoreNameBottom.alpha = 0
        P2ScoreValueBottom.alpha = 0
        P2ScoreNameTop.alpha = 0
        P2ScoreValueTop.alpha = 0
        RedSheepImage.alpha = 0
        BlueSheepImage.alpha = 0
        
        //load the score
        displayScore()
        
    }
    override func viewDidAppear(animated: Bool) {
        
        //fade in to display score
        P1ScoreNameBottom.fadeIn()
        P1ScoreValueBottom.fadeIn()
        P1ScoreNameTop.fadeIn()
        P1ScoreValueTop.fadeIn()
        
        P2ScoreNameBottom.fadeIn()
        P2ScoreValueBottom.fadeIn()
        P2ScoreNameTop.fadeIn()
        P2ScoreValueTop.fadeIn()
        
        displayLabelBottom.fadeIn()
        displayLabelTop.fadeIn()
        ContinueButtonBottom.blinkingButton()
        
        // fade in the sheep images but not all the way. Leave them semi transparent
        UIView.animateWithDuration(1.0, delay: 0, options: [], animations: {
            self.BlueSheepImage.alpha = 0.4
            self.RedSheepImage.alpha = 0.4
            },
            completion: nil)
        
        _ = NSTimer.scheduledTimerWithTimeInterval(5, target: self, selector: "buttons",
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
        P1ScoreNameBottom.font = UIFont(name: "Kankin", size: 25)
        P1ScoreNameBottom.textColor = UIColor(netHex: 0xeeeeee)
        P1ScoreNameBottom.textAlignment = NSTextAlignment.Center
        P1ScoreNameBottom.backgroundColor = UIColor(netHex:0x2c3e50)
        
        P1ScoreNameTop.font = UIFont(name: "Kankin", size: 25)
        P1ScoreNameTop.textColor = UIColor(netHex: 0xeeeeee)
        P1ScoreNameTop.textAlignment = NSTextAlignment.Center
        P1ScoreNameTop.backgroundColor = UIColor(netHex:0x2c3e50)
        
        P1ScoreValueBottom.font = UIFont(name: "Kankin", size: 25)
        P1ScoreValueBottom.textColor = UIColor(netHex: 0xeeeeee)
        P1ScoreValueBottom.textAlignment = NSTextAlignment.Center
        P1ScoreValueBottom.backgroundColor = UIColor(netHex:0x2c3e50)
        
        P1ScoreValueTop.font = UIFont(name: "Kankin", size: 25)
        P1ScoreValueTop.textColor = UIColor(netHex: 0xeeeeee)
        P1ScoreValueTop.textAlignment = NSTextAlignment.Center
        P1ScoreValueTop.backgroundColor = UIColor(netHex:0x2c3e50)
        
        P2ScoreNameBottom.font = UIFont(name: "Kankin", size: 25)
        P2ScoreNameBottom.textColor = UIColor(netHex: 0xeeeeee)
        P2ScoreNameBottom.textAlignment = NSTextAlignment.Center
        P2ScoreNameBottom.backgroundColor = UIColor(netHex:0x2c3e50)
        
        P2ScoreNameTop.font = UIFont(name: "Kankin", size: 25)
        P2ScoreNameTop.textColor = UIColor(netHex: 0xeeeeee)
        P2ScoreNameTop.textAlignment = NSTextAlignment.Center
        P2ScoreNameTop.backgroundColor = UIColor(netHex:0x2c3e50)
        
        P2ScoreValueBottom.font = UIFont(name: "Kankin", size: 25)
        P2ScoreValueBottom.textColor = UIColor(netHex: 0xeeeeee)
        P2ScoreValueBottom.textAlignment = NSTextAlignment.Center
        P2ScoreValueBottom.backgroundColor = UIColor(netHex:0x2c3e50)
        
        P2ScoreValueTop.font = UIFont(name: "Kankin", size: 25)
        P2ScoreValueTop.textColor = UIColor(netHex: 0xeeeeee)
        P2ScoreValueTop.textAlignment = NSTextAlignment.Center
        P2ScoreValueTop.backgroundColor = UIColor(netHex:0x2c3e50)
        
        
        // set label styling
        displayLabelBottom.font = UIFont(name: "Kankin", size: 40)
        displayLabelBottom.textColor = UIColor(netHex: 0xf1c40f)
        displayLabelBottom.textAlignment = NSTextAlignment.Center
        displayLabelBottom.text = "Round \(ROUND)"
        
        displayLabelTop.font = UIFont(name: "Kankin", size: 40)
        displayLabelTop.textColor = UIColor(netHex: 0xf1c40f)
        displayLabelTop.textAlignment = NSTextAlignment.Center
        displayLabelTop.text = "Round \(ROUND)"
        
        // set button styling
        ContinueButtonBottom.titleLabel!.font = UIFont(name: "Kankin", size: 25)!
        ContinueButtonBottom.setTitleColor(UIColor(netHex: 0xeeeeee), forState: UIControlState.Normal)
        ContinueButtonBottom.titleLabel!.text = "Continue"
        
        ContinueButtonTop.titleLabel!.font = UIFont(name: "Kankin", size: 25)!
        ContinueButtonTop.setTitleColor(UIColor(netHex: 0xeeeeee), forState: UIControlState.Normal)
        ContinueButtonTop.titleLabel!.text = "Continue"
        
        ChangeGameButtonBottom.titleLabel!.font = UIFont(name: "Kankin", size: 25)!
        ChangeGameButtonBottom.setTitleColor(UIColor(netHex: 0xeeeeee), forState: UIControlState.Normal)
        //ChangeGameButtonBottom.titleLabel!.text = "Random game"
        ChangeGameButtonBottom.setTitle( "Change game", forState: .Normal)
        
        ChangeGameButtonTop.titleLabel!.font = UIFont(name: "Kankin", size: 25)!
        ChangeGameButtonTop.setTitleColor(UIColor(netHex: 0xeeeeee), forState: UIControlState.Normal)
        //ChangeGameButtonTop.titleLabel!.text = "Random game"
        ChangeGameButtonTop.setTitle( "Change game", forState: .Normal)
        
        
        QuitButtonBottom.titleLabel!.font = UIFont(name: "Kankin", size: 20)!
        QuitButtonBottom.setTitleColor(UIColor(netHex: 0xeeeeee), forState: UIControlState.Normal)
        QuitButtonBottom.titleLabel!.text = "Quit"
        
        QuitButtonTop.titleLabel!.font = UIFont(name: "Kankin", size: 20)!
        QuitButtonTop.setTitleColor(UIColor(netHex: 0xeeeeee), forState: UIControlState.Normal)
        QuitButtonTop.titleLabel!.text = "Quit"
        
        
        
        // flip the buttons and labels that need to be flipped
        displayLabelTop.flipUpSideDown()
        ContinueButtonTop.flipUpSideDown()
        ChangeGameButtonTop.flipUpSideDown()
        
        P1ScoreNameTop.flipUpSideDown()
        P1ScoreValueTop.flipUpSideDown()
        P2ScoreNameTop.flipUpSideDown()
        P2ScoreValueTop.flipUpSideDown()
        
        QuitButtonTop.flipUpSideDown()
        muteBtnTop.flipUpSideDown()
        BlueSheepImage.flipUpSideDown()
        
        
        if(settings.isMute() == false){
            settings.setVolumePre(settings.getVolume())
            muteBtnBottom.setImage(UIImage(named: "sound_on"), forState: .Normal)
            muteBtnTop.setImage(UIImage(named: "sound_on"), forState: .Normal)
        }
        else{
            muteBtnBottom.setImage(UIImage(named: "sound_off"), forState: .Normal)
            muteBtnTop.setImage(UIImage(named: "sound_off"), forState: .Normal)
        }
    }
    
    func displayScore(){
        // displays the current score of the match
        
        P1ScoreNameBottom.text = "Red's Score:"
        P1ScoreNameTop.text    = "Red's Score:"
        P1ScoreValueBottom.text = "\(Player1.getTotalPlayerScore())"
        P1ScoreValueTop.text    = "\(Player1.getTotalPlayerScore())"
        
        P2ScoreNameBottom.text = "Blue's Score:"
        P2ScoreNameTop.text    = "Blue's Score:"
        P2ScoreValueBottom.text = "\(Player2.getTotalPlayerScore())"
        P2ScoreValueTop.text    = "\(Player2.getTotalPlayerScore())"
    }
    
    func buttons(){
        //segue to the gameover view when the number of rounds are reached
        if(ROUND >= numberOfRoundsPerMatch + 1){
            roundAudio!.stop()
            performSegueWithIdentifier("GameOver", sender: self)
        }
        
        // make the  buttons blink
        ContinueButtonBottom.blinkingButton()
        ContinueButtonTop.blinkingButton()
        
        // do some fading animations
        displayLabelBottom.fadeOut(1, delay: 0, completion: {_ in
            self.displayLabelBottom.text = "\(self.segues[self.rand])"
            self.displayLabelBottom.fadeIn()
        })
        displayLabelTop.fadeOut(1, delay: 0, completion: {_ in
            self.displayLabelTop.text = "\(self.segues[self.rand])"
            self.displayLabelTop.fadeIn()
        })
        
        P1ScoreNameBottom.fadeOut(1, delay: 0, completion: {_ in
            self.ContinueButtonBottom.fadeIn()
            self.ContinueButtonTop.fadeIn()
            self.ChangeGameButtonBottom.fadeIn()
            self.ChangeGameButtonTop.fadeIn()
            self.QuitButtonTop.fadeIn()
            self.QuitButtonBottom.fadeIn()
        })
        
        P1ScoreValueBottom.fadeOut()
        P1ScoreNameTop.fadeOut()
        P1ScoreValueTop.fadeOut()
        
        P2ScoreNameBottom.fadeOut()
        P2ScoreValueBottom.fadeOut()
        P2ScoreNameTop.fadeOut()
        P2ScoreValueTop.fadeOut()
        
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
