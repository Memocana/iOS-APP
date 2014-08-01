//
//  KartvizitViewController.swift
//  test
//
//  Created by Memow on 7/17/14.
//  Copyright (c) 2014 MCan. All rights reserved.
//

import Foundation
import UIKit
import CoreData
import MultipeerConnectivity

class KartvizitViewController: UITableViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UISearchBarDelegate, UISearchDisplayDelegate, UIActionSheetDelegate
{
    var testArray: [String] = []
    @IBOutlet var searchBar: UISearchBar!
    var searchResults: [String] = []
    var items: [String] = []
    var selectedFile: NSString = "" ;
    var selectedRow: NSInteger = 0;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.hidesBackButton = true;
        
    }
    override func viewWillAppear(animated: Bool) {
        super.viewDidAppear(animated)
        print(coreDataManager.getData().valueForKey("name"))
        println()
        items = coreDataManager.getData().valueForKey("name") as [String]
        tableView.reloadData()
    }
    
    func searchBarTextDidEndEditing(searchBar: UISearchBar!) {
        println("bitti")
        filterContentForSearchText(searchBar.text)
    }
    
    func searchBarTextDidBeginEditing(searchBar: UISearchBar!) {
        println("başladı")
    }
    func searchBar(searchBar: UISearchBar!, textDidChange searchText: String!) {
        println("değişti")
        filterContentForSearchText(searchBar.text)
    }
    
    func filterContentForSearchText(var searchText: String) -> ()
    {
        println("filtrelendi")
        let resultPredicate = NSPredicate(format: "SELF contains[c] %@", searchText)
        searchResults = (items as NSArray).filteredArrayUsingPredicate(resultPredicate) as [String]
        println(items)
        println("\(searchResults) filter yapıldı")
        tableView.reloadData()
    }
    
    func searchDisplayController(controller: UISearchDisplayController!, didLoadSearchResultsTableView tableView: UITableView!) {
        println("güncellendi")
    }
    func searchDisplayController(controller: UISearchDisplayController!, didShowSearchResultsTableView tableView: UITableView!) {
        println("güncellendi, gösterildi")
        
    }

    override func tableView(tableView: UITableView!, canEditRowAtIndexPath indexPath: NSIndexPath!) -> Bool {
        return true
    }
    
    override func tableView(tableView: UITableView!, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath!) {
        if (editingStyle == UITableViewCellEditingStyle.Delete) {
            var defaults:NSUserDefaults = NSUserDefaults.standardUserDefaults()
            if (items[indexPath.row] == defaults.objectForKey("name") as String) {
                for i in keys {
                    defaults.setObject("", forKey: i)
                }
            }
            items.removeAtIndex(indexPath.row)
            tableView.reloadData()
            coreDataManager.managedObjectContext.deleteObject(coreDataManager.getData()[indexPath.row] as NSManagedObject)
            coreDataManager.saveContext()
        }
    }
    
    override func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int {
        if (self.searchBar.text.isEmpty) {
            return self.items.count;
        } else {
            return self.searchResults.count
        }
    }
    
    override func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell! {
        var cell:UITableViewCell? = self.tableView.dequeueReusableCellWithIdentifier("test") as? UITableViewCell
        
        if(!cell){
            cell = UITableViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: "test")
        }
        if searchBar.text.isEmpty {
            cell!.textLabel.text = self.items[indexPath.row]
        } else {
            cell!.textLabel.text = self.searchResults[indexPath.row]
        }
        
        return cell
    }
    
    override func tableView(tableView: UITableView!, didSelectRowAtIndexPath indexPath: NSIndexPath!) {
        println("You selected cell #\(indexPath.row)!")
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!){
        if(segue.identifier=="tableViewSegue"){
            var indexPath: NSIndexPath = NSIndexPath()
            var subs = coreDataManager.getData().valueForKeyPath("name") as [String]
            var indexed: Int = 0
            if (searchBar.text.isEmpty) {
                println("Arama yok.")
                indexPath = self.tableView.indexPathForSelectedRow()
                indexed = indexPath.row
            } else {
                indexPath = self.searchDisplayController.searchResultsTableView.indexPathForSelectedRow()
                
                indexed = find(subs, tableView.cellForRowAtIndexPath(indexPath).textLabel.text)!
                println("\(tableView.cellForRowAtIndexPath(indexPath).textLabel.text) aratıldı \(indexPath.row)da bulundu")
            }
            
            if (indexPath != nil) {
                testArray.append(subs[indexed])
                subs = coreDataManager.getData().valueForKeyPath("surname") as [String]
                testArray.append(subs[indexed])
                subs = coreDataManager.getData().valueForKeyPath("sirket") as [String]
                testArray.append(subs[indexed])
                subs = coreDataManager.getData().valueForKeyPath("mail") as [String]
                testArray.append(subs[indexed])
                
                (segue.destinationViewController as TextViewController).personInfo = testArray
                (segue.destinationViewController as TextViewController).kisiDataBaseKonumu = indexed
                
                var tempImages = coreDataManager.getData().valueForKeyPath("image") as [NSData]
                
                (segue.destinationViewController as TextViewController).tempImageStorage = UIImage(data: (coreDataManager.getData().valueForKey("image") as [NSData])[indexed])
                testArray = []
            }
        }
        
    }
    override func shouldPerformSegueWithIdentifier(identifier: String!, sender: AnyObject!) -> Bool {
        if (identifier == "tableViewSegue") {
            var indexPath: NSIndexPath = NSIndexPath()
            if (searchBar.text.isEmpty) {
                indexPath = self.tableView.indexPathForSelectedRow()
            } else {
                indexPath = self.searchDisplayController.searchResultsTableView.indexPathForSelectedRow()
            }
            
            if (indexPath != nil) {
                return true
            }
            
            return false
        }
        return true
    }
}