//
//  GeoResultViewController.swift
//  projectHtlp
//
//  Created by Moi on 19/03/2016.
//  Copyright © 2016 projet. All rights reserved.
//

import UIKit
import CoreData
import MapKit

class GeoResultViewController: UIViewController {
    
    var distance: Int!
    var depart: String!

    override func viewDidLoad() {
        super.viewDidLoad()

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
    @IBAction func goToList(sender: AnyObject) {
        
        if let resultController = storyboard?.instantiateViewControllerWithIdentifier("geolist") as? ListResultViewController {
            resultController.depart = depart
            resultController.distance = distance
            presentViewController(resultController, animated: true, completion: nil)
        }
    }

}
