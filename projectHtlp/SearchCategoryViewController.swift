//
//  SearchCategoryViewController.swift
//  projectHtlp
//
//  Created by Moi on 15/03/2016.
//  Copyright © 2016 projet. All rights reserved.
//

import UIKit
import CoreData

class SearchCategoryViewController: UIViewController {
    
    var category: NSManagedObjectID!
    var announces: [AnyObject] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        let appDel: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context: NSManagedObjectContext = appDel.managedObjectContext
        do{
            let cat = try context.existingObjectWithID(category)
            let requete = NSFetchRequest(entityName: "Service")
            requete.predicate = NSPredicate(format: "categorie = %@", cat)
            do {
                announces = try context.executeFetchRequest(requete)
            } catch {
                print("Echec de la requete: get")
            }

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
    
    // MARK: - Table view data source
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return announces.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "Joel")
        
        let date = NSDateFormatter()
        date.dateFormat = "dd/MM/yyyy"
        cell.detailTextLabel!.text = date.stringFromDate(announces[indexPath.item].valueForKey("endDate") as! NSDate)
        cell.textLabel!.text = date.stringFromDate(announces[indexPath.item].valueForKey("beginDate") as! NSDate)
        
        return cell
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool{
        return true
    }
    
    func tableView (tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath){
        
    }

}
