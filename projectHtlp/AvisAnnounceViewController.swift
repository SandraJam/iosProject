//
//  AvisAnnounceViewController.swift
//  projectHtlp
//
//  Created by Moi on 22/03/2016.
//  Copyright © 2016 projet. All rights reserved.
//

import UIKit
import CoreData

class AvisAnnounceViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var announceId: NSManagedObjectID!
    
    @IBOutlet weak var tableView: UITableView!
    
    var avisArray : [(title: String, description: String, color: String, objectID: NSManagedObjectID)] = []
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        let appDel: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context: NSManagedObjectContext = appDel.managedObjectContext
        do{
            let service = try context.existingObjectWithID(announceId)
        
            let requete = NSFetchRequest(entityName: "ServiceDonne")
            requete.predicate = NSPredicate(format: "service = %@", service)
            
            requete.returnsObjectsAsFaults = false
            do {
                let resultats = try context.executeFetchRequest(requete)
                if (resultats.count > 0){
                    // boucler sur les serviceDonne
                    for serviceDonne in resultats as! [NSManagedObject] {
                        
                        // récupérer l'utilisateur qui reçoit le service
                        let userRecoit = try context.existingObjectWithID(serviceDonne.valueForKey("userRecoit")!.objectID)
                        
                        let requete2 = NSFetchRequest(entityName: "Avis")
                        requete2.predicate = NSPredicate(format: "service = %@", serviceDonne)
                        do {
                            let avis = try context.executeFetchRequest(requete2)
                            if (avis.count > 0){
                                //var avisReceveurService: NSManagedObject? = nil
                                //var avisDonneurService: NSManagedObject? = nil
                                
                                for av in avis as! [NSManagedObject] {
                                    let name = ( (av.valueForKey("donneurAvis")!.valueForKey("firstname")!) as! String ) + ( (av.valueForKey("donneurAvis")!.valueForKey("name")!) as! String )
                                    let description : String = (av.valueForKey("note")!.stringValue) + "/5: " + String( (av.valueForKey("text")! as! String).characters.prefix(10) ) + "..."
                                    
                                    var couleur : String
                                    if userRecoit.valueForKey("mail") as! String == av.valueForKey("donneurAvis")!.valueForKey("mail") as! String {
                                        couleur = "ffe594"
                                    }
                                    else {
                                        couleur = "cbbc9b"
                                    }
                                    
                                    avisArray += [(title: name, description: description, color: couleur, objectID: av.objectID)]
                                }
                            }
                        } catch {
                            print("echec")
                        }
                    }
                }
            } catch {
                print("Echec de la requête: get")
            }
            
            
        } catch {
            print("Echec de la requete: get")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int { return 1 }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return avisArray.count;
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .Subtitle, reuseIdentifier: "cell1")
        
        cell.textLabel!.text = avisArray[indexPath.row].title
        cell.detailTextLabel!.text = avisArray[indexPath.item].description
        cell.backgroundColor = colorWithHexString(avisArray[indexPath.item].color)
        
        return cell;
    }
    
    
    
    func colorWithHexString (hex:String) -> UIColor {
        var cString:String = hex.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()).uppercaseString
        
        if (cString.hasPrefix("#")) {
            cString = (cString as NSString).substringFromIndex(1)
        }
        
        if (cString.characters.count != 6) {
            return UIColor.grayColor()
        }
        
        let rString = (cString as NSString).substringToIndex(2)
        let gString = ((cString as NSString).substringFromIndex(2) as NSString).substringToIndex(2)
        let bString = ((cString as NSString).substringFromIndex(4) as NSString).substringToIndex(2)
        
        var r:CUnsignedInt = 0, g:CUnsignedInt = 0, b:CUnsignedInt = 0;
        NSScanner(string: rString).scanHexInt(&r)
        NSScanner(string: gString).scanHexInt(&g)
        NSScanner(string: bString).scanHexInt(&b)
        
        
        return UIColor(red: CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0, alpha: CGFloat(1))
    }
    
    
    
    
    // lien pour ouvrir la page de l'annonce
    /*override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "segueAvisAnnounce" {
            if let destination = segue.destinationViewController as? AVISController {
                if let idIndex = tableView.indexPathForSelectedRow?.row {
                    destination.announce = avis[idIndex].objectID
                }
            }
        }
    }*/

    @IBAction func onClickPrevious(sender: AnyObject) {
            if let resultController = storyboard?.instantiateViewControllerWithIdentifier("announce") as? AnnounceViewController {
                resultController.announce = announceId
                presentViewController(resultController, animated: true, completion: nil)
            } else {
                print("Echec de l'ouverture de la vue announceView")
            }
    }
}
