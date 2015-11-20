//
//  QuestionViewController.swift
//  qlobe
//
//  Created by Ted Chuang on 10/27/15.
//  Copyright © 2015 qlobe. All rights reserved.
//

//self.view.backgroundColor = UIColorFromRGB(0x34495e) //Wet Asphalt
//self.view.backgroundColor = UIColorFromRGB(0xbfbfbf) //Silver
//self.view.backgroundColor = UIColorFromRGB(0xeab18f) //Me
//self.view.backgroundColor = UIColorFromRGB(0xc3a791) //Activity
//self.view.backgroundColor = UIColorFromRGB(0xc9baae) //searcch
//self.view.backgroundColor = UIColorFromRGB(0xb5a9a6) //GROUP
//self.view.backgroundColor = UIColorFromRGB(0x8b877b) //Statics
//self.view.backgroundColor = UIColorFromRGB(0x7e787e) // About
//self.view.backgroundColor = UIColorFromRGB(0xdadccf) //textbackground
//self.view.backgroundColor = UIColorFromRGB(0xf9f3e6) // viewBackground
//self.view.backgroundColor = UIColorFromRGB(0x2c3e50) // Homepage Background

import UIKit
import Parse

let TimerStartValue = 5

let ColorTextColor       = 0xffffff

let ColorViewBackground  = 0x2c3e50
let ColorQuestion        = 0xeab18f
let ColorAnsInit         = 0xc9baae
let ColorPlayerSelect    = 0x8b877b
let ColorCorrectAnswer   = 0xf9f3e6

let ColorTimer           = 0xffffff
let ColorScoreLabel      = 0xffffff
let ColorScoreValue      = 0xffffff

class QuestionViewController: UIViewController {
    
    //////////////////////
    // class variables //
    /////////////////////
    var timerCount = TimerStartValue
    
    var timerRunning = false
    var timer = NSTimer()
    
    var P1DidSelectAnAnswer = false
    var P2DidSelectAnAnswer = false
    
    var answerP1 = ""
    var answerP2 = ""
    
    var Player1AnsTime  = TimerStartValue
    var Player2AnsTime  = TimerStartValue
    
    var curQuestion = triviaQuestion()
    /////////////////////////
    // end class variables //
    /////////////////////////
    
    
    /////////////
    // outlets //
    /////////////
    
    @IBOutlet weak var timerLabel1: UILabel!
    @IBOutlet weak var timerLabel2: UILabel!
    
    @IBOutlet weak var question: UILabel!
    @IBOutlet weak var questionUpsideDown: UILabel!
    
    
    // score labels
    @IBOutlet weak var Player1ScoreLabel: UILabel!
    @IBOutlet weak var Player1ScoreValue: UILabel!
    
    @IBOutlet weak var Player2ScoreLabel: UILabel!
    @IBOutlet weak var Player2ScoreValue: UILabel!
    
    // p1 buttons (bottom of the screen)
    // ordering
    // button 1
    // button 2
    // button 3
    @IBOutlet weak var Player1Button1: UIButton!
    @IBOutlet weak var Player1Button2: UIButton!
    @IBOutlet weak var Player1Button3: UIButton!
    
    // p2 buttons (top of the screen)
    // ordering
    // button 1
    // button 2
    // button 3
    @IBOutlet weak var Player2Button1: UIButton!
    @IBOutlet weak var Player2Button2: UIButton!
    @IBOutlet weak var Player2Button3: UIButton!
    
    /////////////////
    // end outlets //
    /////////////////
    
    /////////////
    // actions //
    /////////////
    
    // p1 buttons (bottom of the screen)
    // ordering
    // button 1
    // button 2
    // button 3
    
    @IBAction func Player1Button1(sender: AnyObject) {
        
       
        if (P1DidSelectAnAnswer == false){ // check if an answer has been chosen yet
            answerP1 = (Player1Button1.titleLabel?.text)!// grab the answer
            Player1Button1.titleLabel!.textColor = UIColor(netHex: 0x2980b9) // change the background color to show selected answer
        }
        P1DidSelectAnAnswer = true // set to true so the no other anwers can be selected
        
    }
    @IBAction func Player1Button2(sender: AnyObject) {
        
        
        if (P1DidSelectAnAnswer == false){ // check if an answer has been chosen yet
            answerP1 = (Player1Button2.titleLabel?.text)! // grab the answer
            Player1Button2.titleLabel!.textColor = UIColor(netHex: 0x2980b9)  // change the background color to show selected answer
        }
        P1DidSelectAnAnswer = true // set to true so the no other anwers can be selected
        
    }
    
