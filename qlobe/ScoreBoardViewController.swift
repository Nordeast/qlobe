//
//  ScoreBoardViewController.swift
//  qlobe
//
//  Created by allen rand on 11/17/15.
//  Copyright © 2015 qlobe. All rights reserved.
//

import UIKit

class ScoreBoardViewController: UIViewController {
    var segues : [String] = ["Trivia", "TapRace", "SimonSays"]
    var rand = 0
    
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
        
        
        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(animated: Bool) {
        
        // after the set amount of time segue to a random view
        _ = NSTimer.scheduledTimerWithTimeInterval(2, target: self, selector: "segueToNextGame",
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
