//
//  NewAvisViewController.swift
//  projectHtlp
//
//  Created by Moi on 19/03/2016.
//  Copyright © 2016 projet. All rights reserved.
//

import UIKit
import CoreData

class NewAvisViewController: UIViewController, UITextViewDelegate {
    @IBOutlet weak var star3: UIButton!
    @IBOutlet weak var star2: UIButton!
    @IBOutlet weak var star1: UIButton!
    @IBOutlet weak var star4: UIButton!
    @IBOutlet weak var star5: UIButton!

    @IBOutlet weak var descAvis: UITextView!
    
    var note: NSNumber = 0
    
    var servicedonneId: NSManagedObjectID!
    var donneurId: NSManagedObjectID!
    var receveurId: NSManagedObjectID!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        descAvis.delegate = self
        
        let appDel: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context: NSManagedObjectContext = appDel.managedObjectContext
        do {
            let service = try context.existingObjectWithID(servicedonneId)
            
            let today = NSDate()
            let order = NSCalendar.currentCalendar().compareDate(today, toDate: service.valueForKey("date") as! NSDate, toUnitGranularity: .Day)
            switch order {
                case .OrderedAscending:
                    star1.enabled = false
                    star2.enabled = false
                    star3.enabled = false
                    star4.enabled = false
                    star5.enabled = false
                    descAvis.editable = false
                    descAvis.text = "Ce service n'a pas encore eu lieu!"
                    break
                default:
                    break
            }
        } catch {
            
        }

    }

    func textViewShouldReturn(textView: UITextView) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

    @IBAction func goAnnounce(sender: AnyObject) {
        let appDel: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context: NSManagedObjectContext = appDel.managedObjectContext
        
        do {
            let service = try context.existingObjectWithID(servicedonneId)
            let donneur = try context.existingObjectWithID(donneurId)
            let receveur = try context.existingObjectWithID(receveurId)

            let newEntry = NSEntityDescription.insertNewObjectForEntityForName("Avis", inManagedObjectContext: context)
                
            newEntry.setValue(note, forKey: "note")
            newEntry.setValue(descAvis.text, forKey: "text")
            newEntry.setValue(service, forKey: "service")
            newEntry.setValue(donneur, forKey: "donneurAvis")
            newEntry.setValue(receveur, forKey: "receveurAvis")
            
            
            do {
                try context.save()
                if let resultController = storyboard?.instantiateViewControllerWithIdentifier("moncompte") as? CompteViewController {
                    presentViewController(resultController, animated: true, completion: nil)
                }
            } catch {
                print("Echec de la requete: save")
            }
        } catch {
            print("Echec de la requete: get")
        }

    }
    
    @IBAction func star1Click(sender: AnyObject) {
        star1.setImage(UIImage(named: "star"), forState: UIControlState.Normal)
        star2.setImage(UIImage(named: "star_empty"), forState: UIControlState.Normal)
        star3.setImage(UIImage(named: "star_empty"), forState: UIControlState.Normal)
        star4.setImage(UIImage(named: "star_empty"), forState: UIControlState.Normal)
        star5.setImage(UIImage(named: "star_empty"), forState: UIControlState.Normal)
        note = 1
    }
    
    @IBAction func star2Click(sender: AnyObject) {
        star1.setImage(UIImage(named: "star"), forState: UIControlState.Normal)
        star2.setImage(UIImage(named: "star"), forState: UIControlState.Normal)
        star3.setImage(UIImage(named: "star_empty"), forState: UIControlState.Normal)
        star4.setImage(UIImage(named: "star_empty"), forState: UIControlState.Normal)
        star5.setImage(UIImage(named: "star_empty"), forState: UIControlState.Normal)
        note = 2
    }
    
    @IBAction func star3Click(sender: AnyObject) {
        star1.setImage(UIImage(named: "star"), forState: UIControlState.Normal)
        star2.setImage(UIImage(named: "star"), forState: UIControlState.Normal)
        star3.setImage(UIImage(named: "star"), forState: UIControlState.Normal)
        
        star4.setImage(UIImage(named: "star_empty"), forState: UIControlState.Normal)
        star5.setImage(UIImage(named: "star_empty"), forState: UIControlState.Normal)
        note = 3
    }
    
    @IBAction func star4Click(sender: AnyObject) {
        star1.setImage(UIImage(named: "star"), forState: UIControlState.Normal)
        star2.setImage(UIImage(named: "star"), forState: UIControlState.Normal)
        star3.setImage(UIImage(named: "star"), forState: UIControlState.Normal)
        star4.setImage(UIImage(named: "star"), forState: UIControlState.Normal)
        
        star5.setImage(UIImage(named: "star_empty"), forState: UIControlState.Normal)
        note = 4
    }
    
    @IBAction func star5Click(sender: AnyObject) {
        star1.setImage(UIImage(named: "star"), forState: UIControlState.Normal)
        star2.setImage(UIImage(named: "star"), forState: UIControlState.Normal)
        star3.setImage(UIImage(named: "star"), forState: UIControlState.Normal)
        star4.setImage(UIImage(named: "star"), forState: UIControlState.Normal)
        star5.setImage(UIImage(named: "star"), forState: UIControlState.Normal)
        note = 5
    }

}