    @IBAction func Player1Button3(sender: AnyObject) {
        
        
        if (P1DidSelectAnAnswer == false){ // check if an answer has been chosen yet
            answerP1 = (Player1Button3.titleLabel?.text)!// grab the answer
            Player1Button3.titleLabel!.textColor = UIColor(netHex: 0x2980b9)  // change the background color to show selected answer
        }
        P1DidSelectAnAnswer = true // set to true so the no other anwers can be selected
        
    }
    
    
    
    
    // p2 buttons (top of the screen)
    // ordering
    // button 1
    // button 2
    // button 3
    
    
    @IBAction func Player2Button1(sender: AnyObject) {
        
        
        if (P2DidSelectAnAnswer == false){ // check if an answer has been chosen yet
            answerP2 = (Player2Button1.titleLabel?.text)! // grab the answer
            Player2Button1.titleLabel!.textColor = UIColor(netHex: 0x2980b9)   // change the background color to show selected answer
        
        
        }
        P2DidSelectAnAnswer = true // set to true so the no other anwers can be selected
        
    }
    
    
    @IBAction func Player2Button2(sender: AnyObject) {
        
        
        if (P2DidSelectAnAnswer == false){ // check if an answer has been chosen yet
            answerP2 = (Player2Button2.titleLabel?.text)! // grab the answer
            Player2Button2.titleLabel!.textColor = UIColor(netHex: 0x2980b9)
                    // change the background color to show selected answer
        }
        P2DidSelectAnAnswer = true // set to true so the no other anwers can be selected
        
    }
    
    
    @IBAction func Player2Button3(sender: AnyObject) {
        
        
        if (P2DidSelectAnAnswer == false){ // check if an answer has been chosen yet
            answerP2 = (Player2Button3.titleLabel?.text)!// grab the answer
            Player2Button3.titleLabel!.textColor = UIColor(netHex: 0x2980b9)
  // change the background color to show selected answer
        }
        P2DidSelectAnAnswer = true // set to true so the no other anwers can be selected
        
    }
    
    /////////////////
    // end actions //
    /////////////////
    
    
    
    //////////////////////
    // helper functions //
    //////////////////////
    
    //generates a random trivia object from global triviaQuestions
    func getRandomTrivia() -> triviaQuestion{
        let randIndex = Int(arc4random_uniform(UInt32(triviaQuestions.count-1)))
        return triviaQuestions[randIndex]
    }
    
    func randomizeStrings(answers: [String]) -> [String]{
        // will randomize the order of the string you pass it.
        var rand1 : [String] = []
        
        while(rand1.count != answers.count){
            let rand = Int(arc4random_uniform(UInt32(answers.count)))
            if(rand1.contains(answers[rand]) != true){
                rand1.append(answers[rand])
            }
        }
        return rand1
    }
    
    func setButtonContent(){
        curQuestion = getRandomTrivia()
        
        // set question contents
        question.text = curQuestion.Question
        questionUpsideDown.text = curQuestion.Question
        
        let Player1AnsList = curQuestion.getRandomAnswerArray()
        let Player2AnsList = curQuestion.getRandomAnswerArray()
        
        // set answer button contents
        Player1Button1.setTitle( Player1AnsList[0], forState: .Normal)
        Player1Button2.setTitle( Player1AnsList[1], forState: .Normal)
        Player1Button3.setTitle( Player1AnsList[2], forState: .Normal)
        
        Player2Button1.setTitle( Player2AnsList[0], forState: .Normal)
        Player2Button2.setTitle( Player2AnsList[1], forState: .Normal)
        Player2Button3.setTitle( Player2AnsList[2], forState: .Normal)
        
        // set scroe
        Player1ScoreValue.text =  "\(Player1.score)"
        Player2ScoreValue.text =  "\(Player2.score)"
    }
    
