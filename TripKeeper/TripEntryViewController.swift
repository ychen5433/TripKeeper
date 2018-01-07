//
//  ViewController.swift
//  TripKeeper
//
//  Created by PYC on 12/21/17.
//  Copyright © 2017 PYC. All rights reserved.
//

import UIKit
import CoreData

//@IBDesignable
//class DesignableView: UIView {
//}
//
//@IBDesignable
//class DesignableButton: UIButton {
//}
//
//@IBDesignable
//class DesignableTextField: UITextField {
//}
//@IBDesignable
//class DesignableTextView: UITextView {
//}
//@IBDesignable
//class DesignableTableView: UITableView {
//}
//extension UIView {
//    @IBInspectable
//    var cornerRadius: CGFloat {
//        get {
//            return layer.cornerRadius
//        }
//        set {
//            layer.cornerRadius = newValue
//        }
//    }
//    @IBInspectable
//    var shadowRadius: CGFloat {
//        get {
//            return layer.shadowRadius
//        }
//        set {
//            layer.shadowRadius = newValue
//        }
//    }
//
//    @IBInspectable
//    var shadowOpacity: Float {
//        get {
//            return layer.shadowOpacity
//        }
//        set {
//            layer.shadowOpacity = newValue
//        }
//    }
//
//    @IBInspectable
//    var shadowOffset: CGSize {
//        get {
//            return layer.shadowOffset
//        }
//        set {
//            layer.shadowOffset = newValue
//        }
//    }
//    @IBInspectable
//    var shadowColor: UIColor? {
//        get {
//            if let color = layer.shadowColor {
//                return UIColor(cgColor: color)
//            }
//            return nil
//        }
//        set {
//            if let color = newValue {
//                layer.shadowColor = color.cgColor
//            } else {
//                layer.shadowColor = nil
//            }
//        }
//    }
//}


class TripEntryViewController: UIViewController, UITextFieldDelegate, UITableViewDelegate,UITableViewDataSource, UITextViewDelegate {
    let shadowOp: Float = 0.7
    let cornerRadius: CGFloat = 5.0
    let shadowOffset = CGSize(width: 3, height: 3)
    @IBOutlet weak var clearTextViewBtn: UIButton!
    @IBOutlet weak var addDestinationBtn: UIButton!
    @IBOutlet weak var addTripBtn: UIButton!
    @IBOutlet weak var destinationsTable: UITableView!
    let googleDistanceMatrixAPI = "AIzaSyCTW7N5eDPF5Q_ZA6jouU0pqk_D7tk-b8I"
    @IBOutlet weak var menuBtn: UIBarButtonItem!
    @IBOutlet weak var originTextField: MVPlaceSearchTextField!
    @IBOutlet weak var destinationTextField: MVPlaceSearchTextField!
    var originString = ""
    var destinations = [String]()
    var trips = [Trip]()
    var selectedDate = Date()
    
    @IBOutlet weak var noteTextView: UITextView!
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var fromLabel: UILabel!
    @IBOutlet weak var toLabel: UILabel!
    @IBOutlet weak var noteLabel: UILabel!
    
    
    let appDelegate = UIApplication.shared.delegate as? AppDelegate
    let dateFormatter = DateFormatter()
    
    
//    var managedObjectContext: NSManagedObjectContext? = nil
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        menuBtn.target = revealViewController()
        menuBtn.action = #selector(SWRevealViewController.revealToggle(_:))
        view.addGestureRecognizer(revealViewController().panGestureRecognizer())
        dateLabel.layer.shadowOffset = shadowOffset
        dateLabel.layer.shadowOpacity = shadowOp
        fromLabel.layer.shadowOffset = shadowOffset
        fromLabel.layer.shadowOpacity = shadowOp
        toLabel.layer.shadowOpacity = shadowOp
        toLabel.layer.shadowOffset = shadowOffset
        noteLabel.layer.shadowOpacity = shadowOp
        noteLabel.layer.shadowOffset = shadowOffset
        
        destinationsTable.layer.cornerRadius = cornerRadius
        destinationsTable.layer.shadowOpacity = shadowOp
        destinationsTable.layer.shadowOffset = shadowOffset
        destinationsTable.layer.masksToBounds = false
        
        addTripBtn.layer.cornerRadius = cornerRadius
        addTripBtn.layer.shadowOffset = shadowOffset
        addTripBtn.layer.shadowOpacity = shadowOp
        
        originTextField.layer.shadowOpacity = shadowOp
        originTextField.layer.shadowOffset = shadowOffset
        
        destinationTextField.layer.shadowOpacity = shadowOp
        destinationTextField.layer.shadowOffset = shadowOffset
        dateTextField.layer.shadowOpacity = shadowOp
        dateTextField.layer.shadowOffset = shadowOffset
        
        addDestinationBtn.layer.shadowOpacity = shadowOp
        addDestinationBtn.layer.shadowOffset = shadowOffset
        
