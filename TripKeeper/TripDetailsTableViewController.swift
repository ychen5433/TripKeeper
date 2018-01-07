//
//  TripDetailsTableViewController.swift
//  TripKeeper
//
//  Created by PYC on 12/29/17.
//  Copyright © 2017 PYC. All rights reserved.
//

import UIKit

class TripDetailsTableViewController: UITableViewController {
  
    @IBOutlet weak var menuBtn: UIBarButtonItem!
//    var trips = [Trip]()
    var currentMonthTrips = [Trip]()
    var dateFormatter = DateFormatter()
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func backToMonthlySummeries(_ sender: UIBarButtonItem) {
//        getTrips()
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "MonthlySummariesTableViewController") as! MonthlySummariesTableViewController
//        vc.trips = self.trips
        let transition = CATransition()
        transition.duration = 0.5
        transition.type = kCATransitionPush
        transition.subtype = kCATransitionFromLeft
        transition.timingFunction = CAMediaTimingFunction(name:kCAMediaTimingFunctionEaseInEaseOut)
        view.window!.layer.add(transition, forKey: kCATransition)

        navigationController?.pushViewController(vc, animated: true)
    }
//    func getTrips(){
//        let request = Trip.createFetchRequest()
//        let sort = NSSortDescriptor(key: "date", ascending: false)
//        request.sortDescriptors = [sort]
//        do {
//            trips = (try! appDelegate.persistentContainer.viewContext.fetch(request))
////            print("Got \(trips.count) trips")
//        } catch {
//            print("Fetch failed")
//        }
//    }
//    func colorForIndex(index: Int) -> UIColor
//    {
//        let itemCount = trips.count - 1
//        let color = (CGFloat(index) / CGFloat(itemCount)) * 0.6
//        return UIColor(red: 0.80, green: color, blue: 0.0, alpha: 1.0)
//    }
//    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        if (indexPath.row % 2 == 1){
//            cell.backgroundColor = UIColor.lightGray
//        }else{
//            cell.backgroundColor = UIColor.white
//        }
//    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return currentMonthTrips.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        dateFormatter.dateFormat = "MMM dd"
        let cell = tableView.dequeueReusableCell(withIdentifier: "TripDetailCell", for: indexPath) as! TripDetailCell
        cell.bgView.layer.cornerRadius = 10.0
        cell.backgroundColor = UIColor.lightGray
//        cell.contentView.layer.backgroundColor = CGColor(
//        cell.backgroundColor = UIColor.gray
        cell.dateLabel.text! = dateFormatter.string(from: currentMonthTrips[indexPath.row].date as Date)
        cell.mileageLabel.text! = "\(round(100 * currentMonthTrips[indexPath.row].mileage)/100)"
        cell.originLabel.text! = currentMonthTrips[indexPath.row].origin
        cell.destinationLabel.text! = currentMonthTrips[indexPath.row].destination

        return cell
    }
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        let entryToBeRemoved = currentMonthTrips[indexPath.row]
        if editingStyle == .delete {
            currentMonthTrips.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
        appDelegate.persistentContainer.viewContext.delete(entryToBeRemoved)
        appDelegate.saveContext()
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