    func showCorrectAnswer(){
        if(Player1Button1.titleLabel!.text == curQuestion.Answer){
            Player1Button1.titleLabel?.textColor = UIColor(netHex: 0x27ae60)
            if(answerP1 != curQuestion.Answer){
                
                buttonBouncing(Player1Button1)
                
            }
            
        }
        else if(Player1Button2.titleLabel!.text == curQuestion.Answer){
            Player1Button2.titleLabel?.textColor = UIColor(netHex: 0x27ae60)
            if(answerP1 != curQuestion.Answer){
                
                buttonBouncing(Player1Button2)
            }
            
        }
        else if(Player1Button3.titleLabel?.text == curQuestion.Answer){
            Player1Button3.titleLabel?.textColor = UIColor(netHex: 0x27ae60)
            if(answerP1 != curQuestion.Answer){
                
                buttonBouncing(Player1Button3)
            }
           
        }
        
        if(Player2Button1.titleLabel!.text == curQuestion.Answer){
            Player2Button1.titleLabel?.textColor = UIColor(netHex: 0x27ae60)

            if(answerP2 != curQuestion.Answer){
                buttonBouncing(Player2Button1)
            }
            
        }
        else if(Player2Button2.titleLabel!.text == curQuestion.Answer){
            Player2Button2.titleLabel?.textColor = UIColor(netHex: 0x27ae60)
            if(answerP2 != curQuestion.Answer){
               
                buttonBouncing(Player2Button2)
            }
            
        }
        else if(Player2Button3.titleLabel!.text == curQuestion.Answer){
            Player2Button3.titleLabel?.textColor = UIColor(netHex: 0x27ae60)
            if(answerP2 != curQuestion.Answer){
                
                buttonBouncing(Player2Button3)
            }
            
        }
    }
    
    func updatePlayerScore(){

        
        if(answerP1 == curQuestion.getAnswer()){
            Player1.getQuestionsCorrect()
            Player1.addScore(Player1AnsTime * 100)
        }
        else{
            Player1.getQuestionsIncorrect()
        }
        
        if(answerP2 == curQuestion.getAnswer()){
            Player2.getQuestionsCorrect()
            Player2.addScore(Player2AnsTime * 100)
        }
        else{
            Player2.getQuestionsIncorrect()
        }
        
        Player1ScoreValue.text =  "\(Player1.score)"
        Player2ScoreValue.text =  "\(Player2.score)"
    }
    
    func resetAll(){
        // players have not yet selected an anwser
        P1DidSelectAnAnswer = false
        P2DidSelectAnAnswer = false
        
        // dummy answers
        answerP1 = ""
        answerP2 = ""
        
        //Timer
        timerLabel1.font = UIFont(name: "Kankin", size: 30.0)
        timerLabel1.textColor = UIColor(netHex: 0xeeeeee)
        timerLabel1.textAlignment = NSTextAlignment.Center
        
        timerLabel2.font = UIFont(name: "Kankin", size: 30.0)
        timerLabel2.textColor = UIColor(netHex: 0xeeeeee)
        timerLabel2.textAlignment = NSTextAlignment.Center
        //Score
        
        Player1ScoreLabel.font = UIFont(name: "Kankin", size: 30.0)
        Player1ScoreLabel.textColor = UIColor(netHex: 0xeeeeee)
        Player1ScoreLabel.textAlignment = NSTextAlignment.Center
        
        Player1ScoreValue.font = UIFont(name: "Kankin", size: 30.0)
        Player1ScoreValue.textColor = UIColor(netHex: 0xeeeeee)
        Player1ScoreValue.textAlignment = NSTextAlignment.Center
        
        Player2ScoreLabel.font = UIFont(name: "Kankin", size: 30.0)
        Player2ScoreLabel.textColor = UIColor(netHex: 0xeeeeee)
        Player2ScoreLabel.textAlignment = NSTextAlignment.Center
        
        Player2ScoreValue.font = UIFont(name: "Kankin", size: 30.0)
        Player2ScoreValue.textColor = UIColor(netHex: 0xeeeeee)
        Player2ScoreValue.textAlignment = NSTextAlignment.Center
        
        
        
        
        
        //Questions
        
        question.font = UIFont(name: "Kankin", size: 30.0)
        question.textColor = UIColor(netHex: 0xeeeeee)
        question.textAlignment = NSTextAlignment.Center
        
        questionUpsideDown.font = UIFont(name: "Kankin", size: 30.0)
        questionUpsideDown.textColor = UIColor(netHex: 0xeeeeee)
        questionUpsideDown.textAlignment = NSTextAlignment.Center
        
        
        // p1 buttons
        Player1Button1.titleLabel!.font = UIFont(name: "Kankin", size: 20)!
        Player1Button1.setTitleColor(UIColor(netHex: 0xeeeeee), forState: UIControlState.Normal)
        
        
        Player1Button2.titleLabel!.font = UIFont(name: "Kankin", size: 20)!
        Player1Button2.setTitleColor(UIColor(netHex: 0xeeeeee), forState: UIControlState.Normal)
        
        
        Player1Button3.titleLabel!.font = UIFont(name: "Kankin", size: 20)!
        Player1Button3.setTitleColor(UIColor(netHex: 0xeeeeee), forState: UIControlState.Normal)
        


        // p2 buttons
        Player2Button1.titleLabel!.font = UIFont(name: "Kankin", size: 20)!
        Player2Button1.setTitleColor(UIColor(netHex: 0xeeeeee), forState: UIControlState.Normal)
        
        
        Player2Button2.titleLabel!.font = UIFont(name: "Kankin", size: 20)!
        Player2Button2.setTitleColor(UIColor(netHex: 0xeeeeee), forState: UIControlState.Normal)
        
    
        Player2Button3.titleLabel!.font = UIFont(name: "Kankin", size: 20)!
        Player2Button3.setTitleColor(UIColor(netHex: 0xeeeeee), forState: UIControlState.Normal)
        
    }
    
