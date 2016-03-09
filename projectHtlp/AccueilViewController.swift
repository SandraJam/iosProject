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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Recupérer les categories
        let appDel: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let contexte: NSManagedObjectContext = appDel.managedObjectContext
        let requete = NSFetchRequest(entityName: "Category")
        requete.returnsObjectsAsFaults = false
        do {
            resultats = try contexte.executeFetchRequest(requete)
            for res in resultats as! [NSManagedObject] {
                icons.append((res.valueForKey("icon") as? String)!)
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
        
        let name = self.resultats[indexPath.item].valueForKey("icon")! as! String
        if (name != nil){
            cell.icon.image = UIImage(named: name)
        }
        cell.backgroundColor = UIColor.redColor()
        
        return cell
    }
    
    // MARK: - UICollectionViewDelegate protocol
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath){
    }

}
