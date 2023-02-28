//
//  SearchViewController.swift
//  20230228-IrfanMohammed-Chase
//
//  Created by Irfan Mohammed on 2/28/23.
//

import UIKit
import MapKit

class SearchViewController: UIViewController, UISearchBarDelegate, MKLocalSearchCompleterDelegate {
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var searchResultsTable: UITableView!
    
    // Create a search completer object
    private var searchCompleter = MKLocalSearchCompleter()
    weak var delegate: AddCitiesProviding?
    // These are the results that are returned from the searchCompleter & what we are displaying
    // on the searchResultsTable
    private var searchResults = [MKLocalSearchCompletion]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Set up the delegates & the dataSources of both the search bar & searchResultsTableView
        searchCompleter.delegate = self
        searchBar?.delegate = self
        searchResultsTable?.delegate = self
        searchResultsTable?.dataSource = self
        searchBar?.showsCancelButton = true
        searchBar?.becomeFirstResponder()
        addGestureToDismissKeyBoard()
    }
    
    // Calls this function when the tap is recognized.
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
        enableCancelBtn()
    }
    
    func enableCancelBtn() {
        if let cancelButton = searchBar?.value(forKey: "cancelButton") as? UIButton {
            cancelButton.isEnabled = true
        }
    }
    
    func addGestureToDismissKeyBoard() {
        // Looks for single or multiple taps.
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        // Uncomment the line below if you want the tap not to interfere and cancel other interactions.
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        
    }
    
    // This method declares that whenever the text in the searchbar is change to also update
    // the query that the searchCompleter will search based off of
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchCompleter.queryFragment = searchText
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        dismiss(animated: true, completion: nil)
    }
    
    // This method declares gets called whenever the searchCompleter has new search results
    // If you wanted to do any filter of the locations that are displayed on the the table view
    // this would be the place to do it.
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        
        // Setting our searchResults variable to the results that the searchCompleter returned
        searchResults = completer.results
        
        // Reload the tableview with our new searchResults
        searchResultsTable.reloadData()
    }
    
    // This method is called when there was an error with the searchCompleter
    func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
        // Error
    }
}

// MARK: UITableViewDataSource
// Setting up extensions for the table view
extension SearchViewController: UITableViewDataSource {
    // This method declares the number of sections that we want in our table.
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    // This method declares how many rows are the in the table
    // We want this to be the number of current search results that the
    // Completer has generated for us
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    // This method declares the cells that are table is going to show at a particular index
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Get the specific searchResult at the particular index
        let searchResult = searchResults[indexPath.row]
        
        // Create  a new UITableViewCell object
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
        
        // Set the content of the cell to our searchResult data
        cell.textLabel?.text = searchResult.title
        cell.detailTextLabel?.text = searchResult.subtitle
        return cell
    }
}

// MARK: UITableViewDelegate
extension SearchViewController: UITableViewDelegate {
    // This method declares the behavior of what is to happen when the row is selected
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let result = searchResults[indexPath.row]
        let searchRequest = MKLocalSearch.Request(completion: result)
        
        let search = MKLocalSearch(request: searchRequest)
        search.start { (response, error) in
            // City Name
            guard let name = response?.mapItems[0].name else { return }
            
            self.dismiss(animated: true) {
                // Navigate to Initial view controller to display city weather details
                self.delegate?.getCityData(name)
            }
        }
    }
}