    func flipButton(){
        timerLabel2.transform = CGAffineTransformMakeRotation(CGFloat(M_PI))
        questionUpsideDown.transform = CGAffineTransformMakeRotation(CGFloat(M_PI))
        
        Player2Button1.transform = CGAffineTransformMakeRotation(CGFloat(M_PI))
        Player2Button2.transform = CGAffineTransformMakeRotation(CGFloat(M_PI))
        Player2Button3.transform = CGAffineTransformMakeRotation(CGFloat(M_PI))
        
        Player2ScoreLabel.transform = CGAffineTransformMakeRotation(CGFloat(M_PI))
        Player2ScoreValue.transform = CGAffineTransformMakeRotation(CGFloat(M_PI))
    }
    
    func Counting(){
        if(timerCount > 0){
            timerCount -= 1
            timerLabel1.text = "\(timerCount)"
            timerLabel2.text = "\(timerCount)"
            if(P1DidSelectAnAnswer == false){
                Player1AnsTime = timerCount
            }
            
            if(P2DidSelectAnAnswer == false){
                Player2AnsTime = timerCount
            }
        }
        else{
            timer.invalidate()
            timerRunning = false
            timerCount   = TimerStartValue
            P1DidSelectAnAnswer = true
            P2DidSelectAnAnswer = true
            
            showCorrectAnswer()
            updatePlayerScore()
        }
    }
    
    func runTimer(){
        timerLabel1.text = "\(timerCount)"
        timerLabel2.text = "\(timerCount)"
        
        if(timerRunning == false){
            // run the timer
            timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: Selector("Counting"), userInfo: nil, repeats: true)
            timerRunning = true
        }
    }
    
    
    //////////////////////////
    // end helper functions //
    //////////////////////////
    
    
    func buttonBouncing(button: UIButton){
        // three nested animations to bounce it to the left then to the right then back
        UIView.animateWithDuration(0.1, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 30, options: UIViewAnimationOptions.CurveEaseIn, animations:
            
        ({button.center.x = button.center.x + 5})
            
            , completion: {_ in UIView.animateWithDuration(0.1, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 30, options: UIViewAnimationOptions.CurveEaseIn, animations:
                
                ({button.center.x = button.center.x - 10})
                
                , completion: {_ in UIView.animateWithDuration(0.1, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 30, options: UIViewAnimationOptions.CurveEaseIn, animations:
                    
                    ({button.center.x = self.view.frame.width/2})
                    
                    , completion: nil)
            })
        })
    }
    
    /////////////////
    // view set up //
    /////////////////
    override func viewDidLoad() {
        super.viewDidLoad()

        // background
        view.backgroundColor = UIColor(netHex:0x2c3e50)

        resetAll()
        
        // set the content of all buttons labels
        setButtonContent()
        
        // flip the text and buttons upside down for the second user
        flipButton()
        
        runTimer() // start the timeer when the view loads
        
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    /////////////////////
    // end view set up //
    /////////////////////
    
    
}

