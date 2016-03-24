//
//  ChoiceMapViewController.swift
//  projectHtlp
//
//  Created by Moi on 19/03/2016.
//  Copyright © 2016 projet. All rights reserved.
//

import UIKit

class ChoiceMapViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var kmLabel: UILabel!
    @IBOutlet weak var departPoint: UITextField!
    
    var distance: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "fond2")!)
        
        departPoint.delegate = self
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func sliderchangekm(sender: UISlider) {
        kmLabel.text = String(Int(sender.value)) + " km"
        distance = Int(sender.value)
    }
    
    
    @IBAction func geoResult(sender: AnyObject) {
        
        if let resultController = storyboard?.instantiateViewControllerWithIdentifier("georesult") as? GeoResultViewController {
            resultController.depart = departPoint.text
            resultController.distance = distance
            presentViewController(resultController, animated: true, completion: nil)
        }
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
