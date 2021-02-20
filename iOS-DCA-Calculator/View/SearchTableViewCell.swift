//
//  SearchTableViewCell.swift
//  iOS-DCA-Calculator
//
//  Created by Leon Smith on 20/02/2021.
//

import UIKit

class SearchTableViewCell: UITableViewCell {
    
    @IBOutlet weak var assetNameLabel:UILabel!
    @IBOutlet weak var assetSymbolLabel:UILabel!
    @IBOutlet weak var assetTypeLabel:UILabel!
    
    func configure(with searchResult: SearchResult) {
        assetNameLabel.text = searchResult.name
        assetSymbolLabel.text = searchResult.symbol
        assetTypeLabel.text = searchResult.type
            .appending("")
            .appending(searchResult.currency)
    }
    
}
