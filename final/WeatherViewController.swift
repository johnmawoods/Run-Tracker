//
//  WeatherViewController.swift
//  final
//
//  Created by John Woods on 11/1/21.
//

import UIKit

class WeatherViewController: UIViewController {
    
    @IBOutlet weak var cityName: UILabel!
    @IBOutlet weak var currentTemp: UILabel!
    @IBOutlet weak var highTemp: UILabel!
    @IBOutlet weak var lowTemp: UILabel!
    
    let key:String = "66b4de5ddafe29bc0cd42c27b0070bf4"
    let base:String = "https://api.openweathermap.org/data/2.5"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        callAsync()
    }
    
    func callAsync() {
        
        DispatchQueue.main.async(execute: {
            self.getJsonData()
        })
    }
    
    func getJsonData() {
        
        /* make sure to add the user name to change your user name once you have registered in
           http://api.geonames.org/login
        */
        
        let urlAsString = base+"/weather?q=tempe&units=imperial&APPID="+key
        //let urlAsString = "http://api.geonames.org/earthquakesJSON?formatted=true&north=44.1&south=-9.9&east=-22.4&west=55.2&username=johnmawoods"
        
        let url = URL(string: urlAsString)!
        let urlSession = URLSession.shared
        
        
        let jsonQuery = urlSession.dataTask(with: url, completionHandler: { data, response, error -> Void in
            if (error != nil) {
                print(error!.localizedDescription)
            }
            var err: NSError?
            
            var jsonResult = (try! JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers)) as! NSDictionary
            if (err != nil) {
                print("JSON Error \(err!.localizedDescription)")
            }
            
            print(jsonResult)
          
            let temps = jsonResult["main"] as? [String: AnyObject]
            
            print(temps)
           
            let minTemp:Int = (temps?["temp_min"] as? NSNumber)!.intValue
            let maxTemp:Int = (temps?["temp_max"] as? NSNumber)!.intValue
            let curTemp:Int = (temps?["temp"] as? NSNumber)!.intValue
            
            DispatchQueue.main.async
            {
                self.currentTemp.text = String(curTemp)
                self.highTemp.text = String(maxTemp)
                self.lowTemp.text = String(minTemp)
                //self.conditions.text = genConditions
            }
          
        })
        
        jsonQuery.resume()
        
    }

    

   

}
