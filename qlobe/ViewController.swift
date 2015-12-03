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

class ViewController: UIViewController {

    // MARK: outlets


    
    @IBOutlet weak var letsBegin: UIButton!
    
    @IBOutlet weak var settings: UIButton!
    
    @IBOutlet weak var help: UIButton!
    
    @IBOutlet weak var spacer2: UILabel!

    @IBAction func LetsBegin(sender: AnyObject) {
        // kill all the animations when the button is pressed
        view.layer.removeAllAnimations()
    }
    
    // MARK: ViewControler functions
    override func viewDidLoad() {
        super.viewDidLoad()

        spacer2.alpha = 0
        stylePage()
        // Do any additional setup after loading the view, typically from a nib.
    }
    override func viewDidAppear(animated: Bool) {
        blinkingButtons()
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
        settings.titleLabel!.font = UIFont(name: "Kankin", size: 30)!
        settings.setTitleColor(UIColor(netHex: 0xeeeeee), forState: UIControlState.Normal)
        //settings.backgroundColor = UIColor(netHex: 0x464a53)
        settings.titleLabel!.text = "Settings"
        
        // help button
        help.titleLabel!.font = UIFont(name: "Kankin", size: 30)!
        help.setTitleColor(UIColor(netHex: 0xeeeeee), forState: UIControlState.Normal)
        //help.backgroundColor = UIColor(netHex: 0x464a53)
        help.titleLabel!.text = "Help"
    }
    
    func blinkingButtons(){
        
        
        UIView.animateWithDuration(0.6, delay: 0, options: [.Repeat, .Autoreverse, .AllowUserInteraction],
            
            animations: {
                
                self.letsBegin.transform = CGAffineTransformMakeScale(1.1,1.1)
                
            },
            
            completion: nil)
        
        
        
        
    }
    
}

