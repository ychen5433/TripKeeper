//
//  MonthlySummariesTableViewController.swift
//  TripKeeper
//
//  Created by PYC on 12/28/17.
//  Copyright © 2017 PYC. All rights reserved.
//

import UIKit
import MessageUI

class MonthlySummariesTableViewController: UITableViewController,MFMailComposeViewControllerDelegate {
    @IBOutlet weak var menuBtn: UIBarButtonItem!
    var selectedIndexPath = 0
    var defaultRow = 0
    var trips = [Trip]()
    
    var monthlyData = [(month: String, totalTrips: Int,totalMiles: Double)]()
    var flag = true
    var flipCount = 0
    
    let date = Date()
    let dateFormatter = DateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        menuBtn.target = revealViewController()
        menuBtn.action = #selector(SWRevealViewController.revealToggle(_:))
        view.addGestureRecognizer(revealViewController().panGestureRecognizer())
        getSumOfMonthlyData()
    }
    func getSumOfMonthlyData(){
        dateFormatter.dateFormat = "MMMM yyyy"
        if trips.count > 0{
            var currentMonth = dateFormatter.string(from: trips[0].date as Date)
            print(currentMonth)
           
            var tripSum = 0
            var mileSum = 0.0
            for trip in trips{
                print(trip.date)
                if dateFormatter.string(from: trip.date as Date) == currentMonth{
                    print(currentMonth)
                    tripSum += 1
                    mileSum += trip.mileage
                }else{
                    let newMonthData = (currentMonth, tripSum, mileSum)
                    print(currentMonth)
                    monthlyData.append(newMonthData)
                    currentMonth = dateFormatter.string(from: trip.date as Date)
                    print(currentMonth)
                    tripSum = 1
                    mileSum = trip.mileage
                }
                if trip == trips.last{
                    let newMonthData = (currentMonth, tripSum, mileSum)
                    monthlyData.append(newMonthData)
                }
            }
        }
    }
    @IBAction func viewTripsDetails(_ sender: UIButton) {
        
    }
    
    func retrieveTrips(for month: String) -> [Trip]{
        var requestedMonthTrips = [Trip]()
        dateFormatter.dateFormat = "MMMM yyyy"
        for trip in trips{
            if dateFormatter.string(from: trip.date as Date) == month{
                requestedMonthTrips.append(trip)
                flag = true
                flipCount = 1
            }else{
                flag = false
            }
            if flipCount == 1 && !flag{
                break
            }
        }
        return requestedMonthTrips
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
//create arrays to store trips from each month
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return monthlyData.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "monthlySummaryCell", for: indexPath) as! MonthlySummaryCell
        cell.month.text! = monthlyData[indexPath.row].month
        cell.totalMiles.text! = "\(monthlyData[indexPath.row].totalMiles)"
        cell.numberOfTrips.text! = "\(monthlyData[indexPath.row].totalTrips)"
//        let currentMonthTrips = self.retrieveTrips(for: cell.month.text!)
        cell.onButtonTapped = {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "TripDetailsTableViewController") as! TripDetailsTableViewController
            vc.currentMonthTrips = self.retrieveTrips(for: cell.month.text!)
            self.navigationController?.pushViewController(vc, animated: true)
        }
        cell.onReportBtnTapped = {
            let trips = self.retrieveTrips(for: cell.month.text!)
            self.sendCSVReport(indexForRequestedMonth: indexPath.row, currentMonthTrips:trips)
        }
        return cell
    }
    
    func sendCSVReport(indexForRequestedMonth: Int,currentMonthTrips: [Trip]){
        let requestedMonthTrips = currentMonthTrips
            if MFMailComposeViewController.canSendMail(){
                dateFormatter.dateFormat = "MMM dd"
                let monthYear = monthlyData[indexForRequestedMonth].month
                let month = monthYear.components(separatedBy: " ")[0]
                let year = monthYear.components(separatedBy: " ")[1]
                let tripFileName = "\(monthYear).csv"
                let path = NSURL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(tripFileName)
                var csvText = "Year,Month,Trip Count,Total Mileage\n\(year),\(month),\(monthlyData[indexForRequestedMonth].totalTrips),\(monthlyData[indexForRequestedMonth].totalMiles)\n\n,,,\n Date,From,To,Miles\n"
                for trip in requestedMonthTrips{
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
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if selectedIndexPath == indexPath.row {
            selectedIndexPath = -1
        }else{
            selectedIndexPath = indexPath.row
        }
//        print("there are \(trips.count) retrived from core data")

        tableView.beginUpdates()
        tableView.reloadRows(at: [indexPath], with: .automatic)
        tableView.endUpdates()
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        if (selectedIndexPath == indexPath.row){
            return 200
        }else{
            return 100
        }
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
