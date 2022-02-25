//
//  ViewController.swift
//  ToDo List
//
//  Created by Timothy Chin on 2/17/22.
//

import UIKit
import UserNotifications

class ToDoListViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addBarButton: UIBarButtonItem!
    
//    var toDoArray = ["Learn Swift", "Build Apps", "Change the World", "Take a Vacation"]
    
    // empty ToDo list at start
    // var toDoItems: [ToDoItem] = []
    
    // creates an object in that variable
    var toDoItems = ToDoItems()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        //right after data loads
        
        toDoItems.loadData {
            self.tableView.reloadData()
        }
        
        LocalNotificationManager.authorizeLocalNotifications(viewController: self)
    }
    
    
    // creating a DirectoryURL
    func saveData() {
        toDoItems.saveData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "ShowDetail" {
            
            let destination = segue.destination as! ToDoDetailTableViewController
            let selectedIndexPath = tableView.indexPathForSelectedRow!
            destination.toDoItem = toDoItems.itemsArray[selectedIndexPath.row]
            
        } else {
            
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                
                tableView.deselectRow(at: selectedIndexPath, animated: true)
                
            }
            
        }
    }
    
    @IBAction func unwindFromDetail(segue: UIStoryboardSegue) {
        
        let source = segue.source as! ToDoDetailTableViewController
        if let selectedIndexPath = tableView.indexPathForSelectedRow {
            
            toDoItems.itemsArray[selectedIndexPath.row] = source.toDoItem
            tableView.reloadRows(at: [selectedIndexPath], with: .automatic)
            
        } else {
            
            let newIndexPath = IndexPath(row: toDoItems.itemsArray.count, section: 0)
            toDoItems.itemsArray.append(source.toDoItem)
            tableView.insertRows(at: [newIndexPath], with: .bottom)
            tableView.scrollToRow(at: newIndexPath, at: .bottom, animated: true)
            
        }
        saveData()

    }

    @IBAction func editButtonPressed(_ sender: UIBarButtonItem) {
        
        if tableView.isEditing {
            
            tableView.setEditing(false, animated: true)
            sender.title = "Edit"
            addBarButton.isEnabled = true
            
        } else {
            
            tableView.setEditing(true, animated: true)
            sender.title = "Done"
            addBarButton.isEnabled = false
            
        }
        
    }
    
}

extension ToDoListViewController: UITableViewDelegate, UITableViewDataSource, ListTableViewCellDelegate {
    
    func checkBoxToggle(sender: ListTableViewCell) {
        if let selectedIndexPath = tableView.indexPath(for: sender) {
            
            toDoItems.itemsArray[selectedIndexPath.row].completed = !toDoItems.itemsArray[selectedIndexPath.row].completed
            tableView.reloadRows(at: [selectedIndexPath], with: .automatic)
            saveData()
            
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("😎 numberOfRowsInSection was just called. Returning \(toDoItems.itemsArray.count)")
        return toDoItems.itemsArray.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("🚣‍♀️ cellForRowAt was just called for indexPath.row = \(indexPath.row) which is the cell containing \(toDoItems.itemsArray[indexPath.row])")
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ListTableViewCell
        cell.delegate = self
        cell.toDoItem = toDoItems.itemsArray[indexPath.row]
        return cell
        
    }
    // deleting a ToDo List row
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            toDoItems.itemsArray.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            saveData()
            
        }
    }
    // moving the ToDo List rows around
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        
        let itemToMove = toDoItems.itemsArray[sourceIndexPath.row]
        toDoItems.itemsArray.remove(at: sourceIndexPath.row)
        toDoItems.itemsArray.insert(itemToMove, at: destinationIndexPath.row)
        saveData()
        
    }
    
}

