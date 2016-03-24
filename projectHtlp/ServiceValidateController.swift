//
//  ServiceValidateController.swift
//  projectHtlp
//
//  Created by Moi on 18/03/2016.
//  Copyright © 2016 projet. All rights reserved.
//

import UIKit
import CoreData

class ServiceValidateController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var errorLabel: UILabel!
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    var serviceID: NSManagedObjectID!
    var dateBegin: NSDate!
    var dateFinal: NSDate!
    var remainingTime: NSNumber!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.textField.delegate = self
        errorLabel.text = ""
        
        let appDel: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context: NSManagedObjectContext = appDel.managedObjectContext
        do{
            let service = try context.existingObjectWithID(serviceID)
            label.text = service.valueForKey("title") as? String
            
            let date = NSDateFormatter()
            date.dateFormat = "dd/MM/yyyy"
            dateFinal = service.valueForKey("endDate") as! NSDate
            dateBegin = service.valueForKey("beginDate") as! NSDate
            
            // Time restant
            let time = (service.valueForKey("totalTime") as! NSNumber)
            var timeTmp: NSNumber
            let requete = NSFetchRequest(entityName: "ServiceDonne")
            requete.returnsObjectsAsFaults = false
            requete.predicate = NSPredicate(format: "service = %@", service)
            var t = time.floatValue
            do {
                let resultats = try context.executeFetchRequest(requete)
                if (resultats.count > 0){
                    for res in resultats as! [NSManagedObject] {
                        timeTmp = (res.valueForKey("time") as? NSNumber)!
                        t = t - timeTmp.floatValue
                    }
                }
            } catch {
                print("Echec de la requête: get")
            }
            
            let nf = NSNumberFormatter()
            nf.numberStyle = .DecimalStyle
            // Configure the number formatter to your liking
            remainingTime = t
            
        } catch {
            print("Echec de la requete: get")
        }
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }

    
    @IBAction func onClickPrevious(sender: AnyObject) {
        if let resultController = storyboard?.instantiateViewControllerWithIdentifier("announce") as? AnnounceViewController {
            resultController.announce = serviceID
            presentViewController(resultController, animated: true, completion: nil)
        } else {
            print("Echec de l'ouverture de la vue announceView")
        }
    }

    
    @IBAction func onClickValidate(sender: AnyObject) {
        // réinitiliser les erreurs
        var error = false
        errorLabel.text = ""
        textField.layer.borderWidth = 0
        datePicker.layer.borderWidth = 0
        
        
        // test temps demandé
        var time: NSNumber = 0
        let formatter = NSNumberFormatter()
        formatter.numberStyle = NSNumberFormatterStyle.DecimalStyle;
        if let timeTest = formatter.numberFromString(textField.text!) {
            if(timeTest.integerValue > remainingTime.integerValue) {
                // erreur, temps demandé trop long
                error = true
                errorLabel.text = "Le temps demandé est trop grand"
                textField.layer.borderWidth = 2
                textField.layer.borderColor = UIColor.redColor().CGColor
            }
            else {
                time = timeTest
            }
        }
            // erreur, temps demandé incorrect
        else {
            error = true
            errorLabel.text = "Le temps demandé est incorrect"
            textField.layer.borderWidth = 2
            textField.layer.borderColor = UIColor.redColor().CGColor
        }
        
        
        // test date
        let dateWanted = datePicker.date
        
        var order = NSCalendar.currentCalendar().compareDate(dateWanted, toDate: dateBegin, toUnitGranularity: .Day)
        switch order {
        case .OrderedAscending:
            // erreur, date avant service
            error = true
            errorLabel.text = "La personne n'est pas disponible à la date saisie"
            datePicker.layer.borderWidth = 2
            datePicker.layer.borderColor = UIColor.redColor().CGColor
            break
        default:
            break
        }
        order = NSCalendar.currentCalendar().compareDate(dateWanted, toDate: dateFinal, toUnitGranularity: .Day)
        switch order {
        case .OrderedDescending:
            // erreur, date apres service
            error = true
            errorLabel.text = "La personne n'est pas disponible à la date saisie"
            datePicker.layer.borderWidth = 2
            datePicker.layer.borderColor = UIColor.redColor().CGColor
            break
        default:
            break
        }
        
        
        // si les infos saisies sont correctes
        if(!error) {
            var errorSave = false
            // récupérer l'utilisateur qui demande cette aide
            var user: AnyObject!
            
            let defaults = NSUserDefaults.standardUserDefaults()
            let appDel: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            let context: NSManagedObjectContext = appDel.managedObjectContext
            let requete = NSFetchRequest(entityName: "User")
            requete.predicate = NSPredicate(format: "mail = %@", defaults.stringForKey("mail")!)
            do {
                let resultat = try context.executeFetchRequest(requete)
                if(resultat.count > 0) {
                    for res in resultat {
                        user = res
                    }
                }
            } catch {
                errorSave = true
                print("Echec de la requete: get user")
            }
            
            // récupérer le service
            let service: AnyObject!
            if(!errorSave) {
                let appDel: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                let context: NSManagedObjectContext = appDel.managedObjectContext
                do {
                    let serviceAux = try context.existingObjectWithID(serviceID)
                    service = serviceAux
                    
                    // créer le serviceDonne & y lier userRecoit
                    let newEntry = NSEntityDescription.insertNewObjectForEntityForName("ServiceDonne", inManagedObjectContext: context)
                    newEntry.setValue(time, forKey: "time")
                    newEntry.setValue(dateWanted, forKey: "date")
                    newEntry.setValue(service, forKey: "service")
                    newEntry.setValue(user, forKey: "userRecoit")
                    
                    do {
                        // sauvegarder en base
                        try context.save()
                        
                        // ouvrir la page d'accueil
                        if let resultController = storyboard?.instantiateViewControllerWithIdentifier("accueil") as? AccueilViewController {
                            presentViewController(resultController, animated: true, completion: nil)
                        }
                        else {
                            print("Echec de l'ouverture de la vue accueil")
                        }
                        
                    } catch {
                        print("Echec de la requete: save service")
                    }
                    
                    
                } catch {
                    print("Echec de la requete: get service")
                }
            }
        }
    }
    
}
