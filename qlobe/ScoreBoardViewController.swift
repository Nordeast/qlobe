//
//  ScoreBoardViewController.swift
//  qlobe
//
//  Created by allen rand on 11/17/15.
//  Copyright © 2015 qlobe. All rights reserved.
//

import UIKit
import AVFoundation

class ScoreBoardViewController: UIViewController {
    //var segues : [String] = ["Trivia", "TapRace", "SimonSays"]
    //var segues : [String] = ["Trivia", "TapRace"]
    //var segues : [String] = ["TapRace"]
    var segues : [String] = ["Trivia"]
    var rand = 0
    
    var tapRaceAudio = try? AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("mk64_racestart", ofType: "wav")!))
    
    var triviaAudio = try? AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("trivia", ofType: "wav")!))
    
    // MARK: ViewControler functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // background color
        view.backgroundColor = UIColor(netHex:0x2c3e50)
        
        // nextGameLabel label styling
        nextGameLabel.font = UIFont(name: "Kankin", size: 80.0)
        nextGameLabel.textColor = UIColor(netHex: 0xeeeeee)
        nextGameLabel.textAlignment = NSTextAlignment.Center
        
        rand = Int(arc4random_uniform(UInt32(segues.count)))
        
      
        print("random segue \(segues[rand]), \(rand)")
        nextGameLabel.text = segues[rand]
        
        // Play sound effect for TapRace
        if(nextGameLabel.text == "TapRace"){
            tapRaceAudio!.play()
        }
        else if(nextGameLabel.text == "Trivia"){
            triviaAudio!.play()
        }
        
        
        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(animated: Bool) {
        var segueDelay = 2.0
        
        // TapeRace needs 5 sec to play the sound effect
        if(nextGameLabel.text == "TapRace"){
           segueDelay = 5.0
        }
        
        // after the set amount of time segue to a random view
        _ = NSTimer.scheduledTimerWithTimeInterval(segueDelay, target: self, selector: "segueToNextGame",
            userInfo: nil, repeats: false)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func segueToNextGame(){
        
        // segue to the random next game
        performSegueWithIdentifier(segues[rand], sender: self)
    }
    
    
    // MARK: Outlets
    @IBOutlet weak var nextGameLabel: UILabel!
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
