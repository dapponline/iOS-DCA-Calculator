//
//  ViewController.swift
//  iOS-DCA-Calcualtor
//
//  Created by Leon Smith on 20/02/2021.
//

import UIKit
import Combine

class SearchTableViewController: UITableViewController {
    
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
    @Published private var searchQuery = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        observeForm()
    }

    private func setupNavigationBar() {
        navigationItem.searchController = searchController
    }
    
    private func observeForm() {
        $searchQuery.debounce(for: .milliseconds(750), scheduler: RunLoop.main)
            .sink { [unowned self] (searchQuery) in
                self.apiService.fetchSymbolsPublisher(keywords: searchQuery).sink { (completion) in
                    switch completion {
                        case  .failure(let error):
                            print(error.localizedDescription)
                        case .finished:
                            break
                    }
                } receiveValue: { (searchResults) in
                    print(searchResults)
                }.store(in: &subsribers)
                print(searchQuery)
            }.store(in: &subsribers)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath)
        return cell
    }
    


}

extension SearchTableViewController: UISearchResultsUpdating, UISearchControllerDelegate {
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchQuery = searchController.searchBar.text, !searchQuery.isEmpty else { return }
        self.searchQuery = searchQuery
    }
    
    
}

