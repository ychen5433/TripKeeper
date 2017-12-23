//
//  ViewController.swift
//  TripKeeper
//
//  Created by PYC on 12/21/17.
//  Copyright © 2017 PYC. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var menuBtn: UIBarButtonItem!
    @IBOutlet weak var originTextField: MVPlaceSearchTextField!
    @IBOutlet weak var destinationTextField: MVPlaceSearchTextField!
    var destinations = [String]()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        menuBtn.target = revealViewController()
        menuBtn.action = #selector(SWRevealViewController.revealToggle(_:))
        
        view.addGestureRecognizer(revealViewController().panGestureRecognizer())
        googleDistanceMatrixAPICall()
        
    }
    func googleDistanceMatrixAPICall(){
        let url: NSString = "https://maps.googleapis.com/maps/api/distancematrix/json?units=imperial&origins=charlotte,nc&destinations=New York, NY&key=AIzaSyCTW7N5eDPF5Q_ZA6jouU0pqk_D7tk-b8I" as NSString
        let urlStr : NSString = url.addingPercentEscapes(using: String.Encoding.utf8.rawValue)! as NSString
        if let searchURL = NSURL(string: urlStr as String){
            print(searchURL)
            if let data = try? Data(contentsOf: searchURL as URL){
                let json = JSON(data: data)
                
                print(json)
                for row in json["rows"].arrayValue{
                    for element in row["elements"].arrayValue{
                        print(element["distance"]["text"])
                        print(element["duration"]["text"])
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

