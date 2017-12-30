//
//  ViewController.swift
//  TripKeeper
//
//  Created by PYC on 12/21/17.
//  Copyright © 2017 PYC. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITextFieldDelegate {
    let googleDistanceMatrixAPI = "AIzaSyCTW7N5eDPF5Q_ZA6jouU0pqk_D7tk-b8I"
    @IBOutlet weak var menuBtn: UIBarButtonItem!
    @IBOutlet weak var originTextField: MVPlaceSearchTextField!
    @IBOutlet weak var destinationTextField: MVPlaceSearchTextField!
    var originString = ""
    var destinations = [String]()
    var trips = [Trip]()
    var selectedDate = Date()
    
    @IBAction func fetchCoreData(_ sender: UIButton) {
        
        let request = Trip.createFetchRequest()
        let sort = NSSortDescriptor(key: "date", ascending: false)
        request.sortDescriptors = [sort]
        
        do {
            trips = (try appDelegate?.persistentContainer.viewContext.fetch(request))!
            print("Got \(trips.count) trips")
            for trip in trips{
                print(trip.origin)
                print(trip.destination)
                print("done one trip")
            }
//            tableView.reloadData()
        } catch {
            print("Fetch failed")
        }
    }
    @IBOutlet weak var noteTextView: UITextView!
    @IBOutlet weak var dateTextField: UITextField!
    let appDelegate = UIApplication.shared.delegate as? AppDelegate
    let dateFormatter = DateFormatter()
    
//    var managedObjectContext: NSManagedObjectContext? = nil
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        menuBtn.target = revealViewController()
        menuBtn.action = #selector(SWRevealViewController.revealToggle(_:))
        view.addGestureRecognizer(revealViewController().panGestureRecognizer())
        
        dateFormatter.dateStyle = DateFormatter.Style.medium
        dateTextField.text = dateFormatter.string(from: Date())
        pickDate(dateTextField)
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    @IBAction func addTrips(_ sender: UIButton) {
        if (destinationTextField.text! == "" && destinations.isEmpty) || originTextField.text! == ""{
            popAlert(message: "Please make sure to enter origin and destination")
        }else{
            originString = originTextField.text!
//            if self.destinationTextField.text! != ""{
//                self.destinations.append(self.destinationTextField.text!)
//            }
            destinations.append(destinationTextField.text!)
            destinations.insert(self.originString, at:0)
            performSelector(inBackground: #selector(getMilesFromGoogleAPI), with: nil)
//            originTextField.text! = ""
//            destinationTextField.text! = ""
//            destinations.removeAll()
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
    
    @IBAction func pickDate(_ sender: UITextField) {
        let datePickerView = UIDatePicker()
        datePickerView.datePickerMode = UIDatePickerMode.date
        sender.inputView = datePickerView
        datePickerView.addTarget(self, action: #selector(datePickerValueChanged), for: .valueChanged)
    }
    @objc func datePickerValueChanged(sender: UIDatePicker){
        selectedDate = sender.date
        dateFormatter.dateStyle = DateFormatter.Style.medium
        dateTextField.text = dateFormatter.string(from: selectedDate)
    }
    
    func popAlert(title: String = "Alert", message: String){
        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        ac.addAction(action)
        self.present(ac,animated: true, completion: nil)
    }
    
    @objc func getMilesFromGoogleAPI(){
        for i in 0 ..< (destinations.count - 1) {
            let url: NSString = "https://maps.googleapis.com/maps/api/distancematrix/json?units=imperial&origins=\(destinations[i])&destinations=\(destinations[i+1])&key=\(googleDistanceMatrixAPI)" as NSString
            let urlStr : NSString = url.addingPercentEscapes(using: String.Encoding.utf8.rawValue)! as NSString
            let managedContext = appDelegate?.persistentContainer.viewContext
            let trip = Trip(context: managedContext!)
            
            if let searchURL = NSURL(string: urlStr as String){
                if let data = try? Data(contentsOf: searchURL as URL){
                    let jsonGoogleData = JSON(data: data)
                    print(jsonGoogleData)
                    DispatchQueue.main.async {[unowned self] in
                        for row in jsonGoogleData["rows"].arrayValue{
                            for element in row["elements"].arrayValue{
                                if element["status"].stringValue == "OK"{
//                                print(element["distance"]["text"].doubleValue)
//                                print(element["duration"]["text"])
                                    trip.origin = self.destinations[i]
                                    trip.destination = self.destinations[i+1]
                                    trip.date = self.selectedDate as NSDate
                                    trip.mileage = element["distance"]["value"].doubleValue
                                }else{
                                    self.popAlert(message: "Please enter valide locations")
                                }
                            }
                        }
                        do{
                            try managedContext?.save()
                            print("\(i) trip saved")
                        }catch{
                            print("Failed saving")
                        }
                    }
                    
                }
            }
        }
        DispatchQueue.main.async {[unowned self] in
            self.popAlert(message: "Done saving your trip(s)")
            self.originTextField.text! = ""
            self.destinationTextField.text! = ""
            self.destinations.removeAll()
        }
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

