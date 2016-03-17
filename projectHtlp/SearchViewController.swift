//
//  SearchViewController.swift
//  projectHtlp
//
//  Created by Moi on 17/03/2016.
//  Copyright © 2016 projet. All rights reserved.
//

import UIKit
import CoreData

class SearchViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {

    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    var searchActive : Bool = false
    var titles: [String] = []
    var filtered:[String] = []
    var ids: [NSManagedObjectID] = []
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
        
        let appDel: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let contexte: NSManagedObjectContext = appDel.managedObjectContext
        let requete = NSFetchRequest(entityName: "Service")
        requete.returnsObjectsAsFaults = false
        do {
            let resultats = try contexte.executeFetchRequest(requete)
            if (resultats.count > 0){
                for res in resultats as! [NSManagedObject] {
                    titles.append((res.valueForKey("title") as? String)!)
                    ids.append(res.objectID)
                    //ids.append((res.valueForKey("objectID") as? NSManagedObjectID)!)
                }
            }
        } catch {
            print("Echec de la requête: get")
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    // méthodes pour la searchbar
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) { searchActive = true }
    func searchBarTextDidEndEditing(searchBar: UISearchBar) { searchActive = false }
    func searchBarCancelButtonClicked(searchBar: UISearchBar) { searchActive = false }
    func searchBarSearchButtonClicked(searchBar: UISearchBar) { searchActive = false }
    // recherche en live
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        filtered = titles.filter({ (text) -> Bool in
            let tmp: NSString = text
            let range = tmp.rangeOfString(searchText, options: NSStringCompareOptions.CaseInsensitiveSearch)
            return range.location != NSNotFound
        })
        if(filtered.count == 0){
            searchActive = false;
        } else {
            searchActive = true;
        }
        self.tableView.reloadData()
    }
    
    // méhodes de la tableview
    func numberOfSectionsInTableView(tableView: UITableView) -> Int { return 1 }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(searchActive) {
            return filtered.count
        }
        return titles.count;
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("SearchCell")! as UITableViewCell;
        if(searchActive){
            cell.textLabel?.text = filtered[indexPath.row]
        } else {
            cell.textLabel?.text = titles[indexPath.row];
        }
        return cell;
    }
    
    // lien pour ouvrir la page de l'annonce
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "segueFromSearchtoAnnounce" {
            if let destination = segue.destinationViewController as? AnnounceViewController {
                if let idIndex = tableView.indexPathForSelectedRow?.row {
                    destination.announce = ids[idIndex]
                }
            }
        }
    }

}
