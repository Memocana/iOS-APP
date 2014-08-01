//
//  HomeViewController.swift
//  test
//
//  Created by Memow on 7/17/14.
//  Copyright (c) 2014 MCan. All rights reserved.
//

import Foundation
import UIKit
import CoreData
import MultipeerConnectivity



class HomeViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet var ekle: UIButton!
    @IBOutlet var karsilama: UILabel!
    var defaults:NSUserDefaults = NSUserDefaults.standardUserDefaults()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.hidesBackButton = true

        // Do any additional setup after loading the view, typically from a
        if (coreDataManager.getData().count == 0) {
            self.performSegueWithIdentifier("ekleSegue", sender: self)
        }
        var name = defaults.objectForKey("name") as String?
        if (name) {
            karsilama.text = "Hoşgeldin, )"
        } else {
            karsilama.text = "Hoşgeldin, \(name)"
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        var name = defaults.objectForKey("name") as String
        karsilama.text = "Hoşgeldin, \(name)"
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func shouldPerformSegueWithIdentifier(identifier: String!, sender: AnyObject!) -> Bool {
        if (identifier == "benSegue") {
            if ((defaults.objectForKey("name") as String) != "") {
                return true
            }
            return false
        }
        return true
        
    }
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        if (segue.identifier == "benSegue") {
            var benimKartim: [String] = []
            for i in keys {
                benimKartim.append(defaults.objectForKey(i) as String)
            }
            (segue.destinationViewController as TextViewController).personInfo = benimKartim
            (segue.destinationViewController as TextViewController).tempImageStorage = UIImage(data: defaults.objectForKey("image") as NSData)
            
        }

    }
}