//
//  InscriptionViewController.swift
//  projectHtlp
//
//  Created by Moi on 25/02/2016.
//  Copyright © 2016 projet. All rights reserved.
//

import UIKit
import CoreData

class InscriptionViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate {

    @IBOutlet weak var nomTextField: UITextField!
    @IBOutlet weak var prenomTextField: UITextField!
    @IBOutlet weak var mailTextField: UITextField!
    @IBOutlet weak var adresseTextField: UITextField!
    @IBOutlet weak var bioTextField: UITextView!
    @IBOutlet weak var passwordTextField: UITextField!

    @IBOutlet weak var errorLabel: UILabel!
    

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // delegate pour fermer le clavier via le bouton retour
        self.nomTextField.delegate = self
        self.prenomTextField.delegate = self
        self.mailTextField.delegate = self
        self.adresseTextField.delegate = self
        self.bioTextField.delegate = self
        self.passwordTextField.delegate = self
        
        // bordure du textView de la vio
        bioTextField!.layer.borderWidth = 1
        bioTextField!.layer.borderColor = UIColor.grayColor().CGColor
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    
    // appuie sur le bouton "s'inscrire"
    @IBAction func onClickButton(sender: AnyObject) {
        // réinitialiser le message d'erreur
        errorLabel.text = ""
        
        // vérifier que les champs sont remplis
        var errorStr: String = "Veuillez renseigner:"
        var errorBool = false
        // mail
        if let text = mailTextField.text where text.isEmpty {
            errorStr += "\n votre email"
            errorBool = true
        }
        else {
            //regex
            let regex = try! NSRegularExpression(pattern: "^[\\w]+@[\\w]+\\.[\\w]+$", options: [.CaseInsensitive])
            let regexError = regex.firstMatchInString(mailTextField.text!, options: [], range: NSMakeRange(0, mailTextField.text!.utf16.count)) != nil
    
            if(!regexError) {
                errorStr += "\n un email valide"
                errorBool = true
            }
        }
        // mot de passe
        if let text = passwordTextField.text where text.isEmpty {
            errorStr += "\n un mot de passe"
            errorBool = true
        }
        else {
            // regex
            let regex = try! NSRegularExpression(pattern: "[\\w]+", options: [.CaseInsensitive])
            let regexError = regex.firstMatchInString(mailTextField.text!, options: [], range: NSMakeRange(0, mailTextField.text!.utf16.count)) != nil
            
            if(!regexError) {
                errorStr += "\n mot de passe valide (alphanumérique)"
                errorBool = true
            }
        }
        // nom
        if let text = nomTextField.text where text.isEmpty {
            errorStr += "\n votre nom"
            errorBool = true
        }
        // prénom
        if let text = prenomTextField.text where text.isEmpty {
            errorStr += "\n votre prénom"
            errorBool = true
        }
        // adresse
        if let text = adresseTextField.text where text.isEmpty {
            errorStr += "\n votre adresse"
            errorBool = true
        }
        
        // si un champ n'est pas rempli, afficher l'erreyr
        if(errorBool) {
            errorLabel.text = errorStr
        }
        // sinon vérifier que l'utilisateur n'existe pas déjà
        else {
            let appDel: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            let context: NSManagedObjectContext = appDel.managedObjectContext
            
            // vérifier via l'email
            let requete = NSFetchRequest(entityName: "User")
            requete.predicate = NSPredicate(format: "mail = %@", mailTextField.text!)
            do {
                let resultat = try context.executeFetchRequest(requete)
                // si l'utilisateur existe déjà
                if(resultat.count > 0) {
                    errorLabel.text = "Cet email possède déjà un compte !"
                }
                    // sinon, le créer
                else {
                    let newEntry = NSEntityDescription.insertNewObjectForEntityForName("User", inManagedObjectContext: context)
                    newEntry.setValue(mailTextField.text, forKey: "mail")
                    newEntry.setValue(passwordTextField.text, forKey: "password")
                    newEntry.setValue(nomTextField.text, forKey: "name")
                    newEntry.setValue(prenomTextField.text, forKey: "firstname")
                    newEntry.setValue(adresseTextField.text, forKey: "address")
                    newEntry.setValue(bioTextField.text, forKey: "bio")
                    
                    do {
                        try context.save()
                        // ouvrir la page d'accueil
                        if let resultController = storyboard?.instantiateViewControllerWithIdentifier("accueil") as? AccueilViewController {
                            presentViewController(resultController, animated: true, completion: nil)
                        }
                        else {
                            print("Echec de l'ouverture de la vue accueil")
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
}
