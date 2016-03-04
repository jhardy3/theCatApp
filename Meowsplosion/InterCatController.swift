//
//  InterCatController.swift
//  Meowsplosion
//
//  Created by Jake Hardy on 3/3/16.
//  Copyright © 2016 Jake Hardy. All rights reserved.
//

import Foundation
import UIKit

// Cat URL http://thecatapi.com/api/images/get?format=xml&results_per_page=20


class InterCatController {
    
    static func dataAtURL(completion: (returnedData: NSData?) -> Void) {
        
        guard let url = NSURL(string: "http://thecatapi.com/api/images/get?format=xml&results_per_page=20") else { return }
        
        let dataTask = NSURLSession.sharedSession().dataTaskWithURL(url) { (cats, _, error) -> Void in
            if let error = error {
                print(error.localizedDescription)
            }
            completion(returnedData: cats)
        }
        dataTask.resume()
    }
    
    
    static func fetchImageAtURL(imageURLString: String, completion: (image: UIImage?) -> Void) {
        
        print(imageURLString)
        if let url = NSURL(string: imageURLString) {
            
            
            NSURLSession.sharedSession().dataTaskWithURL(url, completionHandler: { (data, response, error) -> Void in
                if let error = error {
                    print(error.localizedDescription)
                    completion(image: nil)
                }
                
                if let data = data {
                    let image = UIImage(data: data)
                    completion(image: image)
                }
            })
                
                .resume()
        } else {
            completion(image: nil)
        }
        
    }

    
    static func fetchCatchURL(completion: (image: UIImage) -> Void) {
        var returnDefinition = ""
        let baseUrl = "http://thecatapi.com/api/images/get?format=xml&results_per_page=1"
        let request = NSMutableURLRequest(URL: NSURL(string: baseUrl)!)
        let session = NSURLSession.sharedSession()
        request.HTTPMethod = "GET"
        
        let task = session.dataTaskWithRequest(request) {
            (data, response, error) in
            
            if data == nil {
                print("dataTaskWithRequest error: \(error)")
                return
            }
            guard let data = data else { return }
            let xml = SWXMLHash.parse(data)
            
            if let definition = xml["response"]["data"]["images"]["image"]["url"].element?.text {
                print(definition)
                returnDefinition = definition
                // ...
            }
            
            fetchImageAtURL(returnDefinition) { (image) -> Void in
                guard let catImage = image else { print("stuck here") ; return}
                completion(image: catImage)
            }
        }
        task.resume()
    }
    
}
