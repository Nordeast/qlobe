//
//  Rounds.swift
//  qlobe
//
//  Created by allen rand on 12/9/15.
//  Copyright © 2015 qlobe. All rights reserved.
//

import Foundation
// this is used to store the game that was played that round and the score the player recieved for that round

struct Rounds{
    
    var round = 0
    var game = ""
    var score = 0
    
    init(round: Int, game: String, score: Int){
        self.round = round
        self.game = game
        self.score = score
    }
}