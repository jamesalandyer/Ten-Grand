//
//  QuotesConstants.swift
//  Ten Grand
//
//  Created by James Dyer on 6/30/16.
//  Copyright © 2016 James Dyer. All rights reserved.
//

import Foundation

extension QuotesClient {
    
    struct Constants {
        
        struct Quotes {
            static let APIScheme = "http"
            static let APIHost = "quotes.rest"
            static let APIPath = "/qod.json"
        }
        
        struct QuotesParameterKeys {
            static let Category = "category"
        }
        
        struct QuotesParameterValues {
            static let InspireCategory = "inspire"
        }
        
        struct QuotesResponseKeys {
            static let Contents = "contents"
            static let Quotes = "quotes"
            static let Quote = "quote"
            static let Author = "author"
        }
        
    }
    
}