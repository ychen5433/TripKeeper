//
//  MonthlySummariesTableViewController.swift
//  TripKeeper
//
//  Created by PYC on 12/28/17.
//  Copyright © 2017 PYC. All rights reserved.
//

import UIKit

class MonthlySummariesTableViewController: UITableViewController {
    @IBOutlet weak var menuBtn: UIBarButtonItem!
    var selectedIndexPath = -1
    var defaultRow = 0
    var trips = [Trip]()
    var monthlyData = [(month: String, totalTrips: Int,totalMiles: Double)]()
    
    let date = Date()
    let dateFormatter = DateFormatter()
//            dateFormatter.dateFormat = "MMMM yyyy"
    //        let month = dateFormatter.string(from: date)
    //        dateFormatter.dateFormat = "yyyy"
    //        let year = dateFormatter.string(from: date)
    //        dateFormatter.dateFormat = "dd"
    //        let day = dateFormatter.string(from: date)
    //
    //        let previousMonth = date.getPreviousMonth()
    //        dateFormatter.dateFormat = "MMM - yyyy"
    //        let lastMonth = dateFormatter.string(from: previousMonth!)
    //        dates = [month, year,day,lastMonth, month,month, month, month]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        menuBtn.target = revealViewController()
        menuBtn.action = #selector(SWRevealViewController.revealToggle(_:))
        view.addGestureRecognizer(revealViewController().panGestureRecognizer())
        getSumOfMonthlyData()
    }
    func getSumOfMonthlyData(){
        dateFormatter.dateFormat = "MMMM yyyy"
         print("*****_______)))\n has \(trips.count)")
        if trips.count > 0{
            
            var currentMonth = dateFormatter.string(from: trips[0].date as Date)
            print(currentMonth)
           
            var tripSum = 0
            var mileSum = 0.0
            for trip in trips{
                print(trip.date)
                if dateFormatter.string(from: trip.date as Date) == currentMonth{
                    tripSum += 1
                    mileSum += trip.mileage
                }else{
                    let newMonthData = (currentMonth, tripSum, mileSum)
                    monthlyData.append(newMonthData)
                    currentMonth = dateFormatter.string(from: trip.date as Date)
                    tripSum = 1
                    mileSum = trip.mileage
                }
            }
            print(monthlyData)
        }
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

        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if selectedIndexPath == indexPath.row {
            selectedIndexPath = -1
        }else{
            selectedIndexPath = indexPath.row
        }
        print("there are \(trips.count) retrived from core data")
        tableView.beginUpdates()
        tableView.reloadRows(at: [indexPath], with: .automatic)
        tableView.endUpdates()
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        if defaultRow == 0{
//            tableView.cellForRow(at: indexPath
//        }
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
