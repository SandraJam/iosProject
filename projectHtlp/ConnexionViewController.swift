//
//  ConnexionViewController.swift
//  projectHtlp
//
//  Created by Moi on 25/02/2016.
//  Copyright © 2016 projet. All rights reserved.
//

import UIKit
import CoreData

class ConnexionViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var loginTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var errorLabel: UILabel!


    override func viewDidLoad() {
        super.viewDidLoad()
        
        // delegate pour fermer le clavier via le bouton retour
        self.loginTextField.delegate = self
        self.passwordTextField.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // appui sur le bouton "se connecter"
    @IBAction func onClickButton(sender: AnyObject) {
        // réinitialiser le message d'erreur
        errorLabel.text = ""
        
        // vérifier que les champs sont remplis
        var errorBool = false;
        if let text = loginTextField.text where text.isEmpty {
            errorBool = true
        }
        if let text = passwordTextField.text where text.isEmpty {
            errorBool = true
        }
        
        // si champs non remplis
        if(errorBool) {
            errorLabel.text = "Veuillez remplir les champs"
        }
        // sinon vérifier les id
        else {
            let appDel: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            let context: NSManagedObjectContext = appDel.managedObjectContext
        
            // vérifier via l'email et le mot de passe
            let requete = NSFetchRequest(entityName: "User")
            requete.predicate = NSPredicate(format: "mail = %@ AND password = %@", loginTextField.text!, passwordTextField.text!)
            do {
                let resultat = try context.executeFetchRequest(requete)
                // si la connexion est ok, ouvrir la page d'accueil
                if(resultat.count > 0) {
                    if let resultController = storyboard?.instantiateViewControllerWithIdentifier("accueil") as? AccueilViewController {
                        presentViewController(resultController, animated: true, completion: nil)
                    }
                    else {
                        print("Echec de l'ouverture de la vue accueil")
                    }
                }
                // sinon, erreur de connexion
                else {
                     errorLabel.text = "email ou le mot de passe incorrect"
                }
            } catch {
                print("Echec de la requete: get")
            }
        }
    }
}
