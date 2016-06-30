//
//  QuotesClient.swift
//  Ten Grand
//
//  Created by James Dyer on 6/30/16.
//  Copyright © 2016 James Dyer. All rights reserved.
//

import Foundation

class QuotesClient {
    
    static let sharedInstance = QuotesClient()
    
    /**
     Downloads a quote from the internet.
     
     - Parameter parameters: The parameters for the quote to be downloaded.
     - Parameter completionHandler: (Optional) Passes the quote string if it was successful and passes an error if it occured.
     - Parameter completionHandler: (Optional) Passes the author string if it was successful and passes an error if it occured.
     
     - Returns: NSURLSessionTask of the current downloading task.
     */
    func taskForGETQuote(parameters: [String: AnyObject], completionHandler: (quote: String?, author: String?, error: NSError?) -> Void) -> NSURLSessionTask {
        let session = NSURLSession.sharedSession()
        
        let url = quotesURLFromParameters(parameters)
        let request = NSURLRequest(URL: url)
        
        let task = session.dataTaskWithRequest(request) { (data, response, error) in
            
            func errorOccured() {
                completionHandler(quote: nil, author: nil, error: error)
            }
            
            guard (error == nil) else {
                print("There was an error with your request: \(error)")
                errorOccured()
                return
            }
            
            guard let statusCode = (response as? NSHTTPURLResponse)?.statusCode where statusCode >= 200 && statusCode <= 299 else {
                print("Your request returned a status code other than 2xx!")
                errorOccured()
                return
            }
            
            guard let data = data else {
                print("No data was returned by the request!")
                errorOccured()
                return
            }
            
            let parsedResult: AnyObject!
            
            do {
                parsedResult = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)
            } catch {
                print("Could not parse the data as JSON: '\(data)'")
                errorOccured()
                return
            }
            
            guard let contents = parsedResult[QuotesClient.Constants.QuotesResponseKeys.Contents] as? [String: AnyObject] else {
                print("No contents.")
                errorOccured()
                return
            }
            
            guard let quotes = contents[QuotesClient.Constants.QuotesResponseKeys.Quotes] as? [[String: AnyObject]] else {
                print("No quotes.")
                errorOccured()
                return
            }
            
            guard let quote = quotes[0][QuotesClient.Constants.QuotesResponseKeys.Quote] as? String else {
                print("No quote.")
                errorOccured()
                return
            }
            
            guard let author = quotes[0][QuotesClient.Constants.QuotesResponseKeys.Author] as? String else {
                print("No author.")
                errorOccured()
                return
            }
            
            completionHandler(quote: quote, author: author, error: nil)
        }
        
        task.resume()
        
        return task
    }
    
    /**
     Gets the quote url.
     
     - Parameter parameters: Parameters to add to the url.
     
     - Returns: NSURL of the new url created.
     */
    private func quotesURLFromParameters(parameters: [String: AnyObject]) -> NSURL {
        
        let components = NSURLComponents()
        components.scheme = Constants.Quotes.APIScheme
        components.host = Constants.Quotes.APIHost
        components.path = Constants.Quotes.APIPath
        components.queryItems = [NSURLQueryItem]()
        
        for (key, value) in parameters {
            let queryItem = NSURLQueryItem(name: key, value: "\(value)")
            components.queryItems!.append(queryItem)
        }
        
        return components.URL!
    }
    
}