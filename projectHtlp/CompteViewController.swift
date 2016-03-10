//
//  CompteViewController.swift
//  projectHtlp
//
//  Created by Moi on 09/03/2016.
//  Copyright © 2016 projet. All rights reserved.
//

import UIKit
import CoreData

class CompteViewController: UIViewController {

    @IBOutlet weak var nom: UILabel!
    @IBOutlet weak var prenom: UILabel!
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
                for res in resultat as! [NSManagedObject] {
                    nom.text = res.valueForKey("name")! as? String
                    prenom.text = res.valueForKey("firstname")! as? String
                }
            }
        }catch{
            print("Echec de la requete: get")
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

}
