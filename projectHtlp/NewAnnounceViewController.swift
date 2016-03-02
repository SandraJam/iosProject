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

    

    @IBAction func onClickButton(sender: AnyObject) {
        print("titre: \(titreTextField.text)")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
