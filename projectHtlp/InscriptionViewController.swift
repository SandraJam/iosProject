//
//  InscriptionViewController.swift
//  projectHtlp
//
//  Created by Moi on 25/02/2016.
//  Copyright © 2016 projet. All rights reserved.
//

import UIKit

class InscriptionViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var nomTextField: UITextField!
    @IBOutlet weak var prenomTextField: UITextField!
    @IBOutlet weak var mailTextField: UITextField!
    @IBOutlet weak var adresseTextField: UITextField!
    @IBOutlet weak var bioTextField: UITextView!
    
    
    @IBAction func onClickButton(sender: AnyObject) {
        print("nom: \(nomTextField.text) & prénom: \(prenomTextField.text)")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.nomTextField.delegate = self
        print("Inscription controller")
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
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
}
