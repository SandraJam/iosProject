//
//  CategoriesTableViewController.swift
//  projectHtlp
//
//  Created by Moi on 10/03/2016.
//  Copyright © 2016 projet. All rights reserved.
//

import UIKit
import CoreData

class CategoriesTableViewController: UIViewController{
    
    var icons : [String] = []
    var colors : [String] = []
    var names : [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let appDel: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let contexte: NSManagedObjectContext = appDel.managedObjectContext
        let requete = NSFetchRequest(entityName: "Category")
        requete.returnsObjectsAsFaults = false
        do {
            let resultats = try contexte.executeFetchRequest(requete)
            if resultats.count > 0 {
                for resultat in resultats as! [NSManagedObject] {
                    icons.append((resultat.valueForKey("icon") as? String)!)
                    colors.append((resultat.valueForKey("color") as? String)!)
                    names.append((resultat.valueForKey("name") as? String)!)
                }
            }
        } catch {
            print("Echec de la requête: get")
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return icons.count
    }

    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> CategoryTableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Marcel", forIndexPath: indexPath)as! CategoryTableViewCell
        
        cell.imageCell.image = UIImage(named: self.icons[indexPath.item])
        cell.nameCell.text = self.names[indexPath.item]
        cell.backgroundColor = colorWithHexString(self.colors[indexPath.item])

        return cell
    }
    
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
