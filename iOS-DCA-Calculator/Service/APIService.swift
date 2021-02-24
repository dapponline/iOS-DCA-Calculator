//
//  APIService.swift
//  iOS-DCA-Calculator
//
//  Created by Leon Smith on 20/02/2021.
//

import Foundation
import Combine

struct APIService {
    
    enum APIServiceError: Error {
        case encoding
        case badRequest
    }
    
    let keys = ["TFKL4CBIBME9PQLW","CWT3LHKVNIH42Z8P","2CLRJG6UW1MOKOL0","U5F35G0YHOVBYFZM"]
    
    var API_KEY: String {
        return keys.randomElement() ?? ""
    }
    
    func fetchSymbolsPublisher(keywords: String) -> AnyPublisher<SearchResults, Error> {
        
        let result = parseQueryString(text: keywords)
        
        var symbol = String()
        
        switch result {
            case .success(let query):
                symbol = query
            case .failure(let error):
                return Fail(error: error).eraseToAnyPublisher()
        }
        
        
        let urlString = "https://www.alphavantage.co/query?function=SYMBOL_SEARCH&keywords=\(symbol)&apikey=\(API_KEY)"
        
        let urlResult = parseUrl(urlString: urlString)
        
        switch urlResult {
            case .success(let url):
                return URLSession.shared.dataTaskPublisher(for: url)
                    .map ({ $0.data })
                    .decode(type: SearchResults.self, decoder: JSONDecoder())
                    .receive(on: RunLoop.main)
                    .eraseToAnyPublisher()
            case .failure(let error):
                return Fail(error: error).eraseToAnyPublisher()
        }
    }
    
    func fetcchTimerSeriesAdjustPublisher(keywords: String) -> AnyPublisher<TimeSeriesMonthlyAdjusted, Error> {
        
        let result = parseQueryString(text: keywords)
        
        var symbol = String()
        
        switch result {
            case .success(let query):
                symbol = query
            case .failure(let error):
                return Fail(error: error).eraseToAnyPublisher()
        }
        
        let urlString = "https://www.alphavantage.co/query?function=TIME_SERIES_MONTHLY_ADJUSTED&symbol=\(symbol)&apikey=\(API_KEY)"
        
        let urlResult = parseUrl(urlString: urlString)
        
        switch urlResult {
            case .success(let url):
                return URLSession.shared.dataTaskPublisher(for: url)
                    .map ({ $0.data })
                    .decode(type: TimeSeriesMonthlyAdjusted.self, decoder: JSONDecoder())
                    .receive(on: RunLoop.main)
                    .eraseToAnyPublisher()
            case .failure(let error):
                return Fail(error: error).eraseToAnyPublisher()
        }
    }
    
    private func parseQueryString(text: String) -> Result<String, Error> {
        if let query = text.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) {
            return .success(query)
        } else {
            return .failure(APIServiceError.encoding)
        }
    }
    
    private func parseUrl(urlString: String) -> Result<URL, Error> {
        if let  url = URL(string: urlString) {
            return  .success(url)
        } else {
            return .failure(APIServiceError.badRequest)
        }
    }
    
}
