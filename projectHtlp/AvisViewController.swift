//
//  AvisViewController.swift
//  projectHtlp
//
//  Created by tp23 on 23/03/2016.
//  Copyright © 2016 projet. All rights reserved.
//

import UIKit
import CoreData

class AvisViewController: UIViewController {

    @IBOutlet weak var star1A: UIImageView!
    @IBOutlet weak var star2A: UIImageView!
    @IBOutlet weak var star3A: UIImageView!
    @IBOutlet weak var star4A: UIImageView!
    @IBOutlet weak var star5A: UIImageView!
    
    @IBOutlet weak var donneurAvis: UILabel!
    @IBOutlet weak var serviceText: UILabel!
    @IBOutlet weak var donneurServiceText: UILabel!
    @IBOutlet weak var receveurAvis: UILabel!
    
    @IBOutlet weak var noteAvis: UITextView!
    
    var avisId: NSManagedObjectID!
    var retour: String!
    var announceId: NSManagedObjectID!
    var profilId: NSManagedObjectID!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appDel: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context: NSManagedObjectContext = appDel.managedObjectContext
        do{
            let avis = try context.existingObjectWithID(avisId)
            donneurAvis.text = (avis.valueForKey("donneurAvis")?.valueForKey("firstname") as! String) + " " + (avis.valueForKey("donneurAvis")?.valueForKey("name") as! String)
            serviceText.text = avis.valueForKey("service")?.valueForKey("service")?.valueForKey("title") as?String
            donneurServiceText.text = (avis.valueForKey("service")?.valueForKey("service")?.valueForKey("userDonne")?.valueForKey("firstname") as! String) + " " + (avis.valueForKey("service")?.valueForKey("service")?.valueForKey("userDonne")?.valueForKey("name") as! String)
            receveurAvis.text = (avis.valueForKey("receveurAvis")?.valueForKey("firstname") as! String) + " " + (avis.valueForKey("receveurAvis")?.valueForKey("name") as! String)
            
            noteAvis.text = avis.valueForKey("text") as? String
            
            let score = Double(avis.valueForKey("note") as! NSNumber)
            if (score  >= 5.0){
                star5A.image = UIImage(named: "star")
            }else if (score > 4.4){
                star5A.image = UIImage(named: "star_half")
            }else{
                star5A.image = UIImage(named: "star_empty")
            }
            
            if (score  >= 4.0){
                star4A.image = UIImage(named: "star")
            }else if (score > 3.4 && score < 4.0){
                star4A.image = UIImage(named: "star_half")
            }else{
                star4A.image = UIImage(named: "star_empty")
            }
            
            if (score  >= 3.0){
                star3A.image = UIImage(named: "star")
            }else if (score > 2.4 && score < 3.0){
                star3A.image = UIImage(named: "star_half")
            }else{
                star3A.image = UIImage(named: "star_empty")
            }
            
            if (score  >= 2.0){
                star2A.image = UIImage(named: "star")
            }else if (score > 1.4 && score < 2.0){
                star2A.image = UIImage(named: "star_half")
            }else{
                star2A.image = UIImage(named: "star_empty")
            }
            
            if (score  >= 1.0){
                star1A.image = UIImage(named: "star")
            }else if (score > 0.4 && score < 1.0){
                star1A.image = UIImage(named: "star_half")
            }else{
                star1A.image = UIImage(named: "star_empty")
            }
        } catch {
            print("erreur")
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func precedent(sender: AnyObject) {
        if (retour == "avisdonne"){
            if let resultController = storyboard?.instantiateViewControllerWithIdentifier("avisDonne") as? AvisDonneViewController {
                resultController.profilId = profilId
                resultController.announceId = announceId
                presentViewController(resultController, animated: true, completion: nil)
            }
        }else if (retour == "avisrecu") {
            if let resultController = storyboard?.instantiateViewControllerWithIdentifier("avisRecu") as? AvisRecuViewController {
                resultController.profilId = profilId
                resultController.announceId = announceId
                presentViewController(resultController, animated: true, completion: nil)
            }
        } else if (retour == "avisannounce") {
            if let resultController = storyboard?.instantiateViewControllerWithIdentifier("avisAnnounce") as? AvisAnnounceViewController {
                resultController.announceId = announceId
                presentViewController(resultController, animated: true, completion: nil)
            }
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

}
