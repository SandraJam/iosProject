//
//  ModifCompteViewController.swift
//  projectHtlp
//
//  Created by Moi on 14/03/2016.
//  Copyright © 2016 projet. All rights reserved.
//

import UIKit
import CoreData

class ModifCompteViewController: UIViewController {
    @IBOutlet weak var mailText: UITextField!
    @IBOutlet weak var addressText: UITextField!
    @IBOutlet weak var mdp: UITextField!
    @IBOutlet weak var mdp2: UITextField!

    @IBOutlet weak var bioText: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Background
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "fond2")!)
        let defaults = NSUserDefaults.standardUserDefaults()
        
        let appDel: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context: NSManagedObjectContext = appDel.managedObjectContext
        
        let requete = NSFetchRequest(entityName: "User")
        requete.predicate = NSPredicate(format: "mail = %@", defaults.stringForKey("mail")!)
        do {
            let resultat = try context.executeFetchRequest(requete)
            if(resultat.count > 0) {
                for res in resultat as! [NSManagedObject] {
                    mailText.text = res.valueForKey("mail")! as? String
                    addressText.text = res.valueForKey("address")! as? String
                    bioText.text = res.valueForKey("bio")! as? String
                }
            }
        }catch{
            print("Echec de la requete: get")
        }

        // Do any additional setup after loading the view.
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
    
    // Remettre tous les champs par defaut
    func allToBlank(){
        mailText.layer.borderWidth = 0;
        addressText.layer.borderWidth = 0;
        mdp.layer.borderWidth = 0;
        mdp2.layer.borderWidth = 0;
        bioText.layer.borderWidth = 0;
    }

    
    @IBAction func goToPhoto(sender: AnyObject) {
        // réinitialiser le message d'erreur
        allToBlank();
        
        // vérifier que les champs sont remplis
        var errorBool = false
        // mail
        if let text = mailText.text where text.isEmpty {
            mailText.layer.borderWidth = 2
            mailText.layer.borderColor = UIColor.redColor().CGColor
            errorBool = true
        }
        else {
            //regex
            let regex = try! NSRegularExpression(pattern: "^[\\w]+@[\\w]+\\.[\\w]+$", options: [.CaseInsensitive])
            let regexError = regex.firstMatchInString(mailText.text!, options: [], range: NSMakeRange(0, mailText.text!.utf16.count)) != nil
            
            if(!regexError) {
                mailText.layer.borderWidth = 2
                mailText.layer.borderColor = UIColor.redColor().CGColor
                errorBool = true
            }
        }
        // adresse
        if let text = addressText.text where text.isEmpty {
            addressText.layer.borderWidth = 2
            addressText.layer.borderColor = UIColor.redColor().CGColor
            errorBool = true
        }
        
        // si un champ n'est pas rempli, afficher l'erreur
        if(!errorBool){
            let defaults = NSUserDefaults.standardUserDefaults()
            let appDel: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            let context: NSManagedObjectContext = appDel.managedObjectContext
            let requete = NSFetchRequest(entityName: "User")
            requete.predicate = NSPredicate(format: "mail = %@", defaults.stringForKey("mail")!)
            do {
                let resultat = try context.executeFetchRequest(requete)
                if(resultat.count > 0) {
                    for res in resultat as! [NSManagedObject] {
                        if(mdp.text != nil && mdp.text != "" && mdp.text == mdp2.text){
                            res.setValue(mdp.text, forKey: "password")
                        }
                        res.setValue(addressText.text, forKey: "address")
                        res.setValue(mailText.text, forKey: "mail")
                        res.setValue(bioText.text, forKey: "bio")
                    }
                    defaults.setValue(mailText.text, forKey: "mail")
                    defaults.synchronize()
                    try context.save()
                    if let resultController = storyboard?.instantiateViewControllerWithIdentifier("photo") as?  ModifPictureCompteViewController {
                        presentViewController(resultController, animated: true, completion: nil)
                    }
                    else {
                        print("Echec de l'ouverture de la vue accueil")
                    }

                }
            }catch{
                print("Echec de la requete: get")
            }
        }
        
    }

}
