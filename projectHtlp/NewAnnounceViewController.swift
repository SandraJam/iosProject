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
        selectedCategory = categoriesList[row]
        print("selected: \(selectedCategory)")
    }
    

    @IBAction func onClickButton(sender: AnyObject) {
        print("result: \(selectedCategory)")
    }
    
    
}
