//
//  LoadMainViewController.swift
//  qlobe
//
//  Created by allen rand on 11/18/15.
//  Copyright © 2015 qlobe. All rights reserved.
//

//
//  loadMainViewController.swift
//  qlobe
//
//  Created by Aaron Knaack on 11/6/15.
//  Copyright © 2015 qlobe. All rights reserved.
//

import UIKit
import Parse

class loadMainViewController: UIViewController, HolderViewDelegate{
    
    // timer to control the animation
    var timerCount   = 1
    var timer        = NSTimer()
    var timerRunning = false
    
    // animation object
    var holderView = HolderView(frame: CGRectZero)
    
    //create new pfQuery - This is the bridge between our app and Parse: "trivia" is our class name on Parse
    let queryTrivia: PFQuery = PFQuery(className:"Trivia")
    var didLoad = false
    
    
    
    @IBOutlet weak var label1: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        label1.text = ""
        
        
        //retrieve data from parse query
        retrieveTrivia()
        
        //Start the loading animation
        addHolderView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func retrieveTrivia() {
        
        //This CLOSURE gives access to all objects in "trivia" class using our queryTrivia Bridge
        queryTrivia.findObjectsInBackgroundWithBlock { (objects:[PFObject]?, error:NSError?) -> Void in
            
            // Loop through the objects array
            for triviaObject in objects!{
                
                // Retrieve data for each object (key, question, ans2, ans3, correctAns)
                let triviaQuestion_ : String? = (triviaObject as PFObject)["Question"] as? String
                let triviaWrongAnswer1 : String? = (triviaObject as PFObject)["WrongAnswer1"] as? String
                let triviaWrongAnswer2 : String? = (triviaObject as PFObject)["WrongAnswer2"] as? String
                let triviaAnswer : String? = (triviaObject as PFObject)["Answer"] as? String
                let triviaKey : Int? = (triviaObject as PFObject)["Key"] as? Int
                
                //Check that items are not nil, and create trivia object, add to triviaQuestions Array
                if ( triviaKey != nil && triviaQuestion_ != nil && triviaWrongAnswer1 != nil &&  triviaWrongAnswer2 != nil && triviaAnswer != nil){
                    let trivia = triviaQuestion(Key: triviaKey!, Question: triviaQuestion_!, Answer: triviaAnswer!, WrongAnswer:  triviaWrongAnswer1!, WrongAnswer2:  triviaWrongAnswer2!)
                    triviaQuestions.append(trivia) // append to the global array of trivia questions
                    self.didLoad = true
                    
                }else{
                    self.label1.text = "Network Error"
                    self.didLoad = false
                }
            }// end for
        }// end closure
    }// end retrieve trivia
    
    
    // creat animation
    func addHolderView() {
        let boxSize: CGFloat = 100.0
        holderView.frame = CGRect(x: view.bounds.width / 2 - boxSize / 2,
            y: view.bounds.height / 2 - boxSize / 2,
            width: boxSize,
            height: boxSize)
        holderView.parentFrame = view.frame
        holderView.delegate = self
        view.addSubview(holderView)
        holderView.addOval()
    }
    
    
    // animation content
    func animateLabel() {
        // 1
        holderView.removeFromSuperview()
        view.backgroundColor = Colors.blue
        
        // 2
        let label: UILabel = UILabel(frame: view.frame)
        label.textColor = Colors.white
        //label.font = UIFont(name: "HelveticaNeue-Thin", size: 120.0)
        label.font = UIFont(name: "Kankin", size: 120.0)
        label.textAlignment = NSTextAlignment.Center
        label.text = "qLobe"
        label.transform = CGAffineTransformScale(label.transform, 0.25, 0.25)
        view.addSubview(label)
        
        
        // 3
        //        UIView.animateWithDuration(0.4, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.1, options: UIViewAnimationOptions.CurveEaseInOut,
        //            animations: ({
        //                label.transform = CGAffineTransformScale(label.transform, 4.0, 4.0)
        //            }), completion: { finished in
        //                self.addButton()
        //        })
        
        //3
        UIView.animateWithDuration(0.4, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.1, options: UIViewAnimationOptions.CurveEaseInOut,
            animations: ({
                label.transform = CGAffineTransformScale(label.transform, 4.0, 4.0)
            }), completion: nil)
        
        runTimer()
    }
    
    // timer function
    func Counting(){
        print(timerCount)
        if(timerCount > 0){
            timerCount -= 1
        }
        else{
            timerRunning = false
            timerCount   = 1
            if ( didLoad == true) {
                //perform segue to View Controller : Main menu
                timer.invalidate()
                self.performSegueWithIdentifier("finnishLoad", sender: self)
            }
        }
    }
    
    func runTimer(){
        if(timerRunning == false){
            // run the timer
            timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: Selector("Counting"), userInfo: nil, repeats: true)
            timerRunning = true
        }
    }
}



