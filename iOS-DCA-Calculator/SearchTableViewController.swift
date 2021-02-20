//
//  ViewController.swift
//  iOS-DCA-Calcualtor
//
//  Created by Leon Smith on 20/02/2021.
//

import UIKit

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

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
    }

    private func setupNavigationBar() {
        navigationItem.searchController = searchController
    }

}

extension SearchTableViewController: UISearchResultsUpdating, UISearchControllerDelegate {
    func updateSearchResults(for searchController: UISearchController) {
        
    }
    
    
}

