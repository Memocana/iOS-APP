//
//  ViewController.swift
//  test
//
//  Created by Memow on 7/16/14.
//  Copyright (c) 2014 MCan. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITextFieldDelegate, UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBOutlet var adiGirin: UITextField!
    @IBOutlet var soyadiGirin: UITextField!
    @IBOutlet var sirketGirin: UITextField!
    @IBOutlet var mailGirin: UITextField!
    @IBOutlet var Tamam: UIButton!
    @IBOutlet var hata: UILabel!
    @IBOutlet var benimBilgilerimSwitch: UISwitch!
    @IBOutlet weak var resimGirin: UIButton!
    var duzenleme: Bool = false
    var duzenlemeBilgileri: [String] = []
    @IBOutlet weak var resimPreview: UIImageView!
    var defaults:NSUserDefaults = NSUserDefaults.standardUserDefaults()
    var picture: NSData!
    var duzenlemePictureStorage: UIImage!
    
    var testArray = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.}
    }
    override func viewWillAppear(animated: Bool) {
        resimGirin.frame = CGRectMake(20, 20, 133, 133)
        if (coreDataManager.getData().count == 0 || duzenleme) {
            self.navigationItem.hidesBackButton = true;
        } else {
            self.navigationItem.hidesBackButton = false;
            
        }
        
        
        
        if (duzenleme) {
            resimPreview.image = duzenlemePictureStorage
            adiGirin.text = duzenlemeBilgileri[0]
            soyadiGirin.text = duzenlemeBilgileri[1]
            sirketGirin.text = duzenlemeBilgileri[2]
            mailGirin.text = duzenlemeBilgileri[3]
            if (adiGirin.text == defaults.objectForKey("name") as String) {
                benimBilgilerimSwitch.on = true
          }
        }
        
        if (resimPreview.image == nil) {
            resimGirin.setTitle("Resim Seç", forState: nil)
        } else {
            resimGirin.setTitle("", forState: nil)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func resimSecmeAcilsin(sender: AnyObject) {
        var confirmSending: UIActionSheet = UIActionSheet(title: "Resim Ekleyin", delegate: self, cancelButtonTitle: "İptal", destructiveButtonTitle: nil, otherButtonTitles:"Resim Çek", "Resim Seç")
        confirmSending.showInView(self.view)
    }
    
    func actionSheet(actionSheet: UIActionSheet!, clickedButtonAtIndex buttonIndex: Int) {
        if (buttonIndex == 1) {
            var imagePicker: UIImagePickerController = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.Camera
            self.presentViewController(imagePicker, animated: true, completion: nil)
        } else if (buttonIndex == 2) {
            var imagePicker: UIImagePickerController = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
            self.presentViewController(imagePicker, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(picker: UIImagePickerController!, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]!) {
        println(info)
        picker.dismissViewControllerAnimated(true, completion: nil)
        println()
        println(info.keys)
        resimPreview.image = info[UIImagePickerControllerOriginalImage] as UIImage
        picture = UIImagePNGRepresentation(resimPreview.image)
        
    }


    
    @IBAction func tamamTiklandi(sender: UIButton) {
        for i in testArray {
            println(i)
        }
    }
    
    func textFieldShouldReturn(textField: UITextField!) -> Bool {
        adiGirin.resignFirstResponder()
        soyadiGirin.resignFirstResponder()
        sirketGirin.resignFirstResponder()
        mailGirin.resignFirstResponder()

        return true
    }
    
    override func shouldPerformSegueWithIdentifier(identifier: String!, sender: AnyObject!) -> Bool {
        if identifier=="tamamSegue" {
            testArray = []
            hata.text = ""
            if adiGirin.text.isEmpty {
                hata.text = "Lütfen bir ad giriniz"
                testArray.append("")
            } else {
                testArray.append(adiGirin.text)
            }
            if soyadiGirin.text.isEmpty {
                hata.text = hata.text + "\nLüften bir soyad giriniz"
                testArray.append("")
            } else {
                testArray.append(soyadiGirin.text)
            }
            if sirketGirin.text.isEmpty {
                hata.text = hata.text + "\nLütfen bir şirket adı giriniz"
                testArray.append("")
            } else {
                testArray.append(sirketGirin.text)
            }
            if mailGirin.text.isEmpty {
                hata.text = hata.text + "\nLütfen bir mail giriniz"
                testArray.append("")
            } else {
                testArray.append(mailGirin.text)
            }
            hata.text = hata.text
            
            return !(adiGirin.text.isEmpty || soyadiGirin.text.isEmpty || sirketGirin.text.isEmpty || mailGirin.text.isEmpty)
        }
        return true
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!){
        if(segue.identifier=="tamamSegue"){
            (segue.destinationViewController as TextViewController).personInfo = testArray
            print(self.resimPreview.image)
            (segue.destinationViewController as TextViewController).tempImageStorage = self.resimPreview.image
            coreDataManager.save(testArray, picture: picture)
            if (benimBilgilerimSwitch.on) {
                for var i = 0; i < 4; i++ {
                    defaults.setObject(testArray[i], forKey: keys[i])
                }
                defaults.setObject(UIImagePNGRepresentation(resimPreview.image), forKey: "image")
                defaults.synchronize()
            }
            testArray = []
        }
        if (duzenleme) {
            if (!benimBilgilerimSwitch.on && duzenlemeBilgileri[0] == defaults.objectForKey("name") as String) {
                for  i in keys {
                    defaults.setObject("", forKey: i)
                }
            }
        }
        duzenleme = false
    }
}

