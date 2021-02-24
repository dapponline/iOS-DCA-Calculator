//
//  TimeSeriesMonthlyAdjusted.swift
//  iOS-DCA-Calculator
//
//  Created by Leon Smith on 24/02/2021.
//

import Foundation

struct TimeSeriesMonthlyAdjusted: Decodable {
    let meta: Meta
    let timeSeries: [ String : OHLC ]
}

struct Meta: Decodable {
    let symbol: String
    enum CodingKeys: String, CodingKey {
        case symbol = "2. Symbol"
    }
}
// Open High Low Close (OHLC)
struct OHLC: Decodable {
    let open: String
    let close: String
    let adjustedClosed: String
    
    
    enum CodingKeys: String, CodingKey {
        case open           = "1. open"
        case close          = "4. close"
        case adjustedClosed = "5. adjusted close"
    }
}
