//
//  ViewController.swift
//  TooDoo List
//
//  Created by Devin Baggett on 5/16/18.
//  Copyright © 2018 devbaggett. All rights reserved.
//

import UIKit
import CoreData

class TooDooListViewController: UITableViewController {
    
    var itemArray = [Item]()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
        // Did non-programmitcally by attaching search bar to viewController
//        searchBar.delegate = self
        
        loadItems()
    }

    // Tableview Datasource Method 1
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    // Tableview Datasource Method 2
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TooDooItemCell", for: indexPath)
        
        let item = itemArray[indexPath.row]
        
        // text for current cell is returned
        cell.textLabel?.text = item.title
        
        // Ternary operation ==>
        // value = condition ? valueIfTrue: valueIfFalse
        
        cell.accessoryType = item.done ? .checkmark : .none
        
//        if itemArray[indexPath.row].done == true {
//            cell.accessoryType = .checkmark
//        } else {
//            cell.accessoryType = .none
//        }
        
        return cell
    }
    
    // TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        print(itemArray[indexPath.row])
        
//        //: The order of below matters as there will be an out of range error
//        // delete from database
//        context.delete(itemArray[indexPath.row])
//        // remove from itemArray (used to load up the tableView datasource)
//        itemArray.remove(at: indexPath.row)
        
        
        // sets first side of done property to be opposite (toggle checkmark)
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        // save context
        saveItems()
        
        // after selecting goes back to being white
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // ADD NEW ITEMS
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            
            
            // add new item to tableView
            let newItem = Item(context: self.context)
            newItem.title = textField.text!
            newItem.done = false
            
            // what will happen once user clicks the Add Item button on our UIAlert
            self.itemArray.append(newItem)
            
            self.saveItems()
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    // CREATE/UPDATE
    func saveItems() {
        do {
            // take current state of context (in staging area) and commit it to database (persistent containers)
            try context.save()
        } catch {
           print("Error saving context \(error)")
        }
        // reload tableView and show latest data
        self.tableView.reloadData()
    }
    
    // READ
    // if we call this function and don't provide a value for the request, we can provide a default value (commented code below)
    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest()) { // external param: with, internal: request
//        let request: NSFetchRequest<Item> = Item.fetchRequest()
        do {
            // try using our context (and place into itemArray) to fetch results from persistance store that satisfy the parameters
            itemArray = try context.fetch(request)
        } catch {
            print("Error fetching data from context \(error)")
        }
        // reload tableView so we retrigger the selfforrowatindexpath method and we update tableview with current itemArray
        tableView.reloadData()
    }

}

// MARK: - Search bar methods
extension TooDooListViewController: UISearchBarDelegate {
    
    // Delegate method
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        // query database, return array of items
        let request: NSFetchRequest<Item> = Item.fetchRequest()
        // look for the ones where the title of the item contains this text [case insensitive] and add our query to our request
        request.predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        // sort using the key "title" in alphabetical order and add sort descriptor to our request (expects an array of NSSortDesriptors)
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        // run our request and fetch our results
        loadItems(with: request)
    }
    
    // triggers delegate method with text in searchbar has changed (real-time)
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        // loads whole itemArray once text has gone down to 0
        if searchBar.text?.count == 0 {
            loadItems()
            // ask dispatch queue to get main queue and run method on main queue
            DispatchQueue.main.async {
                // searchBar should no longer have cursor or keyboard (IE goto state before activate)
                searchBar.resignFirstResponder()
            }
        }
    }
    
}

