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
            let definition = xml["response"]["data"]["images"]["image"].all.map { elem in elem["url"].element!.text! }
            var catURLArray = [String]()
            
            var catImages = [UIImage]()
            let group = dispatch_group_create()
        
            for imageString in definition {
                dispatch_group_enter(group)
                fetchImageAtURL(imageString) { (image) -> Void in
                    
                    guard let catImage = image else { return}
                    catURLArray.append(imageString)
                    catImages.append(catImage)
                    dispatch_group_leave(group)
                }
            }
            dispatch_group_notify(group, dispatch_get_main_queue(), { () -> Void in
                completion(image: catImages, imageURL: catURLArray)
            })
        }
        task.resume()
    }
}
