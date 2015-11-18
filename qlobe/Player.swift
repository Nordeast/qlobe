 //: Playground - noun: a place where people can play
 
 import Foundation
 
 var Player1 = Player(playerNumber : 1) // player on the bottom of the screen
 var Player2 = Player(playerNumber : 2) // player on the top of the screen
 
 class Player {
    // Player class to hold the information of each of the players in the
    // qlobe game. One object is needed for each player.
    
    var playerNumber : Int // unique player to identify each class
    var score : Int
    var numberQuestionsCorrect : Int
    var numberQuestionsIncorrect : Int
    
    init(playerNumber : Int){
        // playerNumber must be a unique number
        self.playerNumber = playerNumber
        score = 0
        numberQuestionsCorrect = 0
        numberQuestionsIncorrect = 0
    }
    
    //// get functions ////
    func getPlayerNumber() -> Int{
        return playerNumber
    }
    
    func getPlayerScore() -> Int{
        return score
    }
    
    func getQuestionsCorrect() -> Int{
        return numberQuestionsCorrect
    }
    
    func getQuestionsIncorrect() -> Int{
        return numberQuestionsIncorrect
    }
    
    //// class functionality ////
    
    func getAverageScore() -> Double {
        // returns the average points earned for all of the questions
        
        var average : Double = 0
        average = Double(score) / Double(numberQuestionsCorrect + numberQuestionsIncorrect)
        return average
    }
    
    func gotQuestionWrong(){
        // increments the questions incorrect counter
        numberQuestionsIncorrect++
    }
    
    func gotQuestionRight(){
        // increments the questions correct counter
        numberQuestionsCorrect++
    }
    
    func addScore(seconds : Int){
        // does the score calculation based on how quickly the player answered the question
        score += seconds
    }
    
    func NewGame(){
        // reset the players fields to start a new game
        
        score = 0
        numberQuestionsCorrect = 0
        numberQuestionsIncorrect = 0
    }
    
 }
 
 
 
 
 
