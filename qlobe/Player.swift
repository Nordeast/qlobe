 //: Playground - noun: a place where people can play
 
 import Foundation
 import Parse
 
 var Player1 = Player(playerNumber : 1) // player on the bottom of the screen
 var Player2 = Player(playerNumber : 2) // player on the top of the screen
 
 class Player {
    // Player class to hold the information of each of the players in the
    // qlobe game. One object is needed for each player.
    
    var playerNumber : Int // unique player to identify each class
    var rounds: [Rounds] = [] // holds the rounds, game that round and the score of the round.
    var location = PFGeoPoint(latitude: 0,longitude: 0) // holds location coordinates of players 0,0 is default, until activated
    
    init(playerNumber : Int){
        // playerNumber must be a unique number
        self.playerNumber = playerNumber
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
    
    //// class functionality ////
    
    func getAverageScore() -> Int{
        // returns the average points earned for all of the questions
        if(getTotalRounds() == 0){// avoid devide by zero error
            return 0
        }else{
            let average = getTotalPlayerScore() / getTotalRounds()
            return average

        }
    }
    func getTotalRounds() -> Int{
        // returns the total number of rounds the match was
            return rounds.count
        
    }
    func getRoundScore(round: Int) -> Int{
        let r = round
        // returns the players score in a certain round
//        if(r == 0){ // accounts for the case no rounds were played
//            return 0
//        }
        return rounds[r].score
    }
    func getRoundGame(round: Int) -> String{
        let r = round
        // returns the game that was played in a certain round
//        if(r == 0){ // accounts for the case no rounds were played
//            return ""
//        }
        return rounds[r].game
    }
    
    func addScore(round: Int, game: String, score: Int){
        // does the score calculation based on how quickly the player answered the question
        rounds.append(Rounds(round: round, game: game, score: score))
    }
    
    func NewGame(){
        // reset the players fields to start a new game
        
        rounds = []

    }
    
    func setLocation(longlat : PFGeoPoint){
              location = longlat
        }

       func getLocation() -> PFGeoPoint{
               return location
        }
 }
    
 
 
 
 
 
 
