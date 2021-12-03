//
//  ViewController.swift
//  final
//
//  Created by John Woods on 10/16/21.
//

import UIKit

class ViewController: UIViewController {
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if(segue.identifier == "toWeather")
        {
            let des = segue.destination as! WeatherViewController
        }
        if(segue.identifier == "toRun")
        {
            let des = segue.destination as! RunViewController
        }
        
        if(segue.identifier == "toTable")
        {
            let des = segue.destination as! TableViewController
        }
        
    }
    
    @IBAction func goToWeather(_ sender: Any) {
        performSegue(withIdentifier: "toWeather", sender: self)
    }
    
    @IBAction func goToRun(_ sender: Any) {
        performSegue(withIdentifier: "toRun", sender: self)
    }
    
    @IBAction func goToTable(_ sender: Any) {
        performSegue(withIdentifier: "toTable", sender: self)
    }
    
    
    

}

