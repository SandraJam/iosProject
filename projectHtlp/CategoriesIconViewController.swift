//
//  CategoriesIconViewController.swift
//  projectHtlp
//
//  Created by Moi on 10/03/2016.
//  Copyright © 2016 projet. All rights reserved.
//

import UIKit
import CoreData

class CategoriesIconViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    var iconsImage: [String] = ["add", "alarm_empty", "alarm", "arrow_left", "arrow_right", "beach", "car", "check", "child", "delete", "flower", "home", "laptop", "note", "pet", "restaurant", "school", "search", "star_empty", "star", "tool", "truck", "user"]
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
        return 23
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("Pierre", forIndexPath: indexPath) as! CategoryViewCellCollectionViewCell
        cell.icon.image = UIImage(named: self.iconsImage[indexPath.item])
        cell.backgroundColor = UIColor(red: (130/255), green: (196/255), blue: (108/255), alpha: 1.0)
        
        return cell
    }
    
    // MARK: - UICollectionViewDelegate protocol
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath){
        let appDel: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context: NSManagedObjectContext = appDel.managedObjectContext
        
        let requete = NSFetchRequest(entityName: "Category")
        requete.predicate = NSPredicate(format: "name = %@", nameCategory!)
        do {
            let resultats = try context.executeFetchRequest(requete)
            if(resultats.count > 0) {
                for resultat in resultats as! [NSManagedObject] {
                    resultat.setValue(self.iconsImage[indexPath.item], forKey: "icon")
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
