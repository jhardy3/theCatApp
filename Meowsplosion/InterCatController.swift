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
    
    
    static func fetchCatchURL(numberOfCats cats: Int, completion: (image: [UIImage], imageURL: [String]) -> Void) {
        var returnDefinition = [String]()
        let baseUrl = "http://thecatapi.com/api/images/get?format=xml&results_per_page=\(cats)size=smalltype=jpg"
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
            
            var definition = xml["response"]["data"]["images"]["image"].all.map { elem in elem["url"].element!.text! }
            
            print(definition)
            
            for url in definition {
                returnDefinition.append(String(url))
            }
            print(returnDefinition)
            // ...
            
            var catImages = [UIImage]()
            
            let group = dispatch_group_create()
            
            
            for image in definition {
                dispatch_group_enter(group)
                fetchImageAtURL(image) { (image) -> Void in
                    
                    guard let catImage = image else { return}
                    catImages.append(catImage)
                    dispatch_group_leave(group)
                }
                
            }
            
            dispatch_group_notify(group, dispatch_get_main_queue(), { () -> Void in
                completion(image: catImages, imageURL: definition)
            })
            
        }
        task.resume()
    }
    
}
