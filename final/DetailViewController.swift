//
//  DetailViewController.swift
//  final
//
//  Created by John Woods on 11/14/21.
//

import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    var dateVC = String()
    var imageVC = NSData()
    var distanceVC = String()
    var timeVC = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dateLabel.text = dateVC
        distanceLabel.text = distanceVC
        timeLabel.text = timeVC
        image.image = UIImage(data: imageVC as Data)
    }
    


}
