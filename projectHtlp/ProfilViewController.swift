//
//  ProfilViewController.swift
//  projectHtlp
//
//  Created by Moi on 18/03/2016.
//  Copyright © 2016 projet. All rights reserved.
//

import UIKit
import CoreData

class ProfilViewController: UIViewController {
    
    var idProfil: NSManagedObjectID!
    var idAnnounce: NSManagedObjectID!
    
    @IBOutlet weak var imageProfil: UIImageView!
    @IBOutlet weak var nomProfil: UILabel!
    @IBOutlet weak var prenomprofil: UILabel!
    @IBOutlet weak var adresseprofil: UILabel!
    @IBOutlet weak var bioProfil: UITextView!
    
    @IBOutlet weak var star1P: UIImageView!
    @IBOutlet weak var star2P: UIImageView!
    @IBOutlet weak var star3P: UIImageView!
    @IBOutlet weak var star4P: UIImageView!
    @IBOutlet weak var star5P: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        let appDel: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context: NSManagedObjectContext = appDel.managedObjectContext
        
        do{
            let user = try context.existingObjectWithID(idProfil)
            imageProfil.image = UIImage(named: (user.valueForKey("picture") as? String)!)
            nomProfil.text = user.valueForKey("name") as? String
            prenomprofil.text = user.valueForKey("firstname") as? String
            adresseprofil.text = user.valueForKey("address") as? String
            bioProfil.text = user.valueForKey("bio") as? String
            
            
            
            var score = 0.0
            
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
                if (score  >= 5.0){
                    star5P.image = UIImage(named: "star")
                }else if (score > 4.4){
                    star5P.image = UIImage(named: "star_half")
                }else{
                    star5P.image = UIImage(named: "star_empty")
                }
                
                if (score  >= 4.0){
                    star4P.image = UIImage(named: "star")
                }else if (score > 3.4 && score < 4.0){
                    star4P.image = UIImage(named: "star_half")
                }else{
                    star4P.image = UIImage(named: "star_empty")
                }
                
                if (score  >= 3.0){
                    star3P.image = UIImage(named: "star")
                }else if (score > 2.4 && score < 3.0){
                    star3P.image = UIImage(named: "star_half")
                }else{
                    star3P.image = UIImage(named: "star_empty")
                }
                
                if (score  >= 2.0){
                    star2P.image = UIImage(named: "star")
                }else if (score > 1.4 && score < 2.0){
                    star2P.image = UIImage(named: "star_half")
                }else{
                    star2P.image = UIImage(named: "star_empty")
                }
                
                if (score  >= 1.0){
                    star1P.image = UIImage(named: "star")
                }else if (score > 0.4 && score < 1.0){
                    star1P.image = UIImage(named: "star_half")
                }else{
                    star1P.image = UIImage(named: "star_empty")
                }
            }catch {
                print("Echec de la requete: get")
            }
            
        }catch {
            print("Echec de la requete: get")
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func retour(sender: AnyObject) {
        if let resultController = storyboard?.instantiateViewControllerWithIdentifier("announce") as? AnnounceViewController {
            resultController.announce = idAnnounce
            presentViewController(resultController, animated: true, completion: nil)
        }

    }

    @IBAction func goAvisDonne(sender: AnyObject) {
        if let resultController = storyboard?.instantiateViewControllerWithIdentifier("avisDonne") as? AvisDonneViewController {
            resultController.announceId = idAnnounce
            resultController.profilId = idProfil
            presentViewController(resultController, animated: true, completion: nil)
        }
    }
    
    @IBAction func goAvisRecu(sender: AnyObject) {
        if let resultController = storyboard?.instantiateViewControllerWithIdentifier("avisRecu") as? AvisRecuViewController {
            resultController.announceId = idAnnounce
            resultController.profilId = idProfil
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

}
