//
//  SettingsTVC.swift
//  qlobe
//
//  Created by Aaron Knaack on 12/7/15.
//  Copyright © 2015 qlobe. All rights reserved.
//

import Foundation
import UIKit
import Parse

class SettingsTVC: UITableViewController{
    
    @IBOutlet weak var triviaSetting: UISwitch!
    @IBOutlet weak var tapRaceSetting: UISwitch!
    @IBOutlet weak var simonSaysSetting: UISwitch!
    @IBOutlet weak var volumeSetting: UISlider!
    @IBOutlet weak var back: UIButton!
    
    @IBAction func triviaEnabler(sender: AnyObject) {
        if(!simonSaysSetting.on && !tapRaceSetting.on){
            triviaSetting.setOn(true, animated: true)
        }
    }
    
    @IBAction func tapRaceEnabler(sender: AnyObject) {
        if(!triviaSetting.on && !simonSaysSetting.on){
            tapRaceSetting.setOn(true, animated: true)
        }
    }
    
    @IBAction func simonSaysEnabler(sender: AnyObject) {
        if(!triviaSetting.on && !tapRaceSetting.on){
            simonSaysSetting.setOn(true, animated: true)
        }
    }
    
    @IBAction func changeVolume(sender: AnyObject) {
        settings.setVolume(volumeSetting.value)
        menuAudio?.volume = volumeSetting.value
    }
    
    @IBAction func backButton(sender: AnyObject) {
        
        //update settings to match views
        if(triviaSetting.on){
            settings.setGame("Trivia")
        }else{
            settings.removeGame("Trivia")
        }
        if(simonSaysSetting.on){
            settings.setGame("SimonSays")
        }else{
            settings.removeGame("SimonSays")
        }
        if(tapRaceSetting.on){
            settings.setGame("TapRace")
        }else{
            settings.removeGame("TapRace")
        }
        
        settings.setVolume(volumeSetting.value)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //update views to match settings
        if(settings.getGamesSetting().contains("Trivia")){
            triviaSetting.setOn(true, animated: false)
        }else{
            triviaSetting.setOn(false, animated: false)
        }
        if(settings.getGamesSetting().contains("TapRace")){
            tapRaceSetting.setOn(true, animated: false)
        }else{
            tapRaceSetting.setOn(false, animated: false)
        }
        if(settings.getGamesSetting().contains("SimonSays")){
            simonSaysSetting.setOn(true, animated: false)
        }else{
            simonSaysSetting.setOn(false, animated: false)
        }
        
        volumeSetting.setValue(settings.getVolumePre(), animated: false)
        
        //design()
    }
    
    func design(){
        //tableView.backgroundColor = UIColor(netHex:0x2c3e50)
        
    }
    
}
