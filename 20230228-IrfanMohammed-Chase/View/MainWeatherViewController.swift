//
//  MainWeatherViewController.swift
//  20230228-IrfanMohammed-Chase
//
//  Created by Irfan Mohammed on 2/28/23.
//

import UIKit
import CoreData
import CoreLocation

class MainWeatherViewController: UIViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    lazy var activityIndicator: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.large)
        view.center = CGPoint(x: self.view.bounds.size.width/2, y: self.view.bounds.size.height/2)
        view.layer.zPosition = 1
        return view
    }()
    
    var showIndicator: Bool = false {
        willSet {
            newValue ? activityIndicator.startAnimating() : activityIndicator.stopAnimating()
        }
    }
    
    // Core Data to store the last location enter by user
    var location: [Location]?
    var locationManager: CLLocationManager?
    var weatherData: WeatherModel?
    
    // City Name
    var cityName = ""
    
    // Core Data is Empty
    var isCoreDataEmpty: Bool {
        do {
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Location")
            let count  = try context.count(for: request)
            return count == 0
        } catch {
            return true
        }
    }
    
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var serviceProvider = ViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = ViewConstants.title.rawValue
        self.view.addSubview(activityIndicator)
        tableView.delegate = self
        tableView.dataSource = self
        
        // Fetch saved data from core data
        fetchLocation()
        showIndicator = true
        searchBar.delegate = self
        searchBar.resignFirstResponder()
        searchBar.searchBarStyle = .minimal
        searchBar.placeholder = "Search Location"
        
        tableView.register(UINib(nibName: "\(CurrentTableViewCell.self)", bundle: nil), forCellReuseIdentifier: ViewConstants.currentCell.rawValue)
        
        tableView.register(UINib(nibName: "\(HourlyTableViewCell.self)", bundle: nil), forCellReuseIdentifier: ViewConstants.hourCell.rawValue)
        
        //serviceProvider.controller = self
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            if self.isCoreDataEmpty {
                self.getCurrentLocation()
            } else {
                self.fetchLastSavedLocation()
            }
        }
    }
    
    // Get Current Location Data
    func getCurrentLocation() {
        locationManager = CLLocationManager()
        // Make sure to set the delegate, to get the call back when the user taps Allow option
        locationManager?.delegate = self
        locationManager?.requestWhenInUseAuthorization()
        if (CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedWhenInUse ||
            CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedAlways){
            guard let currentLocation = locationManager?.location else {
                return
            }
            getCityName(latitude: currentLocation.coordinate.latitude, longitude: currentLocation.coordinate.longitude)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.serviceProvider.getCurrentCityResult(lat: currentLocation.coordinate.latitude, lon: currentLocation.coordinate.longitude, completion: { [weak self] (results) in
                    
                    switch results {
                    case .success(let response):
                        guard let self = self else { return }
                        self.weatherData = response.modelObject
                        self.tableView.reloadData()
                        self.showIndicator = false
                    case .failure(let response):
                        self?.showErrorAlert(response.error.localizedDescription)
                        return
                    }
                })
            }
        }
    }
    
    func getCityName(latitude: Double, longitude: Double) {
        let location = CLLocation(latitude: latitude, longitude: longitude)
        location.placemark { placemark, error in
            guard let placemark = placemark else { return }
            self.setupCity(name: placemark.locality ?? "")
        }
    }
    
    /// Present to Search location screen
    func presentLocationSearchView() {
        let storyBoard : UIStoryboard = UIStoryboard(name: ViewConstants.main.rawValue, bundle:nil)
        let searchLocationVc = storyBoard.instantiateViewController(withIdentifier: ViewConstants.searchIdentifier.rawValue) as! SearchViewController
        searchLocationVc.delegate = self
        self.present(searchLocationVc, animated:true, completion:nil)
    }
    
    func fetchLastSavedLocation() {
        self.showIndicator = true
        getCityData(self.location?.last?.name ?? "")
    }
}

// MARK: AddCitiesProviding
extension MainWeatherViewController: AddCitiesProviding {
    /// Make service call to fetch city weather detail by using city name from Search screen
    /// - Parameter city: String
    func getCityData(_ city: String) {
        serviceProvider.addCitiesResults(city: city, completion: { [weak self] (results) in
            switch results {
            case .success(let response):
                let result = response.modelObject
                guard let self = self else { return }
                let newLocation = Location(context: self.context)
                newLocation.country = result.sys.country
                newLocation.name = result.name ?? ""
                newLocation.tempType = result.weather[0].description.capitalized
                newLocation.temp = result.main.temp
                newLocation.latitude = result.coord?.lat ?? 0.0
                newLocation.longitude = result.coord?.lon ?? 0.0
                newLocation.currentDate = Double(result.dt)
                self.saveData()
                self.showIndicator = true
                self.setupCity(name: newLocation.name ?? "")
                self.serviceProvider.getCurrentCityResult(lat: newLocation.latitude, lon: newLocation.longitude, completion: { [weak self] (results) in
                    switch results {
                    case .success(let response):
                        guard let self = self else { return }
                        self.weatherData = response.modelObject
                        self.tableView.reloadData()
                        self.showIndicator = false
                    case .failure(let response):
                        self?.showErrorAlert(response.error.localizedDescription)
                    }
                })
            case .failure(let response):
                self?.showErrorAlert(response.error.localizedDescription)
            }
        })
    }
    
    func setupCity(name: String) {
        cityName = name
        tableView.reloadData()
    }
    
    func showErrorAlert(_ message: String) {
        let alert = UIAlertController(title: "Sorry Please try Agin Later", message: message, preferredStyle: UIAlertController.Style.alert)
        let cancelAction: UIAlertAction = UIAlertAction(title: "OK", style: .cancel) {_ in
            self.tableView.isHidden = true
        }
        alert.addAction(cancelAction)
        DispatchQueue.main.async {
            self.present(alert, animated: true)
        }
    }

}

// MARK: Serach Bar
extension MainWeatherViewController: UISearchBarDelegate {
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        presentLocationSearchView()
        return false
    }
}


// MARK: UITableViewDelegate
extension MainWeatherViewController: UITableViewDelegate {
    func tableView( _ tableView : UITableView,  titleForHeaderInSection section: Int) -> String? {
        switch(section) {
        case 1: return ViewConstants.hourForecast.rawValue
        default: return ""
        }
    }
}

// MARK: UITableViewDataSource
extension MainWeatherViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch(section) {
        case 1: return weatherData?.hourly.count ?? 0
        default: return 0
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: ViewConstants.currentCell.rawValue, for: indexPath) as! CurrentTableViewCell
            cell.data = weatherData
            cell.cityName.text = cityName
            cell.selectionStyle = .none
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: ViewConstants.hourCell.rawValue, for: indexPath) as! HourlyTableViewCell
            cell.data = weatherData?.hourly[indexPath.row]
            cell.selectionStyle = .none
            return cell
        }
    }
}

// MARK: Core Location
extension MainWeatherViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined:
            print("determine")
        case .restricted, .denied:  print("restricted")
        case .authorizedAlways, .authorizedWhenInUse:
            getCurrentLocation()
        @unknown default: break
        }
    }
}

// MARK: Core Data
extension MainWeatherViewController {
    /// Fetch saved data from core data
    func fetchLocation() {
        do {
            self.location = try context.fetch(Location.fetchRequest())
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        } catch let err as NSError {
            print(err.debugDescription)
        }
    }
    
    /// Save data to Core data
    func saveData() {
        do {
            try self.context.save()
        } catch let err as NSError {
            print(err.debugDescription)
        }
    }
}

