//
//  ViewController.swift
//  HomeWork14
//
//  Created by Maxim Chalikov on 17.12.2020.
//

import UIKit

class UserModel: NSObject, NSCoding {
    
    let name: String
    let surname: String
    
    init(name: String, surname: String) {
        self.name = name
        self.surname = surname
    }
    
    func encode(with coder: NSCoder) {
        coder.encode(name, forKey: "name")
        coder.encode(surname, forKey: "surname")
    }
    
    required init?(coder: NSCoder) {
        name = coder.decodeObject(forKey: "name") as! String
        surname = coder.decodeObject(forKey: "surname") as! String
    }
}

class UserSettings {
    
    private enum SettingsKeys: String {
        case userModel
    }
    static var userModel: UserModel!{
        get {
            guard let saveData = UserDefaults.standard.object(forKey: SettingsKeys.userModel.rawValue) as? Data, let decodedModel = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(saveData) as? UserModel else {return nil}
            return decodedModel
        }
        set {
            let defaults = UserDefaults.standard
            let key = SettingsKeys.userModel.rawValue
            
            if let userModel = newValue {
                if let saveData = try? NSKeyedArchiver.archivedData(withRootObject: userModel, requiringSecureCoding: false) {
                    defaults.setValue(saveData, forKey: key)
                }
            }
        }
    }
}

class ViewController: UIViewController {
    
    @IBOutlet weak var surnameTextField: UITextField!
  
    @IBAction func surnameTextField(_ sender: Any) {
    }
    @IBOutlet weak var nameTextField: UITextField!
    
    @IBAction func nameTextField(_ sender: Any) {
    }
    
    @IBAction func saveButton(_ sender: Any) {
        if surnameTextField.text != "", nameTextField.text != "" {
            let surnameTxt = surnameTextField.text!.trimmingCharacters(in: .whitespaces)
            let nameTxt = nameTextField.text!.trimmingCharacters(in: .whitespaces)
            
            let userObject = UserModel (name: nameTxt, surname: surnameTxt)
            print(userObject)
            UserSettings.userModel = userObject

            print(UserSettings.userModel as Any)
            
        } else {return}
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        surnameTextField.text = UserSettings.userModel?.surname
        nameTextField.text = UserSettings.userModel?.name
    }


}



