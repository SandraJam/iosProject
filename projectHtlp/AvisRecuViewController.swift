//
//  AvisRecuViewController.swift
//  projectHtlp
//
//  Created by tp23 on 23/03/2016.
//  Copyright © 2016 projet. All rights reserved.
//

import UIKit
import CoreData

class AvisRecuViewController: UIViewController {
    
    var profilId: NSManagedObjectID!
    var announceId: NSManagedObjectID!
    var avisArray : [(title: String, description: String, color: String, objectID: NSManagedObjectID)] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let appDel: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context: NSManagedObjectContext = appDel.managedObjectContext
        
        do{
            let user = try context.existingObjectWithID(profilId)
            let requete = NSFetchRequest(entityName: "Avis")
            requete.predicate = NSPredicate(format: "receveurAvis = %@", user)
            
            requete.returnsObjectsAsFaults = false
            do {
                let resultats = try context.executeFetchRequest(requete)
                if (resultats.count > 0){
                    for av in resultats as! [NSManagedObject] {
                        let name = ( (av.valueForKey("donneurAvis")!.valueForKey("firstname")!) as! String ) + ( (av.valueForKey("donneurAvis")!.valueForKey("name")!) as! String )
                        let description : String = (av.valueForKey("note")!.stringValue) + "/5: " + String( (av.valueForKey("text")! as! String).characters.prefix(10) ) + "..."
                        
                        avisArray += [(title: name, description: description, color: "ffe594", objectID: av.objectID)]
                    }
                }
            }catch{
                print("erreur")
            }
        } catch {
            print("erreur")
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func goProfil(sender: AnyObject) {
        if let resultController = storyboard?.instantiateViewControllerWithIdentifier("profil") as? ProfilViewController {
            resultController.idProfil = profilId
            resultController.idAnnounce = announceId
            presentViewController(resultController, animated: true, completion: nil)
        }
    }

    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int { return 1 }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return avisArray.count;
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .Subtitle, reuseIdentifier: "Daniel")
        
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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
