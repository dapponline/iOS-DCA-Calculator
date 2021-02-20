//
//  APIService.swift
//  iOS-DCA-Calculator
//
//  Created by Leon Smith on 20/02/2021.
//

import Foundation
import Combine

struct APIService {
    
    let keys = ["TFKL4CBIBME9PQLW","CWT3LHKVNIH42Z8P","2CLRJG6UW1MOKOL0","U5F35G0YHOVBYFZM"]
    
    var API_KEY: String {
        return keys.randomElement() ?? ""
    }
    
    func fetchSymbolsPublisher(keywords: String) -> AnyPublisher<SearchResults, Error> {
        let urlString = "https://www.alphavantage.co/query?function=SYMBOL_SEARCH&keywords=\(keywords)&apikey=\(API_KEY)"
        
        let url = URL(string: urlString)!
        
        return URLSession.shared.dataTaskPublisher(for: url)
            .map ({ $0.data })
            .decode(type: SearchResults.self, decoder: JSONDecoder())
            .receive(on: RunLoop.main)
            .eraseToAnyPublisher()
    }
    
    
}
