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
    
    
    // MARK: outlets
    @IBOutlet weak var triviaSetting: UISwitch!
    @IBOutlet weak var tapRaceSetting: UISwitch!
    @IBOutlet weak var simonSaysSetting: UISwitch!
    @IBOutlet weak var volumeSetting: UISlider!
    @IBOutlet weak var back: UIButton!
    @IBOutlet weak var TriviaLabel: UILabel!
    @IBOutlet weak var TapRaceLabel: UILabel!
    @IBOutlet weak var SimonSaysLabel: UILabel!
    @IBOutlet weak var NumberOfRoundsLabel: UILabel!
    @IBOutlet weak var VolumeLabel: UILabel!
    @IBOutlet weak var NumberOfRoundsSlider: UISlider!
    @IBOutlet weak var ShowNumberOfRoundsLabel: UILabel!
    @IBOutlet weak var VolumeCell: UITableViewCell!
    @IBOutlet weak var NumberOfRoundsCell: UITableViewCell!
    @IBOutlet weak var SimonSaysCell: UITableViewCell!
    @IBOutlet weak var TapRaceCell: UITableViewCell!
    @IBOutlet weak var TriviaCell: UITableViewCell!
    
    @IBOutlet weak var SettingsTitleLabel: UILabel!
    
    
    // MARK: actions
    @IBAction func NumberOfRoundsSlider(sender: AnyObject) {
        numberOfRoundsPerMatch =  Int(round(NumberOfRoundsSlider.value)) + 1
        ShowNumberOfRoundsLabel.text = "\(Int(round(NumberOfRoundsSlider.value)))"
    }
    
    
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
        
        style()
    }
    

    
    func style(){
        
        // style the settings page
        
        tableView.backgroundColor = UIColor(netHex:0x2c3e50)
        
        // set the background color
        view.backgroundColor = UIColor(netHex:0x2c3e50)
        
        triviaSetting.backgroundColor = UIColor(netHex:0x2c3e50)
        tapRaceSetting.backgroundColor = UIColor(netHex:0x2c3e50)
        simonSaysSetting.backgroundColor = UIColor(netHex:0x2c3e50)
        volumeSetting.backgroundColor = UIColor(netHex:0x2c3e50)
        NumberOfRoundsSlider.backgroundColor = UIColor(netHex:0x2c3e50)
        
        TriviaLabel.font = UIFont(name: "Kankin", size: 20)
        TriviaLabel.textColor = UIColor(netHex: 0xeeeeee)
        TapRaceLabel.font = UIFont(name: "Kankin", size: 20)
        TapRaceLabel.textColor = UIColor(netHex: 0xeeeeee)
        SimonSaysLabel.font = UIFont(name: "Kankin", size: 20)
        SimonSaysLabel.textColor = UIColor(netHex: 0xeeeeee)
        NumberOfRoundsLabel.font = UIFont(name: "Kankin", size: 20)
        NumberOfRoundsLabel.textColor = UIColor(netHex: 0xeeeeee)
        VolumeLabel.font = UIFont(name: "Kankin", size: 20)
        VolumeLabel.textColor = UIColor(netHex:0xeeeeee)
        ShowNumberOfRoundsLabel.font = UIFont(name: "Kankin", size: 20)
        ShowNumberOfRoundsLabel.textColor = UIColor(netHex: 0xeeeeee)
        ShowNumberOfRoundsLabel.textAlignment = NSTextAlignment.Center
        
        
        SettingsTitleLabel.font = UIFont(name: "Kankin", size: 30)
        SettingsTitleLabel.textColor = UIColor(netHex: 0xf1c40f)
        SettingsTitleLabel.textAlignment = NSTextAlignment.Center
        
        
        back.titleLabel!.font = UIFont(name: "Kankin", size: 25)!
        back.setTitleColor(UIColor(netHex: 0xeeeeee), forState: UIControlState.Normal)
        back.titleLabel!.text = "Back"
        
        
        VolumeCell.backgroundColor = UIColor(netHex:0x2c3e50)
        NumberOfRoundsCell.backgroundColor = UIColor(netHex:0x2c3e50)
        SimonSaysCell.backgroundColor = UIColor(netHex:0x2c3e50)
        TapRaceCell.backgroundColor = UIColor(netHex:0x2c3e50)
        TriviaCell.backgroundColor = UIColor(netHex:0x2c3e50)
        
    }
    
    // this will style the tableview section text
    override func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        
        let header: UITableViewHeaderFooterView = view as! UITableViewHeaderFooterView //recast your view as a UITableViewHeaderFooterView
        
        header.contentView.backgroundColor = UIColor(netHex:0x2c3e50) //make the background color light blue
        
        header.textLabel!.textColor = UIColor(netHex:0xf1c40f) //make the text white
        
        header.textLabel?.font = UIFont(name: "Kankin", size: 25)
    }
}
