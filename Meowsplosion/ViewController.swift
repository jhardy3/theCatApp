//
//  ViewController.swift
//  Meowsplosion
//
//  Created by Jake Hardy on 3/3/16.
//  Copyright © 2016 Jake Hardy. All rights reserved.
//

import UIKit

class ViewController: UIViewController, NSXMLParserDelegate {
    
    @IBOutlet weak var catImageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        InterCatController.fetchCatchURL { (image) -> Void in
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.catImageView.image = image
            })
            
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func catButtons(sender: UIButton) {
        InterCatController.fetchCatchURL { (image) -> Void in
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.catImageView.image = image
            })
            
        }

    }
}

