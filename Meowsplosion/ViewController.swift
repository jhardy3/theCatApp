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
    
    @IBOutlet weak var catImageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        InterCatController.fetchCatchURL(numberOfCats: 10, completion: { (image) -> Void in
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.catImages.appendContentsOf(image)
                print(image)
                self.catImageView.image = self.catImages.removeFirst()
            })
            
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func catButtons(sender: UIButton) {
        if catImages.count >= 1 {
            let catImage = catImages.removeFirst()
            self.catImageView.image = catImage
            if catImages.count < 200 {
                InterCatController.fetchCatchURL(numberOfCats: 20, completion: { (image) -> Void in
                    self.catImages.appendContentsOf(image)
                })
            }
        }
    }
}

