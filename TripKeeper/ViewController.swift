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
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        menuBtn.target = revealViewController()
        menuBtn.action = #selector(SWRevealViewController.revealToggle(_:))
        
        view.addGestureRecognizer(revealViewController().panGestureRecognizer())
        
    }
   
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

