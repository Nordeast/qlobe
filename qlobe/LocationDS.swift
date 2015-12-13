//
//  LocationDS.swift
//  qlobe
//
//  This class represents a Location object. Each Location object is constructed using mostly 4 corners of an enclosure.
//  The Top-Left most corner, Bottom-Left most corner, Top-Right most corner, Bottom-Right most corner.
//
//  Created by Aaron Knaack on 12/11/15.
//  Copyright © 2015 qlobe. All rights reserved.
//

import Foundation
import Parse

var locationOptions : [LocationDS] = []

class LocationDS {
    
    var top_lat : Double = 0.0
    var bot_lat : Double = 0.0
    var right_long : Double = 0.0
    var left_long : Double = 0.0
    var generalArea : PFGeoPoint = PFGeoPoint(latitude: 0, longitude: 0)
    var name : String = ""
    
    init(top_lat : Double, bot_lat : Double, right_long : Double, left_long : Double, name : String, generalArea : PFGeoPoint){
        self.top_lat = top_lat
        self.bot_lat = bot_lat
        self.right_long  = right_long
        self.left_long = left_long
        self.name = name
        self.generalArea = generalArea
    }
    
    func top() -> Double{
        return top_lat
    }
    
    func bot() -> Double{
        return bot_lat
    }
    
    func right() -> Double{
        return right_long
    }
    
    func left() -> Double{
        return left_long
    }
    
    func area() -> PFGeoPoint{
        return generalArea
    }
    
    //checks if the location passed is enclosed in this location
    func isEnclosed(point : PFGeoPoint) -> Bool{
        if(point.latitude <= top_lat && point.latitude >= bot_lat &&
            point.longitude >= left_long && point.longitude <= right_long){
                return true
        }else{
            return false
        }
    }
    
    //returns all locations in the global that contain the point
    func getAllContainers(point : PFGeoPoint) -> [LocationDS] {
        
        var allContainers : [LocationDS] = []
        
        for place in locationOptions{
            if(point.latitude <= place.top_lat && point.latitude >= place.bot_lat &&
                point.longitude >= place.left_long && point.longitude <= place.right_long){
                    allContainers.append(place)
            }
        }
        
        return allContainers
    }
    
    
    func getAllContainersNames(point : PFGeoPoint) -> [String]{
        
        var allContainersNames : [String] = []
        
        
        for place in locationOptions{
            if(point.latitude <= place.top_lat && point.latitude >= place.bot_lat &&
                point.longitude >= place.left_long && point.longitude <= place.right_long){
                    allContainersNames.append(place.name)
            }
        }
        
        return allContainersNames
        
    }
    
    func generateRelatedTrivia(){
        print("generatRelatedTrivia in LocationDS Entered0")
        for trivia in triviaQuestions{
            print("generatRelatedTrivia in LocationDS Entered1")
            if(trivia.getLocation().latitude <= top_lat && trivia.getLocation().latitude >= bot_lat &&
                trivia.getLocation().longitude >= left_long && trivia.getLocation().longitude <= right_long){
                    locationTrivia.append(trivia)
            }
        }
    }
}