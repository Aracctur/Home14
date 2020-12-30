//
//  RealmViewController.swift
//  HomeWork14
//
//  Created by Maxim Chalikov on 19.12.2020.
//

import UIKit
import RealmSwift

class Task: Object{
    @objc dynamic var name = ""
    @objc dynamic var isCompleted = false
}

class RealmViewController: UITableViewController {
    
    private let realm = try! Realm()
    
    var taskList: Results<Task> {
        get {
            return realm.objects(Task.self)
        }
    }
    
    @IBOutlet weak var addTaskButton: UIBarButtonItem!
    @IBAction func addTaskButton(_ sender: Any) {
        
        let alertVC : UIAlertController = UIAlertController(title: "Что надо сделать?", message: nil, preferredStyle: .alert)
        
            alertVC.addTextField { UITextField in}
     
        let cancelAction = UIAlertAction.init(title: "Отмена", style: .destructive, handler: nil)
        alertVC.addAction(cancelAction)
     
        let addAction = UIAlertAction.init(title: "Добавить", style: .default) { (UIAlertAction) -> Void in
     
            let textFieldTask = (alertVC.textFields?.first)! as UITextField
     
            let task = Task()
                
            if textFieldTask.text != "" {
                task.name = textFieldTask.text!
                task.isCompleted = false
     
            try! self.realm.write({
                self.realm.add(task)
                self.tableView.insertRows(at: [IndexPath.init(row: self.taskList.count-1, section: 0)], with: .automatic)
                    })
                } else {return}
            }
            alertVC.addAction(addAction)
            present(alertVC, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return taskList.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let task = taskList[indexPath.row]
        cell.textLabel!.text = task.name
        cell.textLabel!.text = task.isCompleted == false ? cell.textLabel!.text : ("✅   " + cell.textLabel!.text!)
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let task = taskList[indexPath.row]
        try! self.realm.write({
                    task.isCompleted = !task.isCompleted
                })
                tableView.reloadRows(at: [indexPath], with: .automatic)
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let task = taskList[indexPath.row]
            try! self.realm.write({
                self.realm.delete(task)
            })
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
}
