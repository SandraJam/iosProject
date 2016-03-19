//
//  AnnounceViewController.swift
//  projectHtlp
//
//  Created by Moi on 14/03/2016.
//  Copyright © 2016 projet. All rights reserved.
//

import UIKit
import CoreData

class AnnounceViewController: UIViewController {
    @IBOutlet weak var categoryIcon: UIImageView!
    @IBOutlet weak var titleAnnounce: UILabel!
    @IBOutlet weak var titleCategory: UILabel!
    @IBOutlet weak var dateBegin: UILabel!
    @IBOutlet weak var dateFinal: UILabel!
    @IBOutlet weak var timeAnnounce: UILabel!
    
    @IBOutlet weak var nomDonneur: UIButton!
    @IBOutlet weak var star1: UIImageView!
    @IBOutlet weak var star2: UIImageView!
    @IBOutlet weak var star3: UIImageView!
    @IBOutlet weak var star4: UIImageView!
    @IBOutlet weak var star5: UIImageView!
    
    @IBOutlet weak var descAnnounce: UITextView!
    
    var announce: NSManagedObjectID!
    var userID: NSManagedObjectID!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appDel: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context: NSManagedObjectContext = appDel.managedObjectContext
        do{
            let service = try context.existingObjectWithID(announce)
            categoryIcon.image = UIImage(named: (service.valueForKey("category")!.valueForKey("icon") as? String)!)
            self.view.backgroundColor = colorWithHexString((service.valueForKey("category")!.valueForKey("color") as? String)!)
            titleAnnounce.text = service.valueForKey("title") as? String
            titleCategory.text = service.valueForKey("category")!.valueForKey("name") as? String
            let date = NSDateFormatter()
            date.dateFormat = "dd/MM/yyyy"
            dateFinal.text = date.stringFromDate(service.valueForKey("beginDate") as! NSDate)
            dateBegin.text = date.stringFromDate(service.valueForKey("endDate") as! NSDate)
            descAnnounce.text = service.valueForKey("desc") as! String
            nomDonneur.setTitle((service.valueForKey("userDonne")!.valueForKey("name") as! String) + " " + (service.valueForKey("userDonne")!.valueForKey("firstname") as! String), forState: .Normal)
            
            // Time restant
            let time = (service.valueForKey("totalTime") as! NSNumber)
            var timeTmp: NSNumber
            let requete = NSFetchRequest(entityName: "ServiceDonne")
            requete.returnsObjectsAsFaults = false
            requete.predicate = NSPredicate(format: "service = %@", service)
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
            // Configure the number formatter to your liking
            let s2 = nf.stringFromNumber(t)
            timeAnnounce.text = s2! + ("h à offrir")
            
            
            // Star
            
            /*
                Récuperer tous les noteRecu d'un user */
                
            var score = 0.0
            userID = service.valueForKey("userDonne")?.objectID
            let userD = service.valueForKey("userDonne")?.objectID
            let user = try context.existingObjectWithID(userD!)
            
            let req = NSFetchRequest(entityName: "Avis")
            req.returnsObjectsAsFaults = false
            req.predicate = NSPredicate(format: "receveurAvis = %@", user)
            do {
                let notes = try context.executeFetchRequest(req)
                if (notes.count > 0){
                    for note in notes as! [NSManagedObject] {
                        score = score + (note.valueForKey("note") as! NSNumber).doubleValue
                    }
                    score = score / Double(notes.count)
                }
                if (score  == 5.0){
                    star5.image = UIImage(named: "star")
                }else if (score > 4.4){
                    star5.image = UIImage(named: "star_half")
                }else{
                    star5.image = UIImage(named: "star_empty")
                }
                
                if (score  == 4.0){
                    star4.image = UIImage(named: "star")
                }else if (score > 3.4){
                    star4.image = UIImage(named: "star_half")
                }else{
                    star4.image = UIImage(named: "star_empty")
                }
                
                if (score  == 3.0){
                    star3.image = UIImage(named: "star")
                }else if (score > 2.4){
                    star3.image = UIImage(named: "star_half")
                }else{
                    star3.image = UIImage(named: "star_empty")
                }
                
                if (score  == 2.0){
                    star2.image = UIImage(named: "star")
                }else if (score > 1.4){
                    star2.image = UIImage(named: "star_half")
                }else{
                    star2.image = UIImage(named: "star_empty")
                }
                
                if (score  == 1.0){
                    star1.image = UIImage(named: "star")
                }else if (score > 0.4){
                    star1.image = UIImage(named: "star_half")
                }else{
                    star1.image = UIImage(named: "star_empty")
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
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func viewUser(sender: AnyObject) {
        if let resultController = storyboard?.instantiateViewControllerWithIdentifier("profil") as? ProfilViewController {
            resultController.idProfil = userID
            resultController.idAnnounce = announce
            presentViewController(resultController, animated: true, completion: nil)
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
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


    @IBAction func onClickValidate(sender: AnyObject) {
        if let resultController = storyboard?.instantiateViewControllerWithIdentifier("serviceValidate") as? ServiceValidateController {
            resultController.serviceID = announce
            presentViewController(resultController, animated: true, completion: nil)
        } else {
            print("Echec de l'ouverture de la vue validateService")
        }
    }
}
