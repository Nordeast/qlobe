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

class loadMainViewController: UIViewController{

    
    //create new pfQuery - This is the bridge between our app and Parse: "trivia" is our class name on Parse
    let queryTrivia: PFQuery = PFQuery(className:"trivia")
    var didLoad = true
    
    
    
    @IBOutlet weak var label1: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(netHex:0x2c3e50)
        label1.font = UIFont(name: "Kankin", size: 80.0)
        label1.textColor = UIColor(netHex: 0xeeeeee)
        label1.textAlignment = NSTextAlignment.Center
        
        //retrieve data from parse query
        retrieveTrivia()


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
                if(self.label1.text == "Loading..."){
                    self.label1.text = "Loadng"
                }else if self.label1.text == "Loading"{
                    self.label1.text = "Loadng."
                }else if self.label1.text == "Loading."{
                    self.label1.text = "Loadng.."
                }else if self.label1.text == "Loading.."{
                    self.label1.text = "Loadng..."
                }else {
                    self.label1.text = "Loadng..."
                }
                // Retrieve data for each object (key, question, ans2, ans3, correctAns)
                let triviaQuest : String? = (triviaObject as PFObject)["question"] as? String
                let triviaAns2 : String? = (triviaObject as PFObject)["ans2"] as? String
                let triviaAns3 : String? = (triviaObject as PFObject)["ans3"] as? String
                let triviaAns : String? = (triviaObject as PFObject)["correctAns"] as? String
                let triviaKey : Int? = (triviaObject as PFObject)["key"] as? Int
                
                //Check that items are not nil, and create trivia object, add to triviaQuestions Array
                if ( triviaKey != nil && triviaQuest != nil && triviaAns2 != nil &&  triviaAns3 != nil && triviaAns != nil){
                    let trivia = triviaQuestion(Key: triviaKey!, Question: triviaQuest!, Answer: triviaAns!, WrongAnswer:  triviaAns2!, WrongAnswer2:  triviaAns3!)
                    triviaQuestions.append(trivia) // append to the global array of trivia questions
                    
                    
                }else{
                    self.label1.text = "Network Error"
                    self.didLoad = false
                }
                
            }
            
            
            for element in triviaQuestions{
                print(element.Key, element.Question)
            }
            
                        if (self.didLoad == true) {
                            //perform segue to View Controller : Main menu
                            self.performSegueWithIdentifier("finnishLoad", sender: self)
                        }
            
        }
        
        
    }
    
    
}



