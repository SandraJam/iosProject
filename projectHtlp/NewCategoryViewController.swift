//
//  NewCategoryViewController.swift
//  projectHtlp
//
//  Created by Moi on 04/03/2016.
//  Copyright © 2016 projet. All rights reserved.
//

import UIKit
import CoreData

class NewCategoryViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var categoryTextField: UITextField!
    @IBOutlet weak var colorTF: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.categoryTextField.delegate = self
        self.colorTF.delegate = self
        
        // Background
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "fond2")!)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    // ajouter une catégorie
    @IBAction func onClickButton(sender: AnyObject) {
        let appDel: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context: NSManagedObjectContext = appDel.managedObjectContext
        
        let requete = NSFetchRequest(entityName: "Category")
        requete.predicate = NSPredicate(format: "name = %@", categoryTextField.text!)
        do {
            let resultat = try context.executeFetchRequest(requete)
            if(resultat.count > 0) {
                print("Cette catégorie existe déjà")
            }
            else {
                let newEntry = NSEntityDescription.insertNewObjectForEntityForName("Category", inManagedObjectContext: context)
                newEntry.setValue(categoryTextField.text, forKey: "name")
                newEntry.setValue(colorTF.text, forKey: "color")
                do {
                    try context.save()
                    // ouvrir la page d'accueil
                    if let resultController = storyboard?.instantiateViewControllerWithIdentifier("iconCat") as? CategoriesIconViewController {
                        resultController.nameCategory = categoryTextField.text
                        presentViewController(resultController, animated: true, completion: nil)
                    }
                } catch {
                    print("Echec de la requete: save")
                }

            }
        } catch {
            print("Echec de la requete: get")
        }

    }
}
