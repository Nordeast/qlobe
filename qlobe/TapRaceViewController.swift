//
//  TapRaceViewController.swift
//  qlobe
//
//  Created by allen rand on 11/10/15.
//  Copyright © 2015 qlobe. All rights reserved.
//

import UIKit

class TapRaceViewController: UIViewController {
    // MARK: Class variables
    var P1Taps : Int = 0 // number of taps for P1
    var P2Taps : Int = 0 // number of taps for P2
    let coloredSquare1 = UIView()// square that races across th screen for P1
    let coloredSquare2 = UIView()// square that races across th screen for P2
    var CS1Position: CGFloat = 0 // holds the current position of P1 racer
    var CS2Position: CGFloat = 0 // holds the current position of P1 racer
    let WIN_TAPS = 3 //number of taps needed to win 43
    // ready set go animation times
    let DELAY = 0.7
    let DURATION = 0.5
    let DURATION2 = 0.3
    // MARK: Outlets
    
    @IBOutlet weak var RSG1X: NSLayoutConstraint!
    @IBOutlet weak var RSG2X: NSLayoutConstraint!
    @IBOutlet weak var readySetGo1: UILabel!
    @IBOutlet weak var readySetGo2: UILabel!
    @IBOutlet weak var TapRace: UILabel!
    
    // MARK: Button Actions
    
   @IBAction func Player1Tap(sender: AnyObject) {
        // button that P1 taps
    
        P1Taps++
    
        P1Animate()
    
        // if P1 gets to 50 taps then call winner
           if(P1Taps == WIN_TAPS){
            winner(1)
        }
    
    }
    @IBAction func Player2Tap(sender: AnyObject) {
        // button that P1 taps
        P2Taps++
        
        P2Animate()
        
        // if P1 gets to  taps then call winner
        if(P2Taps == WIN_TAPS){
            winner(2)
            
            // hide the tap buttons

        }
    }
 
    // MARK: Outlets

    
    // MARK: ViewController functions
    override func viewDidLoad() {
        super.viewDidLoad()
                // Do any additional setup after loading the view.
        
        
        Player1ButtonSetUp()
        Player2ButtonSetUp()
        Player2Tap.alpha = 0
        Player1Tap.alpha = 0
        coloredSquare2.alpha = 0
        coloredSquare1.alpha = 0
        TapRace.alpha = 0
        readySetGo1.alpha = 0
        readySetGo2.alpha = 0
        
        // background
        view.backgroundColor = UIColor(netHex:0x2c3e50)
        // TapRace label styling
        TapRace.font = UIFont(name: "Kankin", size: 80.0)
        TapRace.textColor = UIColor(netHex: 0xeeeeee)
        TapRace.textAlignment = NSTextAlignment.Center
        
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
        readySetGo2.transform = CGAffineTransformMakeRotation(CGFloat(M_PI))
    }
    
