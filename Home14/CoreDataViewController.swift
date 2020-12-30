//
//  CoreDataViewController.swift
//  HomeWork14
//
//  Created by Maxim Chalikov on 22.12.2020.
//

import UIKit
import CoreData

class TaskModel {
    var name = ""
    var isCompleted = false
}

class CoreDataViewController: UITableViewController {
    
    private func getContext() -> NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
    
    var taskList2:[Task2] {
        get {
            let context = getContext()
            let fetchRequest:NSFetchRequest<Task2> = Task2.fetchRequest()
            return try! context.fetch(fetchRequest)
        }
        set {}
    }
    
    @IBOutlet weak var addTaskButton: UIBarButtonItem!
    @IBAction func addTaskButton(_ sender: Any) {
        
        let alertVC : UIAlertController = UIAlertController(title: "Что надо сделать?", message: nil, preferredStyle: .alert)
        
            alertVC.addTextField { UITextField in}
     
        let cancelAction = UIAlertAction.init(title: "Отмена", style: .destructive, handler: nil)
     
            alertVC.addAction(cancelAction)
     
            let addAction = UIAlertAction.init(title: "Добавить", style: .default) { (UIAlertAction) -> Void in
     
                let textFieldTask = (alertVC.textFields?.first)! as UITextField
                
                let task = TaskModel()
                
                if textFieldTask.text != "" {
                    task.name = textFieldTask.text!
                    task.isCompleted = false
                    
                    self.addTask(with: task)
     
                    self.tableView.insertRows(at: [IndexPath.init(row: self.taskList2.count-1, section: 0)], with: .fade)

                } else {return}
            }
            alertVC.addAction(addAction)
            present(alertVC, animated: true, completion: nil)
    }
    
    private func addTask(with model: TaskModel) {
        
        let context = getContext()
        
        guard let entity = NSEntityDescription.entity(forEntityName: "Task2", in: context) else {return}
        let taskObject = Task2(entity: entity, insertInto: context)
        
        taskObject.name = model.name
        taskObject.isCompleted = model.isCompleted
        
        do {
            try context.save()
            self.taskList2.append(taskObject)
        } catch let error as NSError {
            print(error.localizedDescription)            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return taskList2.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let task = taskList2[indexPath.row]
        cell.textLabel!.text = task.name
        cell.textLabel!.text = task.isCompleted == false ? cell.textLabel!.text : ("✅   " + cell.textLabel!.text!)
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let context = getContext()

        taskList2[indexPath.row].isCompleted = !taskList2[indexPath.row].isCompleted
        try! context.save()
        
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        let context = getContext()

        if editingStyle == .delete {
            let task = taskList2[indexPath.row]
            context.delete(task)
            try! context.save()
            tableView.deleteRows(at: [indexPath], with: .automatic)

        }
    }
}

