//
//  ViewController.swift
//  projectHtlp
//
//  Created by tp23 on 25/02/2016.
//  Copyright © 2016 projet. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {

    @IBOutlet weak var connexion: UIButton!
    @IBOutlet weak var inscription: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "fond")!)
        connexion.layer.cornerRadius = 5
        connexion.layer.borderWidth = 2
        connexion.layer.borderColor = UIColor.whiteColor().CGColor
        inscription.layer.cornerRadius = 5
        inscription.layer.borderWidth = 2
        inscription.layer.borderColor = UIColor.whiteColor().CGColor
        
        // Données utilisateurs en mémoire
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setValue("", forKey: "mail")
        defaults.synchronize()
        
        /* A DECOMMENTER POUR DELETE LES CATEGORIES ET A RECOMMENTER APRES */
        //deleteCatgeorie()
        /* PAREIL POUR LES SERVICES */
        //deleteServices()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func deleteCatgeorie(){
        // Recupérer les categories
        let appDel: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let contexte: NSManagedObjectContext = appDel.managedObjectContext
        let requete = NSFetchRequest(entityName: "Category")
        requete.returnsObjectsAsFaults = false
        do {
            let resultats = try contexte.executeFetchRequest(requete)
            if (resultats.count > 0){
                for res in resultats as! [NSManagedObject] {
                    contexte.deleteObject(res)
                }
                try contexte.save()
            }
        } catch {
            print("Echec de la requête: get")
        }
    }
    func deleteServices(){
        // Recupérer les services
        let appDel: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let contexte: NSManagedObjectContext = appDel.managedObjectContext
        let requete = NSFetchRequest(entityName: "Service")
        requete.returnsObjectsAsFaults = false
        do {
            let resultats = try contexte.executeFetchRequest(requete)
            if (resultats.count > 0){
                for res in resultats as! [NSManagedObject] {
                    contexte.deleteObject(res)
                }
                try contexte.save()
            }
        } catch {
            print("Echec de la requête: get")
        }
    }
}

