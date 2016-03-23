//
//  MesServiceRenduViewController.swift
//  projectHtlp
//
//  Created by Moi on 19/03/2016.
//  Copyright © 2016 projet. All rights reserved.
//

import UIKit
import CoreData

class MesServiceRenduViewController: UIViewController {
    
    var icons : [String] = []
    var colors : [String] = []
    var titles : [String] = []
    var details : [String] = []
    var times : [String] = []
    var ids : [NSManagedObjectID] = []
    var userId : NSManagedObjectID!

    override func viewDidLoad() {
        super.viewDidLoad()
        let defaults = NSUserDefaults.standardUserDefaults()
        let appDel: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context: NSManagedObjectContext = appDel.managedObjectContext
        
        let requete = NSFetchRequest(entityName: "User")
        requete.predicate = NSPredicate(format: "mail = %@", defaults.stringForKey("mail")!)
        do {
            let resultat = try context.executeFetchRequest(requete)
            if(resultat.count > 0) {
                userId = resultat[0].objectID
            }
        }catch{
            print("Echec de la requete: get")
        }
        
        do{
            let user = try context.existingObjectWithID(userId)
            let requete2 = NSFetchRequest(entityName: "Service")
            requete2.predicate = NSPredicate(format: "userDonne = %@", user)
            
            do {
                let resultats = try context.executeFetchRequest(requete2)
                if resultats.count > 0 {
                    for resultat in resultats as! [NSManagedObject] {
                        icons.append((resultat.valueForKey("category")!.valueForKey("icon") as? String)!)
                        
                        colors.append((resultat.valueForKey("category")!.valueForKey("color") as? String)!)
                        
                        titles.append((resultat.valueForKey("title") as? String)!)
                        ids.append(resultat.objectID)
                        
                        let date = NSDateFormatter()
                        date.dateFormat = "dd/MM/yyyy"
                        details.append(date.stringFromDate(resultat.valueForKey("beginDate") as! NSDate)+" au "+date.stringFromDate(resultat.valueForKey("endDate") as! NSDate))
                        
                        // Time restant
                        let time = (resultat.valueForKey("totalTime") as! NSNumber)
                        var timeTmp: NSNumber
                        let requete = NSFetchRequest(entityName: "ServiceDonne")
                        requete.returnsObjectsAsFaults = false
                        requete.predicate = NSPredicate(format: "service = %@", resultat)
                        var t = time.floatValue
                        do {
                            let resultats = try context.executeFetchRequest(requete)
                            if (resultats.count > 0){
                                for res in resultats as! [NSManagedObject] {
                                    timeTmp = (res.valueForKey("time") as? NSNumber)!
                                    t = t - timeTmp.floatValue
                                }
                            }
                        } catch {
                            print("Echec de la requête: get")
                        }
                        
                        let nf = NSNumberFormatter()
                        nf.numberStyle = .DecimalStyle
                        let s2 = nf.stringFromNumber(t)
                        times.append(s2! + ("h"))
                    }
                }
            } catch {
                print("Echec de la requête: get")
            }
        }catch {
            print("Echec de la requête: get")
        }
        

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return icons.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> ServiceTableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Gerard", forIndexPath: indexPath)as! ServiceTableViewCell
        
        cell.imageCategory.image = UIImage(named: self.icons[indexPath.item])
        cell.titleService.text = self.titles[indexPath.item]
        cell.backgroundColor = colorWithHexString(self.colors[indexPath.item])
        cell.otherService.text = self.details[indexPath.item]
        cell.timeService.text = self.times[indexPath.item]
        
        return cell
    }
    
    func tableView(tableView: UITableView!, didSelectRowAtIndexPath indexPath: NSIndexPath!) {
        if let resultController = storyboard?.instantiateViewControllerWithIdentifier("serviceDonneRendu") as? ServiceRenduDonneViewController {
            resultController.serviceId = ids[indexPath.item]
            presentViewController(resultController, animated: true, completion: nil)
        }
        
    }
    
    // Creates a UIColor from a Hex string.
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
}
