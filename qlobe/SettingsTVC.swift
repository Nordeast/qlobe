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
    
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var locationSetting: UISwitch!
    
    @IBOutlet weak var locationCell: UITableViewCell!
    
    @IBOutlet weak var SettingsTitleLabel: UILabel!
    
    
    // MARK: actions
    @IBAction func NumberOfRoundsSlider(sender: AnyObject) {
        numberOfRoundsPerMatch =  Int(round(NumberOfRoundsSlider.value))
        ShowNumberOfRoundsLabel.text = "\(numberOfRoundsPerMatch)"
    }
    
    
    @IBAction func triviaEnabler(sender: AnyObject) {
        if(!simonSaysSetting.on && !tapRaceSetting.on){
            triviaSetting.setOn(true, animated: true)
        }
    }
    
    
    @IBAction func locationEnabler(sender: AnyObject) {
        
        if(locationSetting.on){
            
            //this will check user for location permission, and retrieve their long, lat position. (must have <key>NSLocationWhenInUseUsageDescription</key> in info.plist, with <String> pair)
            
            PFGeoPoint.geoPointForCurrentLocationInBackground {
                (geoPoint: PFGeoPoint?, error: NSError?) -> Void in
                if error == nil {
                    settings.setLocationSetting(true)
                    Player1.setLocation(geoPoint!)
                    Player2.setLocation(geoPoint!)
                    self.generateLocationTrivia()
                    print(geoPoint) //for testing purposes
                }else{
                    print("There was an error in retrieving the position. Could be because GPS is turned off, bad connection, or for debugging purposes the simulator does not have a location specified.")
                    settings.setLocationSetting(false)
                    self.locationSetting.setOn(false, animated: true)   //if there is an error in location, turn location setting off auto.
                }
            }
        }else{
            settings.setLocationSetting(false)
        }
        
    }
    
    func generateLocationTrivia(){
        //temp long and lat paramaters to test location setting
        //this has been designed to look for questions about Computer Science if the user is in the CS Building
        //note the labels here are contradictory because left long would imply that longitude goes up/down. This is
        //just used by the way google maps orientated its self to me
        let leftLong = -89.407391
        let rightLong = -89.405714
        let topLat = 43.072172
        let botLat = 43.071041
        
        if(Player1.getLocation().latitude >= botLat && Player1.getLocation().latitude <= topLat &&
            Player1.getLocation().longitude >= leftLong && Player1.getLocation().longitude <= rightLong){
                
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
        
        updateViewsFromSettings()
        
        style()
    }
    
    func updateViewsFromSettings(){
        
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
        
        // Volume
        volumeSetting.setValue(settings.getVolume(), animated: false)
        
        //Nuber of Rounds per match
        NumberOfRoundsSlider.setValue(Float (numberOfRoundsPerMatch), animated: false)
        ShowNumberOfRoundsLabel.text = "\(numberOfRoundsPerMatch)"
        
        //location off by default, otherwise match settings
        if(settings.getLocationSetting() == false){
            locationSetting.setOn(false, animated: false)
        }else{
            locationSetting.setOn(true, animated: false)
        }
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
        locationLabel.font = UIFont(name: "Kankin", size:20)
        locationLabel.textColor = UIColor(netHex: 0xeeeeee)
        
        
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
        locationCell.backgroundColor = UIColor(netHex:0x2c3e50)
        
    }
    
    // this will style the tableview section text
    override func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        
        let header: UITableViewHeaderFooterView = view as! UITableViewHeaderFooterView //recast your view as a UITableViewHeaderFooterView
        
        header.contentView.backgroundColor = UIColor(netHex:0x2c3e50) //make the background color light blue
        
        header.textLabel!.textColor = UIColor(netHex:0xf1c40f) //make the text white
        
        header.textLabel?.font = UIFont(name: "Kankin", size: 25)
    }
    
    // this will style the tableview cell background
    override func tableView(tableView: UITableView,
        willDisplayCell cell: UITableViewCell,
        forRowAtIndexPath indexPath: NSIndexPath){
            
            //this will style the background color of the cell when it is pressed to be transparent
            let bgColorView = UIView()
            bgColorView.backgroundColor = UIColor(colorLiteralRed: 0, green: 0, blue: 0, alpha: 0)
            cell.selectedBackgroundView = bgColorView
            
    }
}
