//
//  NewAnnounceViewController.swift
//  projectHtlp
//
//  Created by Moi on 27/02/2016.
//  Copyright © 2016 projet. All rights reserved.
//

import UIKit

class NewAnnounceViewController: UIViewController {

    @IBOutlet weak var titreTextField: UITextField!
    // trouver comment faire une liste style input select en html
    @IBOutlet weak var categorieTextField: UITextField!
    // trouver comment mettre sur plusieurs lignes
    @IBOutlet weak var descriptionTextField: UITextField!
    
    // trouver comment faire retour pour la navigation bar plutôt que d'ouvrir à nouveau accueil

    @IBAction func onClickButton(sender: AnyObject) {
        print("titre: \(titreTextField.text)")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        print("Nouvelle annonce controller")
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

}
