//
//  GameOverViewController.swift
//  qlobe
//
//  Created by allen rand on 12/9/15.
//  Copyright © 2015 qlobe. All rights reserved.
//

import UIKit

class GameOverViewController: UIViewController {
    
    //MARK: outlets
    
    
    @IBOutlet weak var winnerLabel: UILabel!
    //@IBOutlet weak var redPlayerLabel: UILabel!
    //@IBOutlet weak var bluePlayerLabel: UILabel!
    @IBOutlet weak var redTextView: UITextView!
    @IBOutlet weak var blueTextView: UITextView!
    
    @IBOutlet weak var MiddleView: UIView!
    @IBOutlet weak var TopView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(netHex: 0x2c3e50)
        // Do any additional setup after loading the view.
        style()
        display()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func style(){
        // sets the styling of the view to match the rest of the app
        
        view.backgroundColor = UIColor(netHex:0x2c3e50)
        
        // set text view styling
        redTextView.selectable = true
        redTextView.editable = true
        blueTextView.selectable = true
        blueTextView.editable = true
        
        
        redTextView.font = UIFont(name: "Kankin", size: 18)
        redTextView.textColor = UIColor(netHex: 0xeeeeee)
        redTextView.textAlignment = NSTextAlignment.Left
        redTextView.backgroundColor = UIColor(netHex:0x2c3e50)
        
        blueTextView.font = UIFont(name: "Kankin", size: 18)
        blueTextView.textColor = UIColor(netHex: 0xeeeeee)
        blueTextView.textAlignment = NSTextAlignment.Left
        blueTextView.backgroundColor = UIColor(netHex:0x2c3e50)
        
        
        redTextView.selectable = false
        redTextView.editable = false
        blueTextView.selectable = false
        blueTextView.editable = false
        
        // set label styling
//        redPlayerLabel.font = UIFont(name: "Kankin", size: 25)
//        redPlayerLabel.textColor = UIColor(netHex: 0xe74c3c)
//        redPlayerLabel.textAlignment = NSTextAlignment.Center
//        redPlayerLabel.text = "Red"
//        
//        bluePlayerLabel.font = UIFont(name: "Kankin", size: 25)
//        bluePlayerLabel.textColor = UIColor(netHex: 0x2980b9)
//        bluePlayerLabel.textAlignment = NSTextAlignment.Center
//        bluePlayerLabel.text = "Blue"
        
        // winner label styling
        winnerLabel.font = UIFont(name: "Kankin", size: 40)
        winnerLabel.textColor = UIColor(netHex: 0xe74c3c)
        winnerLabel.textAlignment = NSTextAlignment.Center
        
        
        if(Player1.getTotalPlayerScore() > Player2.getTotalPlayerScore()){
            winnerLabel.text = "Red is the winner!"
            winnerLabel.textColor = UIColor(netHex: 0xe74c3c)
            MiddleView.backgroundColor = UIColor(netHex: 0xe74c3c)
            TopView.backgroundColor = UIColor(netHex: 0xe74c3c)
            
        }else if( Player1.getTotalPlayerScore() < Player2.getTotalPlayerScore()){
            winnerLabel.text = "Blue is the Winner!"
            winnerLabel.textColor = UIColor(netHex: 0x2980b9)
            MiddleView.backgroundColor = UIColor(netHex: 0x2980b9)
            TopView.backgroundColor = UIColor(netHex: 0x2980b9)
            
        }else{
            winnerLabel.text = "It's a tie!"
            winnerLabel.textColor = UIColor(netHex: 0xbdc3c7)
            MiddleView.backgroundColor = UIColor(netHex: 0xbdc3c7)
            TopView.backgroundColor = UIColor(netHex: 0xebdc3c7)
        }
    }
    
    
    func display(){
        // displays all of the stats and information in the text views
        var redString = ""
        var blueString = ""
        // round, game, score
        for(var r = 0; r < Player1.getTotalRounds();  r++){
            redString  = redString + "Round \(r+1): \(Player1.getRoundScore(r)) \n"
            blueString = blueString + "Round \(r+1): \(Player2.getRoundScore(r)) \n"
        }
        
        // total scores
        if(Player1.getTotalRounds() != 0){
            redString = redString + "\nTotal score: \(Player1.getTotalPlayerScore()) \n"
            blueString = blueString + "\nTotal score: \(Player2.getTotalPlayerScore()) \n"
            
            // average score
            redString = redString + "\nAverage score: \(Player1.getAverageScore()) \n"
            blueString = blueString + "\nAverage score: \(Player2.getAverageScore()) \n"
        }else{
            // if no rounds have been played
            redString = "No Rounds Played"
            blueString = redString
        }
        redTextView.text = redString
        blueTextView.text = blueString
        
    }
    
}
