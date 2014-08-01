//
//  MCManager.swift
//  test
//
//  Created by Memow on 7/21/14.
//  Copyright (c) 2014 MCan. All rights reserved.
//

import Foundation
import UIKit
import MultipeerConnectivity


class MCManager: NSObject, MCSessionDelegate, MCNearbyServiceBrowserDelegate, MCNearbyServiceAdvertiserDelegate
{
    var peerID: MCPeerID?
    var session: MCSession?
    var browser: MCBrowserViewController?
    var advertiser: MCAdvertiserAssistant?
    var defaults:NSUserDefaults = NSUserDefaults.standardUserDefaults()
    var browser2: MCNearbyServiceBrowser?
    var advertiser2:MCNearbyServiceAdvertiser?
    
    var peers: [MCPeerID] = []
    
    init() {
        peerID = nil
        session = nil
        browser = nil
        advertiser = nil
        advertiser2 = nil
    }
    
    func session(session: MCSession!, peer peerID: MCPeerID!, didChangeState state: MCSessionState) {
        var dict: NSDictionary = ["peerID":peerID, "state":state.toRaw()]
        NSNotificationCenter.defaultCenter().postNotificationName("MCDidChangeStateNotification", object: nil, userInfo:dict)
    }
    
    // Received data from remote peer
    func session(session: MCSession!, didReceiveData data: NSData!, fromPeer peerID: MCPeerID!){
        println("here")
        var dict: NSDictionary = ["data":data, "peerID":peerID]
        //self.delegate?.mcDidReceiveData(dict)
        var peerDisplayName: NSString  = peerID.displayName;
        var tempNSData: NSArray = NSKeyedUnarchiver.unarchiveObjectWithData(data) as [AnyObject]
        var picture: NSData = NSKeyedArchiver.archivedDataWithRootObject(tempNSData[4])
        var personInfo: [String] = []
        for (var i = 0; i < 4; i++) {
            personInfo.append(tempNSData[i] as String)
        }
        
        println("he ya!")
        
        dispatch_async(dispatch_get_main_queue(), {UIAlertView(title: "Kartivizit Alındı", message: "\(peerID.displayName) size Kartvizit Gönderdi", delegate: self, cancelButtonTitle: "Tamam").show()})
        coreDataManager.save(personInfo, picture: picture)
        println("saved!!")
        
        
        //NSNotificationCenter.defaultCenter().postNotificationName("MCDidReceiveDataNotification", object: nil, userInfo:dict)
    }
    
    // Received a byte stream from remote peer
    func session(session: MCSession!, didReceiveStream stream: NSInputStream!, withName streamName: String!, fromPeer peerID: MCPeerID!){}
    
    // Start receiving a resource from remote peer
    func session(session: MCSession!, didStartReceivingResourceWithName resourceName: String!, fromPeer peerID: MCPeerID!, withProgress progress: NSProgress!){}
    
    // Finished receiving a resource from remote peer and saved the content in a temporary location - the app is responsible for moving the file to a permanent location within its sandbox
    func session(session: MCSession!, didFinishReceivingResourceWithName resourceName: String!, fromPeer peerID: MCPeerID!, atURL localURL: NSURL!, withError error: NSError!){}
    
    func setupPeerAndSessionWithDisplayName() {
        if (defaults.objectForKey("name") as? String != "") {
            println(defaults.objectForKey("name") as String)
            peerID =  MCPeerID(displayName: defaults.objectForKey("name") as String)
        } else {
            peerID = MCPeerID(displayName: UIDevice.currentDevice().name)
        }
        session = MCSession(peer: peerID)
        session!.delegate = self
    }
    
    func advertiser(advertiser: MCNearbyServiceAdvertiser!, didReceiveInvitationFromPeer peerID: MCPeerID!, withContext context: NSData!, invitationHandler: ((Bool, MCSession!) -> Void)!) {
        UIAlertView(title: "Bağlandım", message: "\(peerID.displayName) kişiyle bağlantı kuruldu", delegate: self, cancelButtonTitle: "Tamam").show()
        invitationHandler(true, session)
        
    }
    
    func browser(browser: MCNearbyServiceBrowser!, foundPeer peerID: MCPeerID!, withDiscoveryInfo info: [NSObject : AnyObject]!) {
        println("BULDUM!")
        if (peerID != self.peerID) {
            arrConnectedDevices.addObject(peerID.displayName)
            peers.append(peerID)
        }
        
    }
    
    func browser(browser: MCNearbyServiceBrowser!, lostPeer peerID: MCPeerID!) {
        peers.removeAtIndex(arrConnectedDevices.indexOfObject(peerID.displayName))
        arrConnectedDevices.removeObject(peerID.displayName)
        
    }
    
    func setupSmartBrowser(var shouldAdvertise: Bool) {
        browser2 = MCNearbyServiceBrowser(peer: peerID, serviceType: "chat-files")
        browser2!.delegate = self
        browser2?.startBrowsingForPeers()
        advertiser2 = MCNearbyServiceAdvertiser(peer: peerID, discoveryInfo: nil, serviceType: "chat-files")
        advertiser2!.delegate = self
        if (shouldAdvertise) {
            advertiser2!.startAdvertisingPeer()
        } else {
            advertiser2!.stopAdvertisingPeer()
        }

    }
    
    func setupMCBrowser() {
        browser = MCBrowserViewController(serviceType: "chat-files", session: session)
    }
    
    func advertiseSelf(var shouldAdvertise: Bool) {
        if (shouldAdvertise) {
            advertiser = MCAdvertiserAssistant(serviceType: "chat-files", discoveryInfo: nil, session: session)
            advertiser?.start()
        } else {
            advertiser?.stop()
            advertiser = nil
        }
    }
    
}




