//
//  settingsDS.swift
//  qlobe
//
//  Created by Aaron Knaack on 12/6/15.
//  Copyright © 2015 qlobe. All rights reserved.
//

import Foundation
import Parse

var settings = SettingsDS()

class SettingsDS {
    
    var gamesEnabled : [String]
    var volume : Float
    var volumePre : Float
    
    init(){
        
        self.gamesEnabled = ["Trivia","TapRace","SimonSays"]
        self.volume = 1.0
        self.volumePre = 1.0
    }
    
    func setVolume(vol : Float){
        volume = vol
    }
    
    func setVolumePre(vol : Float){
        volumePre = vol
    }
    
    func setGame(game : String){
        if(!gamesEnabled.contains(game)){
            gamesEnabled.append(game)
        }
    }
    
    func getVolume() -> Float{
        return volume
    }
    
    func getVolumePre() -> Float{
        return volumePre
    }
    
    func isMute() -> Bool{
        return (volume < 0.001)
    }
    
    func getGamesSetting() -> [String] {
        return gamesEnabled
    }
    
    func removeGame(game : String){
        if(gamesEnabled.contains(game)){
            for (index, value) in gamesEnabled.enumerate(){
                if value == game{
                    gamesEnabled.removeAtIndex(index)
                }
            }
        }
    }
    
    
}
