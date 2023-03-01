//
//  MainWeatherController+CoreData.swift
//  20230228-IrfanMohammed-Chase
//
//  Created by Irfan Mohammed on 2/28/23.
//

import UIKit
import CoreData

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


