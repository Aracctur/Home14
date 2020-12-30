//
//  AFViewController.swift
//  Home14
//
//  Created by Maxim Chalikov on 28.12.2020.
//

import UIKit
import Alamofire
import RealmSwift

class CurrentWeatherModel: NSObject, NSCoding {
    
    let tempString: String
    let feelsLikeString: String
    let tempMinString: String
    let tempMaxString: String
    
    init(tempString: String, feelsLikeString: String, tempMinString: String, tempMaxString: String) {
        self.tempString = tempString
        self.feelsLikeString = feelsLikeString
        self.tempMinString = tempMinString
        self.tempMaxString = tempMaxString
    }
    func encode(with coder: NSCoder) {
        coder.encode(tempString, forKey: "tempString")
        coder.encode(feelsLikeString, forKey: "feelsLikeString")
        coder.encode(tempMinString, forKey: "tempMinString")
        coder.encode(tempMaxString, forKey: "tempMaxString")
    }
    required init?(coder: NSCoder) {
        tempString = coder.decodeObject(forKey: "tempString") as! String
        feelsLikeString = coder.decodeObject(forKey: "feelsLikeString") as! String
        tempMaxString = coder.decodeObject(forKey: "tempMaxString") as! String
        tempMinString = coder.decodeObject(forKey: "tempMinString") as! String
    }
}

class CurrentWeatherSettings {
    
    private enum SettingsKeys: String {
        case currentWeatherModel
    }
    static var currentWeatherModel: CurrentWeatherModel!{
        get {
            guard let saveData = UserDefaults.standard.object(forKey: SettingsKeys.currentWeatherModel.rawValue) as? Data, let decodedModel = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(saveData) as? CurrentWeatherModel else {return nil}
            return decodedModel
            }
        set {
            let defaults = UserDefaults.standard
            let key = SettingsKeys.currentWeatherModel.rawValue
            if let userModel = newValue {
                if let saveData = try? NSKeyedArchiver.archivedData(withRootObject: userModel, requiringSecureCoding: false) {
                    defaults.setValue(saveData, forKey: key)
                }
            }
        }
    }
}

class ForecastWeatherRealm: Object {
    @objc dynamic var dtString = ""
    @objc dynamic var temp = -100.0
    @objc dynamic var descriptString = ""
}


class AFViewController: UIViewController {
    private let realm = try! Realm()
    var forecastRealmList: Results<ForecastWeatherRealm> {
        get {
            return realm.objects(ForecastWeatherRealm.self)
        }
    }
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var feelsLikeLabel: UILabel!
    @IBOutlet weak var tempMinLabel: UILabel!
    @IBOutlet weak var tempMaxLabel: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    
    var forecastsWeatcher:[ForecastWeather] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if (CurrentWeatherSettings.currentWeatherModel != nil) {
        self.tempLabel.text? = "🌐" +  CurrentWeatherSettings.currentWeatherModel.tempString
        self.feelsLikeLabel.text? = CurrentWeatherSettings.currentWeatherModel.feelsLikeString
        self.tempMinLabel.text? = CurrentWeatherSettings.currentWeatherModel.tempMinString
        self.tempMaxLabel.text? = CurrentWeatherSettings.currentWeatherModel.tempMaxString
        }
        
        if forecastRealmList.count != 0 {
            forecastsWeatcher = []
            for forecastWeatherRealm in forecastRealmList{
                let forecastWeather = ForecastWeather(dtString: forecastWeatherRealm.dtString, temp: forecastWeatherRealm.temp, description: forecastWeatherRealm.descriptString)
                forecastWeather?.dtString = "🌐" + forecastWeatherRealm.dtString
                forecastWeather?.temp = forecastWeatherRealm.temp
                forecastWeather?.description = forecastWeatherRealm.descriptString                
                forecastsWeatcher.append(forecastWeather!)
            }
            tableView.reloadData()
            print(forecastRealmList.count)
        }
        
        AFWeatherLoader().loadCurrentWeather { currentWeather in
                    self.tempLabel.text = currentWeather.tempString
                    self.feelsLikeLabel.text = currentWeather.feelsLikeString
                    self.tempMinLabel.text = currentWeather.tempMinString
                    self.tempMaxLabel.text = currentWeather.tempMaxString
        }
        

        AFWeatherLoader().loadForecastWeather { forecastsWeather in
            self.forecastsWeatcher = forecastsWeather
            self.tableView.reloadData()
            
            try! self.realm.write({
                self.realm.delete(self.forecastRealmList)
            })
            
            for forecastWeather in self.forecastsWeatcher {
                let forecastWeatherRealm = ForecastWeatherRealm()
                forecastWeatherRealm.dtString = forecastWeather.dtString
                forecastWeatherRealm.temp = forecastWeather.temp
                forecastWeatherRealm.descriptString = forecastWeather.description
                try! self.realm.write({
                    self.realm.add(forecastWeatherRealm)
                })
            }
        }
    }
}
class AFForecastWeatherCell: UITableViewCell {

    @IBOutlet weak var forecastDataLabel: UILabel!
    @IBOutlet weak var forecastTempLabel: UILabel!
    @IBOutlet weak var forecastSkyLabel: UILabel!
}

extension AFViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return forecastsWeatcher.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AFForecastWeatherCell", for: indexPath) as! AFForecastWeatherCell
        let forecast = forecastsWeatcher[indexPath.row]
        cell.forecastDataLabel.text = forecast.dtString
        cell.forecastTempLabel.text = forecast.tempString
        cell.forecastSkyLabel.text = forecast.description
        return cell
    }
}


class AFWeatherLoader {
    
    let urlCurrentString = "https://api.openweathermap.org/data/2.5/weather?q=Moscow&appid=a037590ae0bbc053909da59e518e5022&units=metric"

    func loadCurrentWeather(completion:@escaping(CurrentWeather) -> Void){
        AF.request(urlCurrentString).responseJSON { response in
            if let objects = response.data{
                let currentWeatherData = try! JSONDecoder().decode(CurrentWeatherData.self, from: objects)
                let currentWeather = CurrentWeather(currentWeatherData: currentWeatherData)!
                let tempString = currentWeather.tempString
                let feelsLikeString = currentWeather.feelsLikeString
                let tempMinString = currentWeather.tempMinString
                let tempMaxString = currentWeather.tempMaxString
                let currentWeatherObject = CurrentWeatherModel(tempString: tempString, feelsLikeString: feelsLikeString, tempMinString: tempMinString, tempMaxString: tempMaxString)
                CurrentWeatherSettings.currentWeatherModel = currentWeatherObject
                
                
                
                DispatchQueue.main.async {
                    completion(currentWeather)
                }
            }
        }
    }
    
    let urlForecastString = "https://api.openweathermap.org/data/2.5/forecast?q=Moscow&units=metric&appid=a037590ae0bbc053909da59e518e5022&lang=ru"
    
    func loadForecastWeather(completion: @escaping([ForecastWeather])-> Void){
        AF.request(urlForecastString).responseJSON { response in
            if let objects = response.value,
               let jsonDict = objects as? NSDictionary,
               let jsonArray = jsonDict["list"] as? NSArray {
                var forecastsWeather:[ForecastWeather] = []
                for data in jsonArray where data is NSDictionary{
                    if let forecastWeather = ForecastWeather(data: data as! NSDictionary){
                        forecastsWeather.append(forecastWeather)
                    }
                }
                DispatchQueue.main.async {
                                   completion(forecastsWeather)
                }
            }
        }
    }
}

