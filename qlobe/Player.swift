 //: Playground - noun: a place where people can play
 
 import Foundation
 
 var Player1 = Player(playerNumber : 1) // player on the bottom of the screen
 var Player2 = Player(playerNumber : 2) // player on the top of the screen
 
 class Player {
    // Player class to hold the information of each of the players in the
    // qlobe game. One object is needed for each player.
    
    var playerNumber : Int // unique player to identify each class
    var numberQuestionsCorrect : Int
    var numberQuestionsIncorrect : Int
    var rounds: [Rounds] = [] // holds the rounds, game that round and the score of the round.
    
    init(playerNumber : Int){
        // playerNumber must be a unique number
        self.playerNumber = playerNumber
        numberQuestionsCorrect = 0
        numberQuestionsIncorrect = 0
    }
    
    //// get functions ////
    func getPlayerNumber() -> Int{
        return playerNumber
    }
    
    func getTotalPlayerScore() -> Int{
        var score = 0
        for r in rounds{
            score = score + r.score
        }
        return score
    }
    
    func getQuestionsCorrect() -> Int{
        return numberQuestionsCorrect
    }
    
    func getQuestionsIncorrect() -> Int{
        return numberQuestionsIncorrect
    }
    
    //// class functionality ////
    
    func getAverageScore() -> Int{
        // returns the average points earned for all of the questions
        
        let average = getTotalPlayerScore() / getTotalRounds()
        return average
    }
    func getTotalRounds() -> Int{
        if(rounds.count <= 0){
            return 1
        }
        else{
            return rounds.count
        }
    }
    func getRoundScore(round: Int) -> Int{
        let r = round
        // returns the players score in a certain round
        return rounds[r].score
    }
    func getRoundGame(round: Int) -> String{
        let r = round
        // returns the game that was played in a certain round
        return rounds[r].game
    }
    func gotQuestionWrong(){
        // increments the questions incorrect counter
        numberQuestionsIncorrect++
    }
    
    func gotQuestionRight(){
        // increments the questions correct counter
        numberQuestionsCorrect++
    }
    
    func addScore(round: Int, game: String, score: Int){
        // does the score calculation based on how quickly the player answered the question
        rounds.append(Rounds(round: round, game: game, score: score))
    }
    
    func NewGame(){
        // reset the players fields to start a new game
        
        rounds = []
        numberQuestionsCorrect = 0
        numberQuestionsIncorrect = 0
    }
    
 }
 
 
 
 
 
