//
//  ViewController.swift
//  TooDoo List
//
//  Created by Devin Baggett on 5/16/18.
//  Copyright © 2018 devbaggett. All rights reserved.
//

import UIKit

class TooDooListViewController: UITableViewController {
    
    let itemArray = ["cure headache", "kill mosquito", "get laid"]

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // Tableview Datasource Method 1
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    // Tableview Datasource Method 2
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TooDooItemCell", for: indexPath)
        
        // text for current cell is returned
        cell.textLabel?.text = itemArray[indexPath.row]
        
        return cell
    }
    
    // TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        print(itemArray[indexPath.row])
        
        // grabbing reference for a cell that is indexpath and adding checkmark whenever cell is selected
        // if already checked, deselect
        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        } else {
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
        
        
        
        // after selecting goes back to being white
        tableView.deselectRow(at: indexPath, animated: true)
    }


}

