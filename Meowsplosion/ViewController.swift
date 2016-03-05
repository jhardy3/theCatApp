//
//  ViewController.swift
//  Meowsplosion
//
//  Created by Jake Hardy on 3/3/16.
//  Copyright © 2016 Jake Hardy. All rights reserved.
//

import UIKit
import SafariServices
import AVFoundation
import iAd

class ViewController: UIViewController, NSXMLParserDelegate, ADInterstitialAdDelegate {
    
    // MARK: - Properties
    
    // Ad Properties
    var allowAdds = false
    var clickCounter = 0
    var interAd = ADInterstitialAd()
    var interAdView: UIView = UIView()
    var closeButton = UIButton(type: UIButtonType.System)
    
    // Sound Properties
    var soundIsOn = true
    var audioPlayer: AVAudioPlayer!
    
    // Image Properties
    var catImages = [UIImage]()
    var catURLs = [String]()
    var currentImage: UIImage?
    var backgroundImage: UIImage?
    var currentURL: String = ""
    
    // Outlet Properties
    @IBOutlet weak var muteButton: UIBarButtonItem!
    @IBOutlet weak var catImageBackground: UIImageView!
    @IBOutlet weak var catImageView: UIImageView!
    @IBOutlet weak var urlButton: UIBarButtonItem!
    
    
    // View Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.createRoarSound()
        self.navigationController?.navigationBar.tintColor = UIColor.blackColor()
        UIBarButtonItem.appearance().setTitleTextAttributes([NSFontAttributeName: UIFont.boldSystemFontOfSize(23)], forState: .Normal)
        self.createCloseButton()
        
        if let backgroundImage = UIImage(named: "PaulCat") {
            catImageBackground.image = backgroundImage
        }
        
        setupCatView()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func catButtons(sender: UIButton) {
        
        clickCounter++
        if catImages.count >= 1 {
            self.createCatImageThreads()
            if  returnRandomNumberWithRange(100) % 20 == 0 {
                self.createMeowSound()
            }
        }
        
        
        if clickCounter % 30 == 0 && allowAdds {
            let myQueue = dispatch_queue_create("com.gcdstretch.ourqueue", nil)
            dispatch_async(myQueue, { () -> Void in
                self.loadAd()
            })
            
        }
    }
    
    @IBAction func toggleSoundTapped(sender: UIBarButtonItem) {
        self.soundIsOn = !soundIsOn
        if soundIsOn {
            guard let image = UIImage(named: "SoundOff") else { return }
            self.muteButton.image = image
        } else {
            guard let image = UIImage(named: "Sound") else { return }
            self.muteButton.image = image
        }
    }
    
    @IBAction func catURLTapped(sender: UIBarButtonItem) {
        createCatAlert()
    }
    
    @IBAction func imageSaverTapped(sender: UIButton) {
        self.createCatActivity()
    }
    
    
    func returnRandomNumberWithRange(number: Int) -> Int {
        let randomNumber = Int(arc4random_uniform(UInt32(number)))
        return randomNumber
    }
    
    
    func setupCatView() {
        InterCatController.fetchCatchURL(numberOfCats: 2, completion: { (image, imageUrl) -> Void in
            self.catImages.appendContentsOf(image)
            self.catURLs.appendContentsOf(imageUrl)
            
            let catImage = self.catImages.removeFirst()
            self.currentImage = catImage
            self.catImageView.image = catImage
            self.currentURL = self.catURLs.removeFirst()
            self.catImageBackground.image = nil
        })
        
        InterCatController.fetchCatchURL(numberOfCats: 10, completion: { (image, imageUrl) -> Void in
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.catImages.appendContentsOf(image)
                self.catURLs.appendContentsOf(imageUrl)
                self.createPurrSound()
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
                self.createPurrSound()
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
    
    func createMeowSound() {
        if soundIsOn {
            
            if let audioFilePath = NSBundle.mainBundle().pathForResource("meow", ofType: "mp3") {
                let audioFileURL = NSURL(fileURLWithPath: audioFilePath)
                
                audioPlayer = try? AVAudioPlayer(contentsOfURL: audioFileURL)
                audioPlayer.play()
            }
        }
    }
    
    func createRoarSound() {
        if soundIsOn {
            
            if let audioFilePath = NSBundle.mainBundle().pathForResource("roar", ofType: "mp3") {
                let audioFileURL = NSURL(fileURLWithPath: audioFilePath)
                
                audioPlayer = try? AVAudioPlayer(contentsOfURL: audioFileURL)
                audioPlayer.play()
            }
        }
    }
    
    func createPurrSound() {
        if soundIsOn {
            
            if let audioFilePath = NSBundle.mainBundle().pathForResource("purr", ofType: "mp3") {
                let audioFileURL = NSURL(fileURLWithPath: audioFilePath)
                
                audioPlayer = try? AVAudioPlayer(contentsOfURL: audioFileURL)
                audioPlayer.play()
            }
        }
    }
    
    func createCloseButton() {
        closeButton.frame = CGRectMake(10, 10, 20, 20)
        closeButton.layer.cornerRadius = 10
        closeButton.setTitle("x", forState: .Normal)
        closeButton.setTitleColor(UIColor.blackColor(), forState: .Normal)
        closeButton.backgroundColor = UIColor.whiteColor()
        closeButton.layer.borderColor = UIColor.blackColor().CGColor
        closeButton.layer.borderWidth = 1
        closeButton.addTarget(self, action: "close:", forControlEvents: .TouchDown)
    }
    
    func close(sender: UIButton) {
        closeButton.removeFromSuperview()
        interAdView.removeFromSuperview()
        self.navigationController?.navigationBarHidden = false
    }
    
    func loadAd() {
        NSThread.sleepForTimeInterval(4)
        interAd = ADInterstitialAd()
        interAd.delegate = self
    }
    
    func interstitialAdDidLoad(interstitialAd: ADInterstitialAd!) {
        interAdView = UIView()
        interAdView.frame = self.view.bounds
        self.navigationController?.navigationBarHidden = true
        view.addSubview(interAdView)
        
        interAd.presentInView(interAdView)
        UIViewController.prepareInterstitialAds()
        
        interAdView.addSubview(closeButton)
    }
    
    func interstitialAdDidUnload(interstitialAd: ADInterstitialAd!) {
    }
    
    func interstitialAd(interstitialAd: ADInterstitialAd!, didFailWithError error: NSError!) {
        closeButton.removeFromSuperview()
        interAdView.removeFromSuperview()
    }
    
    
    func createCatActivity() {
        guard let currentImage = currentImage else { return }
        let activityController = UIActivityViewController(activityItems: [currentImage], applicationActivities: [])
        presentViewController(activityController, animated: true, completion: nil)
    }
}




