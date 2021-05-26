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
        
        cell.detailTextLabel!.text = "\(item.status)"
            
        return cell
    
      }
      
      func numberOfSections(in tableView: UITableView) -> Int {
        return todoList.count
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
}

