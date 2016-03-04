//
//  ViewController.swift
//  Meowsplosion
//
//  Created by Jake Hardy on 3/3/16.
//  Copyright © 2016 Jake Hardy. All rights reserved.
//

import UIKit
import SafariServices

class ViewController: UIViewController, NSXMLParserDelegate {
    
    var catImages = [UIImage]()
    var catURLs = [String]()
    var currentURL: String = ""
    var backgroundImage: UIImage?
    
    @IBOutlet weak var catImageBackground: UIImageView!
    @IBOutlet weak var catImageView: UIImageView!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.tintColor = UIColor.blackColor()
        
        if let backgroundImage = UIImage(named: "PaulCat") {
            catImageBackground.image = backgroundImage
        }
        
        
        
        setupCatView()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func catButtons(sender: UIButton) {
        if catImages.count >= 1 {
            self.createCatImageThreads()
        }
    }
    
    @IBAction func catURLTapped(sender: UIBarButtonItem) {
        //        presentSafarPage()
        createCatAlert()
    }
    
    
    func setupCatView() {
        InterCatController.fetchCatchURL(numberOfCats: 2, completion: { (image, imageUrl) -> Void in
            self.catImages.appendContentsOf(image)
            self.catURLs.appendContentsOf(imageUrl)
            self.catImageView.image = self.catImages.removeFirst()
            self.currentURL = self.catURLs.removeFirst()
            self.catImageBackground.image = nil
        })
        
        InterCatController.fetchCatchURL(numberOfCats: 10, completion: { (image, imageUrl) -> Void in
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.catImages.appendContentsOf(image)
                self.catURLs.appendContentsOf(imageUrl)
            })
            
        })
    }
    
    func presentSafarPage() {
        guard let url = NSURL(string: currentURL) else { return }
        let catPage = SFSafariViewController.init(URL: url)
        self.presentViewController(catPage, animated: true, completion: nil)
    }
    
    func createCatImageThreads() {
        let catImage = catImages.removeFirst()
        self.catImageView.image = catImage
        self.currentURL = self.catURLs.removeFirst()
        if catImages.count < 10 {
            InterCatController.fetchCatchURL(numberOfCats: 30, completion: { (image, imageUrl) -> Void in
                self.catImages.appendContentsOf(image)
                self.catURLs.appendContentsOf(imageUrl)
            })
        }
        if catImages.count < 20 {
            InterCatController.fetchCatchURL(numberOfCats: 20, completion: { (image, imageUrl) -> Void in
                self.catImages.appendContentsOf(image)
                self.catURLs.appendContentsOf(imageUrl)
            })
        }
        if catImages.count < 5 {
            InterCatController.fetchCatchURL(numberOfCats: 5, completion: { (image, imageUrl) -> Void in
                self.catImages.appendContentsOf(image)
                self.catURLs.appendContentsOf(imageUrl)
            })
        }
    }
    
    func createCatAlert() {
        let alertController = UIAlertController(title: "Source URL for this cat!", message: currentURL, preferredStyle: .Alert)
        let goThereAlert = UIAlertAction(title: "Go There!", style: .Default) { (_) -> Void in
            self.presentSafarPage()
        }
        let alert = UIAlertAction(title: "Ok, cool!", style: .Default, handler: nil)
        alertController.addAction(goThereAlert)
        alertController.addAction(alert)
        presentViewController(alertController, animated: true, completion: nil)
        
    }
}


