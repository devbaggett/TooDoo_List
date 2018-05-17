//
//  CategoryViewController.swift
//  TooDoo List
//
//  Created by Devin Baggett on 5/16/18.
//  Copyright © 2018 devbaggett. All rights reserved.
//

import UIKit
import CoreData
import SwipeCellKit

class CategoryViewController: UITableViewController {
    // category of category objects
    var categories = [Category]()
    // reference to context we're using to CRUD. Communicates with persistent container
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
    // MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        // fetch data from categories and reload into tableView
        loadCategories()
        
        // increase heigh of cell
        tableView.rowHeight = 80.0
    }
    
    
    // MARK: - TableView Datasource Methods
    
    // returns number of rows equal to items in categories array
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! SwipeTableViewCell
//        cell.delegate = self
//        return cell
//    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // creates reusable cell and adds it to table at indexpath
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath) as! SwipeTableViewCell
        // set cell textlabel.text property to category's name attribute
        cell.textLabel?.text = categories[indexPath.row].name
        
        cell.delegate = self
        // render on screen
        return cell
    }
    
    
    // MARK: - TableView Delegate Methods
    
    // this will trigger when we select one of the cells
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // trigger segue from CategoryViewController (self) to TooDooListViewController
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    
    // before we trigger segue, prepare for segue to TooDooListViewController
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // store reference to (downcast as!) destination view controller
        let destinationVC = segue.destination as! TooDooListViewController
        // grab category that corresponds to selected sell
        if let indexPath = tableView.indexPathForSelectedRow {
            // tap into destinationVC and set property: selectedCategory (created in TooDooListVC)
            destinationVC.selectedCategory = categories[indexPath.row]
        }
    }
    
    
    // MARK: - Data Manipulation Methods
    
    // CREATE/UPDATE
    func saveCategories() {
        // try and commit our context to our persistentContainer (from staging error)
        do {
            try context.save()
        } catch {
            print("Error saving category \(error)")
        }
        // reload tableView to show latest data
        self.tableView.reloadData()
    }
    
    
    // READ
    func loadCategories() {
        // read data from our request, specifying data
        let request: NSFetchRequest<Category> = Category.fetchRequest()
        // try and fetch back results that fit our current request
        do {
            // if succeeds, save output into categories array
            categories = try context.fetch(request)
        } catch {
            print("Error fetching data from context \(error)")
        }
        // reload tableView with latest data from categories
        tableView.reloadData()
    }
    
    
    // MARK: - Add New Categories
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        // alert pop up
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        // what happens when the "add" button is clicked inside the alert
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            // create new category by specifying context
            let newCategory = Category(context: self.context)
            // what user enters into alert is going to be newCategory.name
            newCategory.name = textField.text!
            // append newCategory to Categories array
            self.categories.append(newCategory)
            // save context
            self.saveCategories()
        }
        // add action we just created
        alert.addAction(action)
        // set up our textField storing reference in var textField
        alert.addTextField { (field) in
            textField = field
            textField.placeholder = "Add a new category"
        }
        present(alert, animated: true, completion: nil)
    }
    
}

// MARK: - Swipe Cell Delegate Methods

extension CategoryViewController: SwipeTableViewCellDelegate {
    
    // required delegate method
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }
        
        // DELETE
        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
            // handle action by updating model with deletion
            self.context.delete(self.categories[indexPath.row])
            // remove from categories array (used to load up the tableView datasource)
            self.categories.remove(at: indexPath.row)
            // save context
//            self.saveCategories()
            // reload tableView
//            tableView.reloadData()
        }
        
        // customize the action appearance
        deleteAction.image = UIImage(named: "delete_icon")
        
        
        return [deleteAction]
    }
    
    
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeTableOptions {
        var options = SwipeTableOptions()
        options.expansionStyle = .destructive
        
        return options
    }
    
}
