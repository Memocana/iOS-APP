//
//  TextViewController.swift
//  test
//
//  Created by Memow on 7/16/14.
//  Copyright (c) 2014 MCan. All rights reserved.
//


//
//  ViewController.swift
//  test
//
//  Created by Memow on 7/16/14.
//  Copyright (c) 2014 MCan. All rights reserved.
//

import Foundation
import CoreData
import UIKit
import MultipeerConnectivity

class TextViewController: UIViewController, UITextFieldDelegate, UIActionSheetDelegate {
    @IBOutlet var Adi: UILabel!
    @IBOutlet var Soyadi: UILabel!
    @IBOutlet var Sirketi: UILabel!
    @IBOutlet var Maili: UILabel!
    @IBOutlet var Bul: UIButton!
    @IBOutlet var Sil: UIButton!
    @IBOutlet var AramaSonucu: UILabel!
    @IBOutlet var SearchBar: UITextField!
    @IBOutlet var tvChat: UITextView!
    @IBOutlet weak var resimPreview: UIImageView!
    var kisiDataBaseKonumu: Int = 0
    var tempImageStorage: UIImage!
    
    var personInfo:Array<String> = Array<String>()
    
    override func viewDidLoad() {
        self.navigationItem.hidesBackButton = true;
        super.viewDidLoad()
        println(personInfo)
        Adi.text = personInfo[0]
        Soyadi.text = personInfo[1]
        Sirketi.text = "Şirket:\t"+personInfo[2]
        Maili.text = "Mail:\t"+personInfo[3]
        resimPreview.image = tempImageStorage
        
        //resimPreview.image = UIImage(data: (coreDataManager.getData().valueForKey("image") as [NSData])[kisiDataBaseKonumu])
    }
    
    @IBAction func paylasBasildi(sender: AnyObject) {
        var confirmSending: UIActionSheet = UIActionSheet(title: personInfo[0], delegate: self, cancelButtonTitle: nil, destructiveButtonTitle: nil)
        /*
        for (var i = 0; i < mcManager.session?.connectedPeers.count; i++) {
            confirmSending.addButtonWithTitle(mcManager.session?.connectedPeers[i].displayName)
        }
        */
        for (var i = 0; i < arrConnectedDevices.count; i++) {
            confirmSending.addButtonWithTitle(arrConnectedDevices[i] as String)
        }
        confirmSending.cancelButtonIndex = confirmSending.addButtonWithTitle("cancel")
        
        confirmSending.showInView(self.view)
    }
    
    func actionSheet(actionSheet: UIActionSheet!, clickedButtonAtIndex buttonIndex: Int) {
        if (buttonIndex != actionSheet.cancelButtonIndex) {
            var data: NSData = NSKeyedArchiver.archivedDataWithRootObject(personInfo)
            var error: NSError?
            println(mcManager.peers[buttonIndex])
            mcManager.browser2?.invitePeer(mcManager.peers[buttonIndex], toSession: mcManager.session as MCSession, withContext: nil, timeout: 10)
            
            
            if (mcManager.session?.connectedPeers.count != 0) {
                var acb: AnyObject? = mcManager.session?.connectedPeers[buttonIndex]
                var sender: [AnyObject] = []
                sender.append(acb!)

                mcManager.session?.sendData(data, toPeers: sender, withMode: MCSessionSendDataMode.Reliable , error: &error)
                UIAlertView(title: "Yollama Başarılı", message: "\(mcManager.peers[buttonIndex].displayName) adlı kişiye gönderildi", delegate: self, cancelButtonTitle: "Tamam").show()
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func aramaYap(sender: AnyObject) {
        if !SearchBar.text.isEmpty || SearchBar.text == "Aramak için İsim Girin" {
            AramaSonucu.text = "\(coreDataManager.getData(SearchBar.text).count)"
        } else {
            AramaSonucu.text = "Lütfen geçerli bi isim girin"
        }
    }
    
    @IBAction func silmeYap(sender: AnyObject) {
        if !SearchBar.text.isEmpty || SearchBar.text == "Aramak için İsim Girin" {
            AramaSonucu.text = "\(coreDataManager.getData(SearchBar.text).count) isim silindi."
            coreDataManager.removeData(SearchBar.text)
        } else {
            AramaSonucu.text = "Lütfen geçerli bi isim girin"
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        if (segue.identifier == "duzenleSeque") {
            println(kisiDataBaseKonumu)
            println(coreDataManager.getData().valueForKey("name"))
            var duzenlenenKisi = (coreDataManager.getData().valueForKey("name") as [String])
            coreDataManager.removeData(duzenlenenKisi[kisiDataBaseKonumu])
            println("\(personInfo) düzenlemeye geçiliyor")
            (segue.destinationViewController as ViewController).duzenleme = true
            (segue.destinationViewController as ViewController).duzenlemeBilgileri = personInfo
            (segue.destinationViewController as ViewController).duzenlemePictureStorage = resimPreview.image
        }
    }
}

