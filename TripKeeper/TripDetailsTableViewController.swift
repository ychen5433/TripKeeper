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
    var trips = [Trip]()
    
    @IBAction func backToMonthlySummeries(_ sender: UIBarButtonItem) {
        getTrips()
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "MonthlySummariesTableViewController") as! MonthlySummariesTableViewController
        vc.trips = self.trips
        let transition = CATransition()
        transition.duration = 0.5
        transition.type = kCATransitionPush
        transition.subtype = kCATransitionFromLeft
        transition.timingFunction = CAMediaTimingFunction(name:kCAMediaTimingFunctionEaseInEaseOut)
        view.window!.layer.add(transition, forKey: kCATransition)

        navigationController?.pushViewController(vc, animated: true)
//        let revealVC = revealViewController()
//        let vc = storyboard?.instantiateViewController(withIdentifier: "MonthlySummariesTableViewController") as! MonthlySummariesTableViewController
//        vc.trips = self.trips
//        let newFrontVC = UINavigationController.init(rootViewController: vc)
//        revealVC?.pushFrontViewController(newFrontVC, animated: true)
    }
    func getTrips(){
        let request = Trip.createFetchRequest()
        let sort = NSSortDescriptor(key: "date", ascending: false)
        request.sortDescriptors = [sort]
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        do {
            trips = (try! appDelegate.persistentContainer.viewContext.fetch(request))
            print("Got \(trips.count) trips")
            //            for trip in trips{
            //                print(trip.origin)
            //                print(trip.destination)
            //                print(trip.mileage)
            //                print("done one trip")
            //            }
            //            tableView.reloadData()
        } catch {
            print("Fetch failed")
        }
    }
    var currentMonthTrips = [Trip]()
    var dateFormatter = DateFormatter()
    override func viewDidLoad() {
        super.viewDidLoad()
//        menuBtn.target = revealViewController()
//        menuBtn.action = #selector(SWRevealViewController.revealToggle(_:))
//        view.addGestureRecognizer(revealViewController().panGestureRecognizer())
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

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
        cell.dateLabel.text! = dateFormatter.string(from: currentMonthTrips[indexPath.row].date as Date)
        cell.mileageLabel.text! = "\(round(100 * currentMonthTrips[indexPath.row].mileage)/100)"
        cell.originLabel.text! = currentMonthTrips[indexPath.row].origin
        cell.destinationLabel.text! = currentMonthTrips[indexPath.row].destination

        // Configure the cell...

        return cell
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
