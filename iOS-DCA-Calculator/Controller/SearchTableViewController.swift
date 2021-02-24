//
//  ViewController.swift
//  iOS-DCA-Calcualtor
//
//  Created by Leon Smith on 20/02/2021.
//

import UIKit
import Combine
import MBProgressHUD

class SearchTableViewController: UITableViewController, UIAnimatable {
    
    private enum Mode {
        case onboarding
        case search
    }
    
    private lazy var searchController: UISearchController  = {
        let sc = UISearchController(searchResultsController: nil)
        sc.delegate = self
        sc.searchResultsUpdater = self
        sc.obscuresBackgroundDuringPresentation = false
        sc.searchBar.placeholder = "Enter company name or symble"
        sc.searchBar.autocapitalizationType = .allCharacters
        return sc
    }()
    
    private let apiService = APIService()
    private var subsribers = Set<AnyCancellable>()
    private var searchResults: SearchResults?
    @Published private var mode: Mode = .onboarding
    @Published private var searchQuery = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupTableView()
        observeForm()
    }

    private func setupNavigationBar() {
        navigationItem.searchController = searchController
        navigationItem.title = "Search"
    }
    
    // Remove TableView Lines
    private func setupTableView() {
        tableView.tableFooterView = UIView()
    }
    
    private func observeForm() {
        
        $searchQuery
            .debounce(for: .milliseconds(750), scheduler: RunLoop.main)
            .sink { [unowned self] (searchQuery) in
                showLoadingAnimation()
                self.apiService.fetchSymbolsPublisher(keywords: searchQuery).sink { (completion) in
//                    guard searchQuery.isEmpty else { return }
                    showHidingAnimation()
                    switch completion {
                        case  .failure(let error):
                            print(error.localizedDescription)
                        case .finished:
                            break
                    }
                } receiveValue: { (searchResults) in
                    self.searchResults = searchResults
                    self.tableView.reloadData()
                    print(searchResults)
                }.store(in: &subsribers)
                print(searchQuery)
            }.store(in: &subsribers)
        
        // Mode Function
        $mode.sink { [unowned self] (mode) in
            switch mode {
                case .onboarding:
                    self.tableView.backgroundView = SearchPlaceholderView()
                case .search:
                    self.tableView.backgroundView = nil
            }
        }.store(in: &subsribers)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults?.items.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath) as! SearchTableViewCell
        if let searchResults = self.searchResults {
            let searchResult  = searchResults.items[indexPath.row]
            cell.configure(with: searchResult)
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showCalculator", sender: nil)
    }

}
  


extension SearchTableViewController: UISearchResultsUpdating, UISearchControllerDelegate {
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchQuery = searchController.searchBar.text, !searchQuery.isEmpty else { return }
        self.searchQuery = searchQuery
    }
    
    func willPresentSearchController(_ searchController: UISearchController) {
        print("willPresentSearchController")
        mode = .search
    }
}

