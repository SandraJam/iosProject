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
    var announces : [(title: String, color: String, objectID: NSManagedObjectID)] = []
    var filtered : [(title: String, color: String, objectID: NSManagedObjectID)] = []
    
    
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
                    announces.append( (title: (res.valueForKey("title") as? String)!, color: (res.valueForKey("category")!.valueForKey("color") as? String)!, objectID: res.objectID) )
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
        filtered = announces.filter({ (text) -> Bool in
            let tmp: NSString = text.title
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
        return announces.count;
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("SearchCell")! as UITableViewCell;
        if(searchActive){
            cell.textLabel?.text = filtered[indexPath.row].title
            cell.backgroundColor = colorWithHexString(filtered[indexPath.item].color)
        } else {
            cell.textLabel?.text = announces[indexPath.row].title;
            cell.backgroundColor = colorWithHexString(announces[indexPath.item].color)
        }
        return cell;
    }
    
    // lien pour ouvrir la page de l'annonce
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "segueFromSearchtoAnnounce" {
            if let destination = segue.destinationViewController as? AnnounceViewController {
                if(searchActive) {
                    if let idIndex = tableView.indexPathForSelectedRow?.row {
                        destination.announce = filtered[idIndex].objectID
                    }
                }
                else {
                    if let idIndex = tableView.indexPathForSelectedRow?.row {
                        destination.announce = announces[idIndex].objectID
                    }

                }
            }
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
