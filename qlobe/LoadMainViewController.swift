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

import UIKit
import Parse
import AVFoundation

class loadMainViewController: UIViewController, HolderViewDelegate{
    
    // timer for connection timeout
    var timerQuery = NSTimer()
    
    // animation object
    var holderView = HolderView(frame: CGRectZero)
    
    // Sound effect object
    var loadingAudio = try? AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("startPage", ofType: "mp3")!))
    
    //create new pfQuery - This is the bridge between our app and Parse: "trivia" is our class name on Parse
    let queryLocations: PFQuery = PFQuery(className: "triviaSpots")
    let queryTrivia: PFQuery = PFQuery(className:"Trivia")
    var didLoad = false
    var triviaDidLoad = false
    var placesDidLoad = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(animated: Bool) {
        
        //Start the loading animation
        addHolderView()
        
        // display start up audio
        loadingAudio!.play()
        
        //retrieve data from parse query, and wait for animation to be loaded
        _ = NSTimer.scheduledTimerWithTimeInterval(5.5, target: self, selector: "retrieveParseData",
            userInfo: nil, repeats: false)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func retrieveParseData() {
        
        // check Internet Connection, if no internet, show alert
        if(Reachability.isConnectedToNetwork() == false){
            self.didLoad = false
            print("No Internet!!")
            handleNetworkError()
            return
        }
        
        timerQuery = NSTimer.scheduledTimerWithTimeInterval(25, target: self, selector: Selector("handleNetworkError"), userInfo: nil, repeats: false)
        
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
                let triviaLocation : PFGeoPoint? = (triviaObject as PFObject)["relatedRegion"] as? PFGeoPoint
                
                //Check that items are not nil, and create trivia object, add to triviaQuestions Array
                if ( triviaKey != nil && triviaQuestion_ != nil && triviaWrongAnswer1 != nil &&  triviaWrongAnswer2 != nil && triviaAnswer != nil){
                    let trivia = triviaQuestion(Key: triviaKey!, Question: triviaQuestion_!, Answer: triviaAnswer!, WrongAnswer:  triviaWrongAnswer1!, WrongAnswer2:  triviaWrongAnswer2!, RelatedRegion: triviaLocation!)
                    triviaQuestions.append(trivia) // append to the global array of trivia questions
                    
                    if(triviaQuestions.count == objects!.count){
                        self.didLoad = true
                        self.triviaDidLoad = true
                    }
                    
                }else{
                    print("Network Error")
                    self.didLoad = false
                }
            }// end for
            
            triviaDuplicate = triviaQuestions   // this is used to repeat questions after all have been gone through.
            
            if(self.didLoad == true && self.placesDidLoad == true && self.triviaDidLoad == true){
                self.timerQuery.invalidate()
                
                self.performSegueWithIdentifier("finnishLoad", sender: self)
            }
        }// end triviaQuery closure
        
        queryLocations.findObjectsInBackgroundWithBlock { (objects:[PFObject]?, error:NSError?) -> Void in
            
            for locationObject in objects!{
                
                // Retrieve data for each object
                let left : Double? = (locationObject as PFObject)["leftlong"] as? Double
                let right : Double? = (locationObject as PFObject)["rightlong"] as? Double
                let top : Double? = (locationObject as PFObject)["toplat"] as? Double
                let bot : Double? = (locationObject as PFObject)["botlat"] as? Double
                let name : String? = (locationObject as PFObject)["name"] as? String
                let point : PFGeoPoint? = (locationObject as PFObject)["generalPoint"] as? PFGeoPoint
                
                //Check that items are not nil, and create new location to append to locationOptions global
                if ( left != nil && right != nil && top != nil &&  bot != nil && name != nil && point != nil){
                    
                    let newPlace = LocationDS(top_lat: top!, bot_lat: bot!, right_long: right!, left_long: left!, name: name!, generalArea: point!)
                    locationOptions.append(newPlace)
                    
                    if(locationOptions.count == objects!.count){
                        self.didLoad = true
                        self.placesDidLoad = true
                    }
                    
                }else{
                    print("Network Error")
                    self.didLoad = false
                }
                
            }// end for
            
            if(self.didLoad == true && self.placesDidLoad == true && self.triviaDidLoad == true){
                self.timerQuery.invalidate()
                
                self.performSegueWithIdentifier("finnishLoad", sender: self)
            }
            
        }// end location query closure
        
    }// end retrieve parse data
    
    
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
        
        UIView.animateWithDuration(0.4, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.1, options: UIViewAnimationOptions.CurveEaseInOut,
            animations: ({
                label.transform = CGAffineTransformScale(label.transform, 4.0, 4.0)
            }), completion: nil)
    }
    
    func handleNetworkError(){
        //Create the AlertController
        let actionSheetController: UIAlertController = UIAlertController(title: "Network Error!", message: "Choose Setting to check the network, or Retry Otherwise", preferredStyle: .Alert)
        
        //Create and add the Cancel action
        let settingAction: UIAlertAction = UIAlertAction(title: "Setting", style: .Cancel) { action -> Void in
            //Do some stuff
            UIApplication.sharedApplication().openURL(NSURL(string: UIApplicationOpenSettingsURLString)!)
            self.retrieveParseData()
        }
        actionSheetController.addAction(settingAction)
        
        //Create and an option action
        let retryAction: UIAlertAction = UIAlertAction(title: "Retry", style: .Default) { action -> Void in
            self.retrieveParseData()
        }
        actionSheetController.addAction(retryAction)
        
        //Present the AlertController
        self.presentViewController(actionSheetController, animated: true, completion: nil)
    }
}



