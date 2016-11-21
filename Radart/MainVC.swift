//
//  MainVC.swift
//  Radart
//
//  Created by Brian Bresen on 11/18/16.
//  Copyright © 2016 BeeHive Productions. All rights reserved.
//

import UIKit
import CoreData

class MainVC: UIViewController {

    @IBOutlet weak var sunriseLbl: UILabel!
    @IBOutlet weak var sunsetLbl: UILabel!
    @IBOutlet weak var windLbl: UILabel!
    @IBOutlet weak var windImg: UIImageView!
    @IBOutlet weak var currentImg: UIImageView!
    @IBOutlet weak var currentLbl: UILabel!
    @IBOutlet weak var tempLbl: UILabel!
    @IBOutlet weak var locationLbl: UILabel!
    
    var weather: Weather!
    
    override func viewDidLoad() {
        super.viewDidLoad()

//Load from CoreData
        let app = UIApplication.shared.delegate as! AppDelegate
        let context = app.persistentContainer.viewContext
        weather = Weather(context: context)
        
        fetchAndSetResults()
        let currentTime = Date()
        print("current timestamp: \(weather.currentTimestamp)")
        print("current time  is : \(currentTime.timeIntervalSince1970)")
        if (weather.currentTimestamp == 0) || ((currentTime.timeIntervalSince1970  - weather.currentTimestamp) > 600) {
        
            print("Retriving Data... i hope.")
            weather.downloadWeatherData { () -> () in
                //this will be called after download is done
                self.storeData()
                self.updateUI()
            }
        } else {
            self.updateUI()
        }
    }

    func fetchAndSetResults() {
        let app = UIApplication.shared.delegate as! AppDelegate
        let context = app.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Weather")
        do {
            let results = try context.fetch(fetchRequest)
            self.weather = results[0] as! Weather
        } catch let err as NSError {
            print(err.debugDescription)
        }
    }
    
    func storeData() {
        let app = UIApplication.shared.delegate as! AppDelegate
        let context = app.persistentContainer.viewContext
        
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                print("Could not save weather!")
            }
        }
    }

    func updateUI() {
        print("updateUI is running!!!!")
        print("current Temp is: \(weather.currentTemp)")
        locationLbl.text = weather.locationName
        
        tempLbl.text = String(Int(weather.currentTemp))

        sunriseLbl.text = weather.getSunrise()
        sunsetLbl.text = weather.getSunset()

        currentLbl.text = weather.currentDesc
    print(weather.currentIcon!)
        currentImg.image = UIImage(named: weather.currentIcon!)

        
        windLbl.text = String(Int(weather.windSpeed))
        //Need to set wind icon to rotate
//        windImg.image?.imageOrientation = 0
        
        print("updateUI is done running!!!!")
    }
}

