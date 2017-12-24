//
//  ViewController.swift
//  TripKeeper
//
//  Created by PYC on 12/21/17.
//  Copyright © 2017 PYC. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    let googleDistanceMatrixAPI = "AIzaSyCTW7N5eDPF5Q_ZA6jouU0pqk_D7tk-b8I"
    @IBOutlet weak var menuBtn: UIBarButtonItem!
    @IBOutlet weak var originTextField: MVPlaceSearchTextField!
    @IBOutlet weak var destinationTextField: MVPlaceSearchTextField!
    var destinations = [String]()
    var trips = [Trip]()
    override func viewDidLoad() {
        super.viewDidLoad()
        menuBtn.target = revealViewController()
        menuBtn.action = #selector(SWRevealViewController.revealToggle(_:))
        view.addGestureRecognizer(revealViewController().panGestureRecognizer())
        
    }
    
    @IBAction func addTrips(_ sender: UIButton) {
        if (destinationTextField.text! == "" && destinations.isEmpty) || originTextField.text! == ""{
            popAlert(message: "Please make sure to enter origin and destination")
        }else{
            performSelector(inBackground: #selector(getMilesFromGoogleAPI), with: nil)
        }
    }
    @IBAction func addDestinations(_ sender: UIButton) {
        if destinationTextField.text! != ""{
            destinations.append(destinationTextField.text!)
            destinationTextField.text = ""
        }else{
            popAlert(message: "Please enter the destination")
        }
    }
    func popAlert(title: String = "Alert", message: String){
        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        ac.addAction(action)
        self.present(ac,animated: true, completion: nil)
    }
    @objc func getMilesFromGoogleAPI(){
        if destinationTextField.text! != ""{
            destinations.append(destinationTextField.text!)
        }
        destinations.insert(originTextField.text!, at:0)
        
        for i in 0 ..< (destinations.count - 1) {
            let url: NSString = "https://maps.googleapis.com/maps/api/distancematrix/json?units=imperial&origins=\(destinations[i])&destinations=\(destinations[i+1])&key=\(googleDistanceMatrixAPI)" as NSString
            let urlStr : NSString = url.addingPercentEscapes(using: String.Encoding.utf8.rawValue)! as NSString
            
            if let searchURL = NSURL(string: urlStr as String){
                //print(searchURL)
                if let data = try? Data(contentsOf: searchURL as URL){
                    let jsonTripMileages = JSON(data: data)
                    //let jsonTripMileageArray = jsonTripMileages.arrayValue
                    
                    print(jsonTripMileages)
                    DispatchQueue.main.async {[unowned self] in
                        for row in jsonTripMileages["rows"].arrayValue{
                            for element in row["elements"].arrayValue{
//                                print(element["distance"]["text"])
//                                print(element["duration"]["text"])
                            }
                        }
                        
                    }
                    
                }
            }
            
        }
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

