//
//  MenuTableViewController.swift
//  TripKeeper
//
//  Created by PYC on 12/22/17.
//  Copyright © 2017 PYC. All rights reserved.
//

import UIKit
import MessageUI

class MenuTableViewController: UITableViewController, MFMailComposeViewControllerDelegate {
    
    var sectionTitles = [String]()
    var rowContents = [[String]]()
    var trips = [Trip]()
    var monthlyTrips = [Trip]()//for current or previous month
    var totalMiles = 0.0

    var yearlyTrips = [Trip]()
    
    var flag = true
    var flipCount = 0
    
    var dateFormatter = DateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.backgroundColor = UIColor.darkGray
        tableView.separatorStyle = .none
        
        sectionTitles = ["Pages","Send Report","Setting"]
        rowContents = [["Trip Entry","Monthly Summaries"],["Current Month","Previous Month", "YTD", "Previous Year"],["Update Default Email"]]
        
        getTrips()
    }
    override func viewWillAppear(_ animated: Bool) {
        clearsSelectionOnViewWillAppear = true
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return rowContents.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return rowContents[section].count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "menuCell", for: indexPath) 
        cell.textLabel?.text = rowContents[indexPath.section][indexPath.row]
        cell.textLabel?.textColor = UIColor.white
        cell.backgroundColor = UIColor.darkGray
        return cell
    }
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        cell?.textLabel?.textColor = UIColor.white
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        getTrips()//get trips from coredata
        let cell = tableView.cellForRow(at: indexPath)
        let revealVC = revealViewController()
        if (cell?.isSelected)!{
            cell?.textLabel?.textColor = UIColor(red: 70/255.0, green: 252/255.0, blue: 62/255.0, alpha: 1.0)
        }
        let cellContent = cell?.textLabel?.text!
        switch cellContent {
        case "Monthly Summaries"?:
            let vc = storyboard?.instantiateViewController(withIdentifier: "MonthlySummariesTableViewController") as! MonthlySummariesTableViewController
            vc.selectedIndexPath = 0
//            let myIndexPath = IndexPath(item: 0, section: 0)
//            tableView.cellForRow(at: myIndexPath)?.textLabel?.textColor = UIColor.white
            let newFrontVC = UINavigationController.init(rootViewController: vc)
            revealVC?.pushFrontViewController(newFrontVC, animated: true)
        case "Trip Entry"?:
//            let myIndexPath = IndexPath(item: 1, section: 0)
//            tableView.cellForRow(at: myIndexPath)?.textLabel?.textColor = UIColor.white
            let vc = storyboard?.instantiateViewController(withIdentifier: "TripEntryViewController") as! TripEntryViewController
            let newFrontVC = UINavigationController.init(rootViewController: vc)
            revealVC?.pushFrontViewController(newFrontVC, animated: true)
        case "Current Month"?:
            dateFormatter.dateFormat = "MMMM yyyy"
            let currentMonthString =  dateFormatter.string(from: Date())
            getRequestedTrips(for: currentMonthString)
            if monthlyTrips.count > 0 {
                sendCSVReport(forTripsOfPeriod: monthlyTrips, periodString: currentMonthString)
                monthlyTrips.removeAll()
            }else{
                popAlert(message: "There's no trips logged this month")
            }
        case "Previous Month"?:
            let previousMonth = Calendar.current.date(byAdding: .month, value: -1, to: Date())
            dateFormatter.dateFormat = "MMMM yyyy"
            let previousMonthString = dateFormatter.string(from: previousMonth!)
            getRequestedTrips(for: previousMonthString)
            if monthlyTrips.count > 0 {
                sendCSVReport(forTripsOfPeriod: monthlyTrips, periodString: previousMonthString)
                monthlyTrips.removeAll()
            }else{
                popAlert(message: "There's no trips logged in previous month")
            }
        case "YTD"?:
            dateFormatter.dateFormat = "yyyy"
            let currentYearString = dateFormatter.string(from: Date())
//            print("this is the year of \(currentYearString)")
            getRequestedTrips(for: currentYearString)
            if yearlyTrips.count > 0 {
                sendCSVReport(forTripsOfPeriod: yearlyTrips, periodString: currentYearString)
                yearlyTrips.removeAll()
            }else{
                popAlert(message: "There's no trips logged so far for the current year")
            }
            
        case "Previous Year"?:
            dateFormatter.dateFormat = "yyyy"
            let previousYearString = dateFormatter.string(from: Calendar.current.date(byAdding: .month, value: -12, to: Date())!)
            getRequestedTrips(for: previousYearString)
            if yearlyTrips.count > 0 {
                sendCSVReport(forTripsOfPeriod: yearlyTrips, periodString: previousYearString)
                yearlyTrips.removeAll()
            }else{
                popAlert(message: "There's no trips logged last year")
            }
        default:
            print("no rows selected")
        }
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionTitles[section]
    }
    
    func getTrips(){
        let request = Trip.createFetchRequest()
        let sort = NSSortDescriptor(key: "date", ascending: false)
        request.sortDescriptors = [sort]
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        do {
            trips = (try! appDelegate.persistentContainer.viewContext.fetch(request))
            print("Got \(trips.count) trips")
        } catch {
            print("Fetch failed")
        }
    }
    
    func getRequestedTrips(for period: String){
        print("\(period) is the year")
       
        let periodString = period.components(separatedBy: " ")
        if periodString.count == 1{
            dateFormatter.dateFormat = "yyyy"
        }else if periodString.count == 2{
            dateFormatter.dateFormat = "MMMM yyyy"
        }
        for trip in trips{
            if dateFormatter.string(from: trip.date as Date) == period{
                if periodString.count == 1{
                    yearlyTrips.append(trip)
                }else{
                    monthlyTrips.append(trip)
                }
                flag = true
                flipCount = 1
            }else{
                flag = false
            }
            if flipCount == 1 && !flag{
                break
            }
        }
        flipCount = 0
        
        
//        if periodString.count == 1{
//            dateFormatter.dateFormat = "YYYY"
//
//            for trip in trips{
//                print(trip.date)
//                print(trip.destination)
//                let tripYearString = dateFormatter.string(from: trip.date as Date)
//                print("tripYearString is \(tripYearString)")
//                if tripYearString == period{
//                    print(tripYearString)
//                    yearlyTrips.append(trip)
//                    flag = true
//                    flipCount = 1
//                }else{
//                    flag = false
//                }
//                if flipCount == 1 && !flag{
//                    break
//                }
//            }
//            flipCount = 0
//        }else if periodString.count == 2{
//            dateFormatter.dateFormat = "MMMM YYYY"
//            for trip in trips{
//                if dateFormatter.string(from: trip.date as Date) == period{
//                    monthlyTrips.append(trip)
//                    flag = true
//                    flipCount = 1
//                }else{
//                    flag = false
//                }
//                if flipCount == 1 && !flag{
//                    break
//                }
//            }
//            flipCount = 0
//        }
    }

    func sendCSVReport(forTripsOfPeriod: [Trip], periodString: String){
        
        let requestTrips = forTripsOfPeriod
        
        if MFMailComposeViewController.canSendMail(){
            
            for trip in requestTrips{
                totalMiles += trip.mileage
            }
            let tripFileName = "\(periodString).csv"
            let path = NSURL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(tripFileName)
            let monthYear = periodString.components(separatedBy: " ")
            var csvText = ""
            dateFormatter.dateFormat = "MMM dd"
            dateFormatter.timeZone = NSTimeZone.local
            if monthYear.count == 2 {
                let month = monthYear[0]
                let year = monthYear[1]
                
                csvText = "Year,Month,Trip Count,Total Mileage\n\(year),\(month),\(requestTrips.count),\(totalMiles)\n\n,,,\n Date,From,To,Miles\n"
            }else{
                csvText = "Year,Trip Count, Total Mileage\n\(periodString),\(requestTrips.count),\(totalMiles)\n,,\nDate,From,To,Miles\n"
            }
            for trip in requestTrips{
                //                    print(trip.destination)
                csvText.append("\"\(dateFormatter.string(from: trip.date as Date))\",\"\(trip.origin)\",\"\(trip.destination)\",\"\(trip.mileage)\"\n")
            }
//            let firstTrip = requestTrips.first!
//            dateFormatter.dateFormat = "MMMM_YYYY"
//            let monthYear = dateFormatter.string(from: firstTrip.date as Date)
            
//            dateFormatter.dateFormat = "MMM dd"
//            let month = monthYear.components(separatedBy: "_")[0]
//            let year = monthYear.components(separatedBy: "_")[1]
//            let path = NSURL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(tripFileName)
//            var csvText = "Year,Month,Trip Count,Total Mileage\n\(year),\(month),\(requestTrips.count),\(totalMiles)\n\n,,,\n Date,From,To,Miles\n"
//            for trip in requestTrips{
//                //                    print(trip.destination)
//                csvText.append("\"\(dateFormatter.string(from: trip.date as Date))\",\"\(trip.origin)\",\"\(trip.destination)\",\"\(trip.mileage)\"\n")
//            }
            do{
                try csvText.write(to: path!, atomically: true, encoding: String.Encoding.utf8)
                
                let mail = MFMailComposeViewController()
                mail.mailComposeDelegate = self
                mail.setToRecipients(["ychen5433@gmail.com"])
                mail.setMessageBody("Hi,\n\nThe .csv trips data is attached\n\n", isHTML: false)
                mail.setSubject("Trips Report from TripKeeper")
                
                try mail.addAttachmentData(NSData(contentsOf: path!) as Data, mimeType: "text/csv", fileName: tripFileName)
                present(mail, animated: true)
            }catch{}
            
            
        }else{
            print("Can't send the email")
        }
    }
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
        if error != nil{
            popAlert(message: "Failed sending your report")
        }else{
            popAlert(title: "Successful!", message: "The report sent")
        }
    }
    
    func popAlert(title: String = "Alert", message: String){
        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        ac.addAction(action)
        self.present(ac,animated: true, completion: nil)
    }
    

}
