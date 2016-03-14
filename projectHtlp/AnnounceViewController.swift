//
//  AnnounceViewController.swift
//  projectHtlp
//
//  Created by Moi on 14/03/2016.
//  Copyright © 2016 projet. All rights reserved.
//

import UIKit
import CoreData

class AnnounceViewController: UIViewController {
    @IBOutlet weak var categoryIcon: UIImageView!
    @IBOutlet weak var titleAnnounce: UILabel!
    @IBOutlet weak var titleCategory: UILabel!
    @IBOutlet weak var dateBegin: UILabel!
    @IBOutlet weak var dateFinal: UILabel!
    @IBOutlet weak var timeAnnounce: UILabel!
    
    @IBOutlet weak var descAnnounce: UITextView!
    
     var announce: NSManagedObjectID!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appDel: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context: NSManagedObjectContext = appDel.managedObjectContext
        do{
            let service = try context.existingObjectWithID(announce)
            categoryIcon.image = UIImage(named: (service.valueForKey("category")!.valueForKey("icon") as? String)!)
            self.view.backgroundColor = colorWithHexString((service.valueForKey("category")!.valueForKey("color") as? String)!)
            titleAnnounce.text = service.valueForKey("title") as? String
            titleCategory.text = service.valueForKey("category")!.valueForKey("name") as? String
            let date = NSDateFormatter()
            date.dateFormat = "dd/MM/yyy"
            dateFinal.text = date.stringFromDate(service.valueForKey("beginDate") as! NSDate)
            dateBegin.text = date.stringFromDate(service.valueForKey("endDate") as! NSDate)
            let time = service.valueForKey("totalTime") as? NSNumber
            timeAnnounce.text = (time?.stringValue)! + ("h à offrir")
            descAnnounce.text = service.valueForKey("desc") as! String
        } catch {
            print("Echec de la requete: get")
        }
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
    
    // Creates a UIColor from a Hex string.
    func colorWithHexString (hex:String) -> UIColor {
        var cString:String = hex.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()).uppercaseString
        
        if (cString.hasPrefix("#")) {
            cString = (cString as NSString).substringFromIndex(1)
        }
        
        if (cString.characters.count != 6) {
            return UIColor.grayColor()
        }
        
        let rString = (cString as NSString).substringToIndex(2)
        let gString = ((cString as NSString).substringFromIndex(2) as NSString).substringToIndex(2)
        let bString = ((cString as NSString).substringFromIndex(4) as NSString).substringToIndex(2)
        
        var r:CUnsignedInt = 0, g:CUnsignedInt = 0, b:CUnsignedInt = 0;
        NSScanner(string: rString).scanHexInt(&r)
        NSScanner(string: gString).scanHexInt(&g)
        NSScanner(string: bString).scanHexInt(&b)
        
        
        return UIColor(red: CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0, alpha: CGFloat(1))
    }


}
