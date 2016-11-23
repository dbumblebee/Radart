//
//  Weather+CoreDataClass.swift
//  
//
//  Created by Brian Bresen on 11/18/16.
//
//

import Foundation
import CoreData
import Alamofire

public class Weather: NSManagedObject {

    func getSunset() -> String {
        return timeToTimeString(timeInterval: self.sunset)
    }
    
    func getSunrise() -> String {
        return timeToTimeString(timeInterval: self.sunrise)
    }
    
    func timeToTimeString(timeInterval: Double) -> String {
        let date = Date(timeIntervalSince1970: timeInterval)
        
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateStyle = .none
        dateFormatter.timeStyle = .short
        dateFormatter.locale = Locale(identifier: "en_US")
        return dateFormatter.string(from: date)
    }
    
    func getDate() -> String {
            return timeToDateString(timeInterval: self.currentTimestamp)
    }
    
    func timeToDateString(timeInterval: Double) -> String {

        let date = Date(timeIntervalSince1970: timeInterval)
        let dateFormatter = DateFormatter()
        
        dateFormatter.locale = Locale(identifier: "en_US")
        dateFormatter.setLocalizedDateFormatFromTemplate("EEEEMMMMd")
        
        return dateFormatter.string(from: date)
    }
    
    func downloadWeatherData(completed: @escaping DownloadComplete) {
        let urlStr = "\(URL_BASE)\(URL_LOCID)\(URL_PARAMS)"
        let url = URL(string: urlStr)!
    print("sending get request!")
        Alamofire.request(url).responseJSON { response in
            if let dict = response.result.value as? Dictionary<String, AnyObject> {
                if let weatherArray = dict["weather"] as? [Dictionary<String, AnyObject>] {
                    if let desc = weatherArray[0]["description"] as? String {
                        self.currentDesc = desc
                    }
                    if let icon = weatherArray[0]["icon"] as? String {
                        print("icon stored as: \(icon)")
                        self.currentIcon = icon
                    }
                }
                if let main = dict["main"] as? Dictionary<String, AnyObject> {
                    if let temp = main["temp"] as? Double {
                        self.currentTemp = round(temp)
                    }
                }
                if let windDict = dict["wind"] as? Dictionary<String, AnyObject> {
                    if let speed = windDict["speed"] as? Double {
                        self.windSpeed = speed
                    }
                    if let dir = windDict["deg"] as? Double {
                        self.windDirection = dir
                    }
                }
                if let sysDict = dict["sys"] as? Dictionary<String, AnyObject> {
                    if let sunrise = sysDict["sunrise"] as? Double {
                        self.sunrise = sunrise
                    }
                    if let sunset = sysDict["sunset"] as? Double {
                        self.sunset = sunset
                    }
                }
                if let myId = dict["id"] as? Double {
                    self.locationId = String(myId)
                }
                if let name = dict["name"] as? String {
                    self.locationName = name
                }

                let currentTime = Date()
                self.currentTimestamp = currentTime.timeIntervalSince1970
                
                completed()
            }
        }
    }
}
