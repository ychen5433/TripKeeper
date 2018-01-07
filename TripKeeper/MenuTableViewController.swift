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
    
//    var sectionTitles = [String]()
    var rowContents = [String]()
//    var trips = [Trip]()
//    var currentMonthTrips = [Trip]()
//    var yTDTrips = [Trip]()
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.backgroundColor = UIColor.darkGray
        tableView.separatorStyle = .none
        rowContents = ["Trip Entry","Monthly Summaries","Current Month","YTD","Update Default Email"]
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

//    override func numberOfSections(in tableView: UITableView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return rowContents.count
//    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return rowContents.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "menuCell", for: indexPath) 
        cell.textLabel?.text = rowContents[indexPath.row]
        cell.textLabel?.textColor = UIColor.white
        cell.backgroundColor = UIColor.darkGray

        // Configure the cell...

        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        getTrips()//get trips from coredata
        let revealVC = revealViewController()
        
        let cellContent = tableView.cellForRow(at: indexPath)?.textLabel?.text!
        switch cellContent {
        case "Monthly Summaries"?:
            let vc = storyboard?.instantiateViewController(withIdentifier: "MonthlySummariesTableViewController") as! MonthlySummariesTableViewController
//            vc.trips = self.trips
            let newFrontVC = UINavigationController.init(rootViewController: vc)
            revealVC?.pushFrontViewController(newFrontVC, animated: true)
        case "Trip Entry"?:
            let vc = storyboard?.instantiateViewController(withIdentifier: "TripEntryViewController") as! TripEntryViewController
            let newFrontVC = UINavigationController.init(rootViewController: vc)
            revealVC?.pushFrontViewController(newFrontVC, animated: true)
        case "Current Month"?:
            let vc = storyboard?.instantiateViewController(withIdentifier: "TripDetailsTableViewController") as! TripDetailsTableViewController
            let newFrontVC = UINavigationController.init(rootViewController: vc)
            revealVC?.pushFrontViewController(newFrontVC, animated: true)
        default:
            print("no rows selected")
        }
       
    }
//    func sendEmail(){
//        if MFMailComposeViewController.canSendMail(){
//            let mail = MFMailComposeViewController()
//            mail.mailComposeDelegate = self
//            mail.setToRecipients(["ychen5433@gmail.com"])
//            mail.setMessageBody("<p>You're so awesome!<p>", isHTML: true)
//            present(mail, animated: true)
//        }else{
//            print("Failed sending the email")
//        }
//    }
//    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
//        controller.dismiss(animated: true, completion: nil)
//    }
//    func getTrips(){
//        let request = Trip.createFetchRequest()
//        let sort = NSSortDescriptor(key: "date", ascending: false)
//        request.sortDescriptors = [sort]
//        let appDelegate = UIApplication.shared.delegate as! AppDelegate
//        do {
//            trips = (try! appDelegate.persistentContainer.viewContext.fetch(request))
//            for trip in trips{
//
//            }
//            //print("Got \(trips.count) trips")
//        } catch {
//            print("Fetch failed")
//        }
//    }
//    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        return sectionTitles[section]
//    }
    
    
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
