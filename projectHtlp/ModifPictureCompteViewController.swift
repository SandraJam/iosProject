//
//  ModifPictureCompteViewController.swift
//  projectHtlp
//
//  Created by Moi on 14/03/2016.
//  Copyright © 2016 projet. All rights reserved.
//

import UIKit
import CoreData

class ModifPictureCompteViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    var koala: [String] = ["koala1", "koala2", "koala3", "koala4", "koala5", "koala6", "koala7", "koala8", "koala9"]
    var nameCategory: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 9
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("Paul", forIndexPath: indexPath) as! CategoryViewCellCollectionViewCell
        cell.icon.image = UIImage(named: self.koala[indexPath.item])
        return cell
    }
    
    // MARK: - UICollectionViewDelegate protocol
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath){
        let defaults = NSUserDefaults.standardUserDefaults()
        let appDel: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context: NSManagedObjectContext = appDel.managedObjectContext
        let requete = NSFetchRequest(entityName: "User")
        requete.predicate = NSPredicate(format: "mail = %@", defaults.stringForKey("mail")!)
        do {
            let resultats = try context.executeFetchRequest(requete)
            if(resultats.count > 0) {
                for resultat in resultats as! [NSManagedObject] {
                    resultat.setValue(self.koala[indexPath.item], forKey: "picture")
                    do {
                        try context.save()
                        if let resultController = storyboard?.instantiateViewControllerWithIdentifier("moncompte") as? CompteViewController {
                            presentViewController(resultController, animated: true, completion: nil)
                        }
                    } catch {
                        print("Echec de la requete: save")
                    }
                    
                }
            }
        } catch {
            print("Echec de la requete: get")
        }
    }
}
