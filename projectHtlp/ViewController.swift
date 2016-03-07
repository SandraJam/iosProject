//
//  ViewController.swift
//  projectHtlp
//
//  Created by tp23 on 25/02/2016.
//  Copyright © 2016 projet. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var connexion: UIButton!
    @IBOutlet weak var inscription: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "fond")!)
        connexion.layer.cornerRadius = 5
        connexion.layer.borderWidth = 2
        connexion.layer.borderColor = UIColor.whiteColor().CGColor
        inscription.layer.cornerRadius = 5
        inscription.layer.borderWidth = 2
        inscription.layer.borderColor = UIColor.whiteColor().CGColor
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

