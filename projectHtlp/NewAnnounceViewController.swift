//
//  NewAnnounceViewController.swift
//  projectHtlp
//
//  Created by Moi on 27/02/2016.
//  Copyright © 2016 projet. All rights reserved.
//

import UIKit
import CoreData

class NewAnnounceViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {

    
    @IBOutlet weak var scrollview: UIScrollView!
    
    @IBOutlet weak var titreTextField: UITextField!
    @IBOutlet weak var pickerCategorie: UIPickerView!
    @IBOutlet weak var descriptionTextField: UITextView!
    @IBOutlet weak var dateDebutPicker: UIDatePicker!
    @IBOutlet weak var dateFinPicker: UIDatePicker!
    @IBOutlet weak var timeTextField: UITextField!
  
    var categoriesList: [String] = []
    var selectedCategory: String = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollview.contentSize.height = 800
        
        // Background
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "fond2")!)
        selectedCategory = "none"
        
        // bordure du textView de la description
        descriptionTextField!.layer.borderWidth = 1
        descriptionTextField!.layer.borderColor = UIColor.grayColor().CGColor
        
        // récupérer toutes les catégories pour les ajouter au pickerView
        let appDel: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let contexte: NSManagedObjectContext = appDel.managedObjectContext
        let requete = NSFetchRequest(entityName: "Category")
        requete.returnsObjectsAsFaults = false
        do {
            let resultats = try contexte.executeFetchRequest(requete)
            if resultats.count > 0 {
                for resultat in resultats as! [NSManagedObject] {
                    categoriesList.append(resultat.valueForKey("name")! as! String)
                }
            }
        } catch {
            print("Echec de la requête: get")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // fonctions pour le pickerView
    // nombre de données par ligne
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    // nombre d'éléments dans le pickerView
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return categoriesList.count
    }
    // texte à afficher pour chaque ligne
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        // pour stocker le premier élément du pickerView (sinon vaut null alors qu'on a sélectionné le premier élément)
        selectedCategory = categoriesList[row]
        return categoriesList[row]
    }
    // action à faire lorsque l'on sélectionne un élément
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        // TRAITER LE CAS NULL
        selectedCategory = categoriesList[row]
    }
    

    @IBAction func onClickButton(sender: AnyObject) {
        // réinisialiser les erreurs
        titreTextField.layer.borderWidth = 0
        descriptionTextField.layer.borderWidth = 0
        timeTextField.layer.borderWidth = 0
        dateDebutPicker.layer.borderWidth = 0
        dateFinPicker.layer.borderWidth = 0
        
        
        var error: Bool = false
        
        // vérifier titre, description
        if(titreTextField.text!.isEmpty) {
            titreTextField.layer.borderWidth = 2
            titreTextField.layer.borderColor = UIColor.redColor().CGColor
            error = true
        }
        if(descriptionTextField.text!.isEmpty) {
            descriptionTextField.layer.borderWidth = 2
            descriptionTextField.layer.borderColor = UIColor.redColor().CGColor
            error = true
        }
        if(timeTextField.text!.isEmpty) {
            timeTextField.layer.borderWidth = 2
            timeTextField.layer.borderColor = UIColor.redColor().CGColor
            error = true
        }
        var timeValueInt: NSNumber
        timeValueInt = 0
        if let aux = NSNumberFormatter().numberFromString(timeTextField.text!) {
            timeValueInt = aux
        }
        else {
            timeTextField.layer.borderWidth = 2
            timeTextField.layer.borderColor = UIColor.redColor().CGColor
            error = true
        }
        
        // vérifier date début avant date fin
        if( dateDebutPicker.date.timeIntervalSince1970 > dateFinPicker.date.timeIntervalSince1970 ) {
            dateDebutPicker.layer.borderWidth = 2
            dateDebutPicker.layer.borderColor = UIColor.redColor().CGColor
            dateFinPicker.layer.borderWidth = 2
            dateFinPicker.layer.borderColor = UIColor.redColor().CGColor
            error = true
        }
        
        
        // si pas d'erreur, continuer
        if(!error) {
            let appDel: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            let context: NSManagedObjectContext = appDel.managedObjectContext
            

            // récupérer la catégorie
            var category : AnyObject?
            category = nil
            var requete = NSFetchRequest(entityName: "Category")
            requete.predicate = NSPredicate(format: "name = %@", selectedCategory)
            do {
                let resultats = try context.executeFetchRequest(requete)
                if (resultats.count > 0){
                    for res in resultats {
                        category = res
                    }
                }
            } catch {
                print("Echec de la requête: get")
            }
            
            // récupérer l'utilisateur
            var user : AnyObject?
            user = nil
            let defaults = NSUserDefaults.standardUserDefaults()
            requete = NSFetchRequest(entityName: "User")
            requete.predicate = NSPredicate(format: "mail = %@", defaults.stringForKey("mail")!)
            do {
                let resultat = try context.executeFetchRequest(requete)
                if(resultat.count > 0) {
                    for res in resultat {
                        user = res
                    }
                }
            }catch{
                print("Echec de la requete: get")
            }
            
            
            // créer l'annonce
            let newEntry = NSEntityDescription.insertNewObjectForEntityForName("Service", inManagedObjectContext: context)
            newEntry.setValue(titreTextField.text, forKey: "title")
            newEntry.setValue(descriptionTextField.text, forKey: "desc")
            newEntry.setValue(dateDebutPicker.date, forKey: "beginDate")
            newEntry.setValue(dateFinPicker.date, forKey: "endDate")
            newEntry.setValue(timeValueInt, forKey: "totalTime")
            newEntry.setValue(category, forKey: "category")
            newEntry.setValue(user, forKey: "userDonne")
            
            do {
                try context.save()
                if let resultController = storyboard?.instantiateViewControllerWithIdentifier("announce") as? AnnounceViewController {
                    resultController.announce = newEntry.objectID
                    presentViewController(resultController, animated: true, completion: nil)
                } else {
                    print("Echec de l'ouverture de la vue accueil")
                }
            } catch {
                print("Echec de la requete: save")
            }

            
            
            
        }

    }
    
    
}