    override func viewDidAppear(animated: Bool) {
        
        readySetGoAnimation()
        animationSetUp()

    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    // MARK: Helper Functons
    func readySetGoAnimation(){
        // displays ready set go before the start of the race


        self.readySetGo1.alpha = 1
        self.readySetGo2.alpha = 1

       
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
        //fades the game in
        
        Player2Tap.fadeIn(0.3)
        Player1Tap.fadeIn(0.3)
        coloredSquare2.fadeIn(0.3)
        coloredSquare1.fadeIn(0.3)
        readySetGo1.removeFromSuperview()
        readySetGo2.removeFromSuperview()
        
    }
    func animateReady(){
        // animates text sliding in and then out for text ready
        
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
        
        // animates text sliding in and then out for text set
        
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
        
        // animates text sliding in and then out for text go

        
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


    
    func winner(player : Int){
        // clear the view to display the winner
        
        Player1Tap.fadeOut(1.0, delay: 0, completion: {_ in self.Player1Tap.removeFromSuperview()})
        Player2Tap.fadeOut(1.0, delay: 0, completion: {_ in self.Player2Tap.removeFromSuperview()})
        coloredSquare1.fadeOut(1.0, delay: 0, completion: {_ in  self.coloredSquare1.removeFromSuperview()})
        coloredSquare2.fadeOut(1.0, delay: 0, completion: {_ in  self.coloredSquare2.removeFromSuperview()})
        // display who won
        TapRace.text = "P\(player) Wins!"
        TapRace.fadeIn(1.0, delay: 2.0)
        UIView.animateWithDuration(1.0, delay: 4.0, options: [],
            
            animations: { self.TapRace.transform = CGAffineTransformMakeRotation(CGFloat(M_PI))
            
            },
            
            completion: { _ in
                UIView.animateWithDuration(1.0, delay: 4.0, options: [], animations: {
                    self.TapRace.text = "Total Taps \(self.P1Taps)"
                },
                    completion: { _ in
                        
                        self.performSegueWithIdentifier("ScoreBoardFromTapRace", sender: self)
                        
                        
                })
            
        })
        
    }
        
        
       
        

    func animationSetUp(){
        
        // Create and add a colored square
        
        
        // set background color to green
        coloredSquare2.backgroundColor = UIColor.greenColor()
        
        // set frame (position and size) of the square

        coloredSquare2.frame = CGRect(x: 0, y: view.bounds.height/2 - 78, width: 50, height: 50)
        
        // finally, add the square to the screen
        self.view.addSubview(coloredSquare2)
        
        
        // set background color to green
        coloredSquare1.backgroundColor = UIColor.greenColor()
        
        // set frame (position and size) of the square
        coloredSquare1.frame = CGRect(x: 0, y: view.bounds.height/2 + 30, width: 50, height: 50)
        
        // finally, add the square to the screen
        self.view.addSubview(coloredSquare1)
        
    }
    
    func P1Animate(){
        
        // do the animation when a button is pressed. Move it across the screen 1/50th at a time
        
        UIView.animateWithDuration(0.5, animations: {
            
            
            if self.coloredSquare1.backgroundColor == UIColor.greenColor(){
                self.coloredSquare1.backgroundColor = UIColor.redColor()
            }
            else{
                self.coloredSquare1.backgroundColor = UIColor.greenColor()
            }
            // increment the distance of where the image is.
            self.CS1Position = self.CS1Position + self.view.bounds.width / 50

            // if statement will stop the animation from going off the screen
            if(self.CS1Position <= self.view.bounds.width - 50){
                self.coloredSquare1.frame = CGRect(x: self.CS1Position, y: self.coloredSquare1.center.y - 25, width: 50, height: 50)
            }
            
        })
        
    }
    
    func P2Animate(){
        
        // do the animation when a button is pressed. Move it across the screen 1/50th at a time
        
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
            if(self.CS2Position <= self.view.bounds.width - 50){
                self.coloredSquare2.frame = CGRect(x: self.CS2Position, y: self.coloredSquare2.center.y - 25, width: 50, height: 50)
            }
        })
        
    }
    
    
    // MARK: buttons
    
    // button 1 (bottom of the screen)
    var Player1Tap: UIButton!
    
    func Player1ButtonSetUp() {
        // set up and add the button programically
        Player1Tap = UIButton(type: UIButtonType.System) // .System
        
        Player1Tap.setTitle("TAP!", forState: UIControlState.Normal)

        Player1Tap.titleLabel?.font = UIFont.systemFontOfSize(45)
        Player1Tap.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        Player1Tap.backgroundColor = UIColor.redColor()
        
        Player1Tap.titleLabel?.font = UIFont(name: "HelveticaNeue-Thin", size: 40.0)
        
        Player1Tap.addTarget(self, action: Selector("Player1Tap:"), forControlEvents: UIControlEvents.TouchUpInside)

        self.view.addSubview(Player1Tap)
        
        Player1Tap.translatesAutoresizingMaskIntoConstraints = false
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
        
        Player2Tap.setTitle("TAP!", forState: UIControlState.Normal)
        

        Player2Tap.titleLabel?.font = UIFont.systemFontOfSize(45)
        Player2Tap.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)

        Player2Tap.backgroundColor = UIColor.blueColor()
        
        Player2Tap.titleLabel?.font = UIFont.systemFontOfSize(17)
        
        
        Player2Tap.addTarget(self, action: Selector("Player2Tap:"), forControlEvents: UIControlEvents.TouchUpInside)
        Player2Tap.titleLabel?.font = UIFont(name: "HelveticaNeue-Thin", size: 40.0)
        
        self.view.addSubview(Player2Tap)
        
        Player2Tap.translatesAutoresizingMaskIntoConstraints = false
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
