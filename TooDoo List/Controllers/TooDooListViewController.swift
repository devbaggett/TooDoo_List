//
//  ViewController.swift
//  TooDoo List
//
//  Created by Devin Baggett on 5/16/18.
//  Copyright © 2018 devbaggett. All rights reserved.
//

import UIKit

class TooDooListViewController: UITableViewController {
    
    var itemArray = [Item]()
    
    let defaults = UserDefaults.standard

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let newItem = Item()
        newItem.title = "cure headache"
        itemArray.append(newItem)
        
        let newItem2 = Item()
        newItem2.title = "kill mosquito"
        itemArray.append(newItem2)
        
        let newItem3 = Item()
        newItem3.title = "get laid"
        itemArray.append(newItem3)
        
        
        
        
        // add plist items to itemArray
        if let items = defaults.array(forKey: "TooDooListArray") as? [Item] {
            itemArray = items
        }
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
        
        // sets first side of done property to be opposite
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        tableView.reloadData()
        
        // after selecting goes back to being white
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // ADD NEW ITEMS
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            
            let newItem = Item()
            newItem.title = textField.text!
            
            // what will happen once user clicks the Add Item button on our UIAlert
            self.itemArray.append(newItem)
            
            self.defaults.set(self.itemArray, forKey: "TooDooListArray")
            
            // reload tableView after appending item
            self.tableView.reloadData()
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    

}

