//
//  ViewController.swift
//  Meowsplosion
//
//  Created by Jake Hardy on 3/3/16.
//  Copyright © 2016 Jake Hardy. All rights reserved.
//

import UIKit

class ViewController: UIViewController, NSXMLParserDelegate {
    
    var catImages = [UIImage]()
    var catURLs = [String]()
    
    @IBOutlet weak var urlLabel: UILabel!
    @IBOutlet weak var catImageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        InterCatController.fetchCatchURL(numberOfCats: 10, completion: { (image, imageUrl) -> Void in
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.catImages.appendContentsOf(image)
                self.catURLs.appendContentsOf(imageUrl)
                self.catImageView.image = self.catImages.removeFirst()
                self.urlLabel.text = self.catURLs.removeFirst()
            })
            
        })
        
        if catImages.count < 11 {
            InterCatController.fetchCatchURL(numberOfCats: 20, completion: { (image, imageUrl) -> Void in
                self.catImages.appendContentsOf(image)
                self.catURLs.appendContentsOf(imageUrl)
            })
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func catButtons(sender: UIButton) {
        if catImages.count >= 1 {
            let catImage = catImages.removeFirst()
            self.catImageView.image = catImage
            self.urlLabel.text = self.catURLs.removeFirst()
            if catImages.count < 10 {
                InterCatController.fetchCatchURL(numberOfCats: 60, completion: { (image, imageUrl) -> Void in
                    self.catImages.appendContentsOf(image)
                    self.catURLs.appendContentsOf(imageUrl)
                })
            }
        }
    }
}

