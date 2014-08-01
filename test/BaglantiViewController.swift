//
//  BaglantiViewController.swift
//  test
//
//  Created by Memow on 7/21/14.
//  Copyright (c) 2014 MCan. All rights reserved.
//

import Foundation
import UIKit
import MultipeerConnectivity
var arrConnectedDevices: NSMutableArray = []


class BaglantiViewController: UIViewController, MCBrowserViewControllerDelegate, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate
{
    @IBOutlet var swVisible: UISwitch!
    @IBOutlet var tblConnectedDevices: UITableView!
    @IBOutlet var btnDisconnect: UIButton!

    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "peerDidChangeStateWithNotification:", name: "MCDidChangeStateNotification", object: nil)
        
    }
    
    func browserViewControllerDidFinish(var baglantiViewController: MCBrowserViewController) {
        mcManager.browser?.dismissViewControllerAnimated(true, completion: nil)
    }
    func browserViewControllerWasCancelled(browserViewController: MCBrowserViewController!){
        mcManager.browser?.dismissViewControllerAnimated(true, completion: nil)
    }

    func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int {
        return arrConnectedDevices.count
    }
    
    // Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
    // Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)
    
    func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell! {
        var cell: UITableViewCell? = tableView.dequeueReusableCellWithIdentifier("CellIdentifier") as? UITableViewCell
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "CellIdentifier")
        }
        
        cell!.textLabel.text = arrConnectedDevices[indexPath.row] as String
        
        return cell!
    }
    @IBAction func toggleVisibility(sender: AnyObject) {
        mcManager.setupSmartBrowser(swVisible.on)
    }
    
    @IBAction func disconnect(sender: AnyObject) {
        mcManager.session?.disconnect()
        arrConnectedDevices.removeAllObjects()
        tblConnectedDevices.reloadData()
    }
    
}