        noteTextView.delegate = self
        noteTextView.layer.masksToBounds = false
        noteTextView.layer.cornerRadius = cornerRadius
        noteTextView.layer.shadowOpacity = shadowOp
        noteTextView.layer.shadowOffset = shadowOffset
        noteTextView.text = "Please enter trip notes here"
        noteTextView.textColor = UIColor.lightGray
        
        destinationsTable.tableFooterView = UIView(frame: .zero)
        
        
        dateFormatter.dateStyle = DateFormatter.Style.medium
        dateTextField.text = dateFormatter.string(from: Date())
        pickDate(dateTextField)
        
    }
    @IBAction func clearTextViewContent(_ sender: UIButton) {
        noteTextView.text = ""
    }
    internal func textViewDidBeginEditing(_ textView: UITextView){
        if textView.textColor == UIColor.lightGray{
            textView.text = ""
            textView.textColor = UIColor.black
        }
        moveTextView(textView, moveDistance: -250, up: true)
        clearTextViewBtn.isHidden = false
    
    }
    internal func textViewDidEndEditing(_ textView: UITextView){
        if textView.text.isEmpty {
            textView.text = "Please enter trip note here"
            textView.textColor = UIColor.lightGray
        }
        moveTextView(textView, moveDistance: -250, up: false)
        clearTextViewBtn.isHidden = true
    }
    func moveTextView(_ textView: UITextView, moveDistance: Int, up: Bool){
        let moveDuration = 0.3
        let movement: CGFloat = CGFloat(up ? moveDistance : -moveDistance)
        UIView.beginAnimations("animateTextView", context: nil)
        UIView.setAnimationBeginsFromCurrentState(true)
        UIView.setAnimationDuration(moveDuration)
        self.view.frame = self.view.frame.offsetBy(dx: 0, dy: movement)
        UIView.commitAnimations()
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return destinations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DestinationCell") as! DestinationCell
        cell.textLabel?.font = UIFont(name: "Arial", size: 13)
        
        if destinations.count > 0{
            cell.textLabel?.text = destinations[indexPath.row]
        }
        //        cell.textLabel?.text = "Hello"
        return cell
    }
    
    @IBAction func fetchCoreData(_ sender: UIButton) {
        
        let request = Trip.createFetchRequest()
        let sort = NSSortDescriptor(key: "date", ascending: true)
        request.sortDescriptors = [sort]
        
        do {
            trips = (try appDelegate?.persistentContainer.viewContext.fetch(request))!
            print("Got \(trips.count) trips")
            for trip in trips{
                print(trip.origin)
                print(trip.destination)
                print(trip.mileage)
                print("done one trip")
            }
            //            tableView.reloadData()
        } catch {
            print("Fetch failed")
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
        destinationsTable.isHidden = true
    }
    
    @IBAction func addTrips(_ sender: UIButton) {
        destinationsTable.isHidden = true
        noteTextView.resignFirstResponder()
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
        }
    }
    @IBAction func addDestinations(_ sender: UIButton) {
        if destinationTextField.text! != ""{
            destinations.append(destinationTextField.text!)
            destinationTextField.text = ""
        }else{
            popAlert(message: "Please enter the destination")
        }
        if destinations.count > 0{
            destinationsTable.reloadData()
            destinationsTable.isHidden = false
        }
    }
    
    @IBAction func pickDate(_ sender: UITextField) {
        let datePickerView = UIDatePicker()
        datePickerView.datePickerMode = UIDatePickerMode.date
        datePickerView.maximumDate = Date()
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
//                    print(jsonGoogleData)
                    DispatchQueue.main.async {[unowned self] in
                        for row in jsonGoogleData["rows"].arrayValue{
                            for element in row["elements"].arrayValue{
                                if element["status"].stringValue == "OK"{
                                    trip.origin = self.destinations[i]
                                    trip.destination = self.destinations[i+1]
                                    trip.date = self.selectedDate as NSDate
                                    trip.mileage = round(element["distance"]["value"].doubleValue/1609.3226 * 100)/100
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
//    func placeSearch(_ textField: MVPlaceSearchTextField!, responseForSelectedPlace responseDict: GMSPlace!) {
//        print("4")
//        self.view.endEditing(true)
//    }
//    
//    func placeSearchWillShowResult(_ textField: MVPlaceSearchTextField!) {
//        print("5")
//    }
//    
//    func placeSearchWillHideResult(_ textField: MVPlaceSearchTextField!) {
//        print("in pplaceSearchWillHideResult func")
//    }
//    
//    func placeSearch(_ textField: MVPlaceSearchTextField!, resultCell cell: UITableViewCell!, with placeObject: PlaceObject!, at index: Int) {
//        print("in resultCell func")
//        if(index % 2 == 0){
//            cell.contentView.backgroundColor = UIColor.lightGray
//        }else{
//            cell.contentView.backgroundColor = UIColor.white
//        }
//    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

