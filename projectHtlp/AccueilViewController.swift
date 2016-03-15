//
//  AccueilViewController.swift
//  projectHtlp
//
//  Created by Moi on 27/02/2016.
//  Copyright © 2016 projet. All rights reserved.
//

import UIKit
import CoreData

class AccueilViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    @IBOutlet weak var newAnnounceBar: UIBarButtonItem!
    @IBOutlet weak var moncompteBar: UIBarButtonItem!
    @IBOutlet weak var notifBar: UIBarButtonItem!
    
    let identifier = "Jules"
    var resultats = []
    var icons : [String] = []
    var colors : [String] = []
    var names : [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Recupérer les categories
        let appDel: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let contexte: NSManagedObjectContext = appDel.managedObjectContext
        let requete = NSFetchRequest(entityName: "Category")
        requete.returnsObjectsAsFaults = false
        do {
            resultats = try contexte.executeFetchRequest(requete)
            if (resultats.count > 0){
                for res in resultats as! [NSManagedObject] {
                    icons.append((res.valueForKey("icon") as? String)!)
                    colors.append((res.valueForKey("color") as? String)!)
                    names.append((res.valueForKey("name") as? String)!)
                }
            }
        } catch {
            print("Echec de la requête: get")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.resultats.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(identifier, forIndexPath: indexPath) as! CategoryViewCellCollectionViewCell
        cell.icon.image = UIImage(named: self.icons[indexPath.item])
        cell.nameTF.text = self.names[indexPath.item]
        cell.backgroundColor = colorWithHexString(self.colors[indexPath.item])
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath){
        let appDel: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context: NSManagedObjectContext = appDel.managedObjectContext
        
        let requete = NSFetchRequest(entityName: "Category")
        requete.predicate = NSPredicate(format: "name = %@", names[indexPath.item])
        do {
            let resultats = try context.executeFetchRequest(requete)
            if(resultats.count > 0) {
                if let resultController = storyboard?.instantiateViewControllerWithIdentifier("searchCategory") as? SearchCategoryViewController {
                    resultController.category = resultats[0].objectID
                    presentViewController(resultController, animated: true, completion: nil)
                }
            }
        } catch {
            print("Echec de la requete: get")
        }
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
