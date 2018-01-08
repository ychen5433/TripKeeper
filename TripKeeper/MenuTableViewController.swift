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
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        getTrips()//get trips from coredata
        let cell = tableView.cellForRow(at: indexPath)
        let revealVC = revealViewController()
        if (cell?.isSelected)!{
            cell?.textLabel?.textColor = UIColor.cyan
        }
        let cellContent = cell?.textLabel?.text!
        switch cellContent {
        case "Monthly Summaries"?:
            let vc = storyboard?.instantiateViewController(withIdentifier: "MonthlySummariesTableViewController") as! MonthlySummariesTableViewController
//            vc.trips = self.trips
            vc.selectedIndexPath = 0
            let newFrontVC = UINavigationController.init(rootViewController: vc)
            revealVC?.pushFrontViewController(newFrontVC, animated: true)
        case "Trip Entry"?:
            let vc = storyboard?.instantiateViewController(withIdentifier: "TripEntryViewController") as! TripEntryViewController
            let newFrontVC = UINavigationController.init(rootViewController: vc)
            revealVC?.pushFrontViewController(newFrontVC, animated: true)
        case "Current Month"?:
            dateFormatter.dateFormat = "MMMM YYYY"
            getRequestedTrips(for: dateFormatter.string(from: Date()))
            if monthlyTrips.count > 0 {
                sendCSVReport(forTripsOfPeriod: monthlyTrips)
                monthlyTrips.removeAll()
            }else{
                popAlert(message: "There's no trips logged in previous month")
            }
        case "Previous Month"?:
            let previousMonth = Calendar.current.date(byAdding: .month, value: -1, to: Date())
            dateFormatter.dateFormat = "MMMM YYYY"
            getRequestedTrips(for: dateFormatter.string(from: previousMonth!))
            if monthlyTrips.count > 0 {
                sendCSVReport(forTripsOfPeriod: monthlyTrips)
                monthlyTrips.removeAll()
            }else{
                popAlert(message: "There's no trips logged in previous month")
            }
        case "YTD"?:
            dateFormatter.dateFormat = "YYYY"
            getRequestedTrips(for: dateFormatter.string(from: Date()))
            if yearlyTrips.count > 0 {
                sendCSVReport(forTripsOfPeriod: yearlyTrips)
                yearlyTrips.removeAll()
            }else{
                popAlert(message: "There's no trips logged so far for the current year")
            }
            
        case "Previous Year"?:
            dateFormatter.dateFormat = "YYYY"
            let previousYear = Calendar.current.date(byAdding: .month, value: -12, to: Date())
            getRequestedTrips(for: dateFormatter.string(from: previousYear!))
            if yearlyTrips.count > 0 {
                sendCSVReport(forTripsOfPeriod: yearlyTrips)
                yearlyTrips.removeAll()
            }else{
                popAlert(message: "There's no trips logged so far for the current year")
            }
        default:
            print("no rows selected")
        }
    }
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.textLabel?.textColor = UIColor.white
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
        if period.components(separatedBy: " ").count == 1{
            dateFormatter.dateFormat = "yyyy"
//            let currentYearString =  dateFormatter.string(from: Date())
            for trip in trips.reversed(){
                if dateFormatter.string(from: trip.date as Date) == period{
                    yearlyTrips.append(trip)
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
            flag = true
        }else if period.components(separatedBy: " ").count == 2{
            dateFormatter.dateFormat = "MMMM YYYY"
            for trip in trips.reversed(){
                if dateFormatter.string(from: trip.date as Date) == period{
                    monthlyTrips.append(trip)
//                    print(trip.date)
                    flag = true
                    flipCount = 1
                }else{
                    flag = false
                }
                if flipCount == 1 && !flag{
                    break
                }
//                print(trip.date)
            }
            flipCount = 0
            flag = true
            
        }
    }

    func sendCSVReport(forTripsOfPeriod: [Trip]){
        
        let requestTrips = forTripsOfPeriod
        
        if MFMailComposeViewController.canSendMail(){
            
            for trip in requestTrips{
                totalMiles += trip.mileage
            }
            let firstTrip = requestTrips.first!
            dateFormatter.dateFormat = "MMMM_YYYY"
            let monthYear = dateFormatter.string(from: firstTrip.date as Date)
            let tripFileName = "\(monthYear).csv"
            dateFormatter.dateFormat = "MMM dd"
            let month = monthYear.components(separatedBy: "_")[0]
            let year = monthYear.components(separatedBy: "_")[1]
            let path = NSURL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(tripFileName)
            var csvText = "Year,Month,Trip Count,Total Mileage\n\(year),\(month),\(requestTrips.count),\(totalMiles)\n\n,,,\n Date,From,To,Miles\n"
            for trip in requestTrips{
                //                    print(trip.destination)
                csvText.append("\"\(dateFormatter.string(from: trip.date as Date))\",\"\(trip.origin)\",\"\(trip.destination)\",\"\(trip.mileage)\"\n")
            }
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
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
