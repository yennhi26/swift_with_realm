//
//  ViewController.swift
//  TodoList
//
//  Created by Halo on 25/05/2021.
//

import UIKit
import RealmSwift

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    // Realm
    let realm = try! Realm()
    
    var todoList: Results<TodoItem> {
        get {
            print(realm.objects(TodoItem.self))
            return realm.objects(TodoItem.self)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Register table
        tableView.dataSource = self
        tableView.delegate = self
        tableView.reloadData()
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
    }
    
    // Table view
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        let item = todoList[indexPath.row]
            
        cell.textLabel!.text = item.detail
        
        let accessory: UITableViewCell.AccessoryType = (item.status != 0) ? .checkmark : .none
        
        cell.accessoryType = accessory
        
        return cell
    
      }
      
      func numberOfSections(in tableView: UITableView) -> Int {
        return 1
      }

      func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoList.count
      }
    
    
    // Add new
    
    @IBAction func addNew(sender: AnyObject) {

        let alertController : UIAlertController = UIAlertController(title: "New Todo", message: "What do you plan to do?", preferredStyle: .alert)
        
        alertController.addTextField { (UITextField) in

        }

        let action_cancel = UIAlertAction.init(title: "Cancel", style: .cancel) { (UIAlertAction) -> Void in

        }
        alertController.addAction(action_cancel)

        let action_add = UIAlertAction.init(title: "Add", style: .default) { (UIAlertAction) -> Void in
            
            let textField_todo = (alertController.textFields?.first)! as UITextField
            
            print("You entered \(String(describing: textField_todo.text))")
            
            let todoItem = TodoItem()
            
            todoItem.detail = textField_todo.text!
            
            todoItem.status = 0
            
            try! self.realm.write({
                self.realm.add(todoItem)
                
                self.tableView.insertRows(at: [IndexPath.init(row: self.todoList.count-1, section: 0)], with: .automatic)
            })
        }
        alertController.addAction(action_add)

        present(alertController, animated: true, completion: nil)

    }
    
    
    // Toggle status
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = todoList[indexPath.row]
        try! self.realm.write({
            if (item.status == 0){
                item.status = 1
            }else{
                item.status = 0
            }
        })
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
    
    
    // Delete
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {

        if (editingStyle == .delete){
            let item = todoList[indexPath.row]
            try! self.realm.write({
                self.realm.delete(item)
            })

            tableView.deleteRows(at:[indexPath], with: .automatic)

        }
    }
}

