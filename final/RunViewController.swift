//
//  RunViewController.swift
//  final
//
//  Created by John Woods on 11/11/21.
//

import UIKit
import MapKit
import CoreLocation


class RunViewController: UIViewController,  CLLocationManagerDelegate, UIImagePickerControllerDelegate, MKMapViewDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var paceLabel: UILabel!
    
    @IBOutlet weak var stopBtn: UIButton!
    @IBOutlet weak var startBtn: UIButton!
    
    let managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var m:Model?
    
    let picker = UIImagePickerController()
    var picture = NSData()
    var seconds = 0
    var timer: Timer?
    var distance = Measurement(value: 0, unit: UnitLength.meters)
    var locationList: [CLLocation] = []
    
    var manager:CLLocationManager!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        m = Model(context: managedObjectContext)
        
        picker.delegate = self
        mapView.delegate = self
        
        stopBtn.isHidden = true
        
        manager = CLLocationManager()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.distanceFilter = 10
        manager.activityType = .fitness
        requestLocationAccess()
        
        
        
        // Do any additional setup after loading the view.
    }
    
    func requestLocationAccess() {
        let status = CLLocationManager.authorizationStatus()
        
        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            return
            
        case .denied, .restricted:
            print("location access denied")
            
        default:
            manager.requestWhenInUseAuthorization()
        }
    }
    
    
    
    @IBAction func photoClicked(_ sender: Any) {
        
        let alertController = UIAlertController(title: "Photo", message: "", preferredStyle: .actionSheet)
        alertController.addAction(UIAlertAction(title: "Camera", style: .default) { [self] _ in
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                picker.allowsEditing = false
                picker.sourceType = UIImagePickerController.SourceType.camera
                picker.cameraCaptureMode = .photo
                picker.modalPresentationStyle = .fullScreen
                present(picker,animated: true,completion: nil)
            } else {
                print("No camera")
            }
        })
        alertController.addAction(UIAlertAction(title: "Camera Roll", style: .default) { [self] _ in
            picker.allowsEditing = false
            picker.sourceType = .photoLibrary
            picker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
            picker.modalPresentationStyle = .popover
            present(picker, animated: true, completion: nil)
        })
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(alertController, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]){
        
        picker .dismiss(animated: true, completion: nil)
        
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        {
            picture = image.pngData()! as NSData
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    
    
    
    
    @IBAction func startClicked(_ sender: Any) {
        // hide the start button and display the stop button
        startBtn.isHidden = true
        stopBtn.isHidden = false
        
        // set everything to 0 for fresh start
        seconds = 0
        distance = Measurement(value: 0, unit: UnitLength.meters)
        locationList.removeAll()
        
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true){ _ in
            // increment seconds and update the display
            self.seconds += 1
            self.updateView()
        }
        
        manager.startUpdatingLocation()
        
    }
    
    
    

    @IBAction func stopClicked(_ sender: Any) {
        let alertController = UIAlertController(title: "End run?", message: "", preferredStyle: .actionSheet)
        alertController.addAction(UIAlertAction(title: "Save", style: .default) { _ in
            self.endRun()
            self.saveRun()
            self.resetStats()
        })
        alertController.addAction(UIAlertAction(title: "Discard", style: .destructive) { _ in
            self.endRun()
            self.resetStats()
        })
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(alertController, animated: true)
        
    }
    
    func saveRun()
    {
        let theTime = UnitFormatter.niceTime(duration: seconds)
        let theDistance = UnitFormatter.niceDistance(length: distance)
        let theDate = UnitFormatter.niceDate()
        print(theDate)
        print(theDistance)
        print(theTime)
        self.m?.SaveContext(distance: theDistance, duration: theTime, picture: picture, timeStamp: theDate)
    }
    
    func endRun()
    {
        startBtn.isHidden = false
        stopBtn.isHidden = true
        
        manager.stopUpdatingLocation()
        timer?.invalidate()
    }
    
    func resetStats()
    {
        seconds = 0
        distance = Measurement(value: 0, unit: UnitLength.meters)
        locationList.removeAll()
        let overlays = mapView.overlays
        mapView.removeOverlays(overlays)
        let newPicture = NSData()
        picture = newPicture
    }
   
    
    func updateView() {
        let time = UnitFormatter.niceTime(duration: seconds)
        let pace = UnitFormatter.nicePace(length: distance, seconds: seconds)
        let distanceString = UnitFormatter.niceDistance(length: distance)
        
        timeLabel.text = time
        paceLabel.text = pace
        distanceLabel.text = distanceString
        
    }
    
      
      func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        for newLocation in locations {
          let howRecent = newLocation.timestamp.timeIntervalSinceNow
          guard newLocation.horizontalAccuracy < 20 && abs(howRecent) < 10 else { continue }
          
          if let lastLocation = locationList.last {
            let delta = newLocation.distance(from: lastLocation)
            distance = distance + Measurement(value: delta, unit: UnitLength.meters)
            let coordinates = [lastLocation.coordinate, newLocation.coordinate]
            let polyline = MKPolyline(coordinates: coordinates, count: coordinates.count)
            mapView.addOverlay(polyline)
            let region = MKCoordinateRegion(center: newLocation.coordinate, latitudinalMeters: 500, longitudinalMeters: 500)
            mapView.setRegion(region, animated: true)
          }
          
          locationList.append(newLocation)
        }
      }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if let routePolyline = overlay as? MKPolyline {
            let renderer = MKPolylineRenderer(polyline: routePolyline)
            renderer.strokeColor = UIColor.blue
            renderer.lineWidth = 7
            return renderer
        }
            return MKOverlayRenderer()
    }
    
    

//end brace
}



