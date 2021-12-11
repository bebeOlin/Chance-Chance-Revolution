//
//  ViewController.swift
//  Chance Chance Revolution
//
//  Created by Bruce Bolin on 4/19/21.
//

import UIKit
import AVFoundation


class ViewController: UIViewController {
    var resultImage = [ #imageLiteral(resourceName: "Heads"),#imageLiteral(resourceName: "Tails")]
    var resultOptions = ["HEADS!", "TAILS!"]
    var godMode: String = ""
    var counterNumberHeads = 0
    var counterNumberTails = 0
    var headsAlpha = 0
    var tailsAlpha = 0
    var counterObserver: NSObjectProtocol?
    var headsObserver: NSObjectProtocol?
    var tailsObserver: NSObjectProtocol?
    var restoreObserver: NSObjectProtocol?
    
 
    @IBOutlet weak var tailsCounter: UILabel!
    @IBOutlet weak var headsCounter: UILabel!
    @IBOutlet weak var resultText: UILabel!
    @IBOutlet weak var directions: UILabel!
    @IBOutlet weak var coinImage: UIImageView!
    @IBOutlet weak var coinHeight: NSLayoutConstraint!
    @IBOutlet weak var coinWidth: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        counterAlpha()
        if UserDefaults.standard.bool(forKey: "customCoin") == true {
            coinImage.image = loadImageFromDisk(fileName: "Heads")
            resultImage[0] = loadImageFromDisk(fileName: "Heads") ?? resultImage[0]
            resultImage[1] = loadImageFromDisk(fileName: "Tails") ?? resultImage[1]
            coinImage.layer.cornerRadius = 160
        }
        
        
        restoreObserver = NotificationCenter.default.addObserver(forName: Notification.Name("restoreDefaults"), object: nil, queue: .main, using: { (notification) in
            self.resultImage = [ #imageLiteral(resourceName: "Heads"),#imageLiteral(resourceName: "Tails")]
            self.coinImage.image = #imageLiteral(resourceName: "Heads")
            self.resultText.text = ""
            self.coinImage.layer.cornerRadius = 0
        })
        
        headsObserver = NotificationCenter.default.addObserver(forName: Notification.Name("headsImage"), object: nil, queue: .main, using: { (notification) in
            guard let object = notification.object as? [String: UIImage] else {
                return
            }
            guard let heads = object["heads"] else {
                return
            }
            self.resultImage[0] = heads
            self.coinImage.image = heads
            self.resultText.text = ""
            self.coinImage.layer.cornerRadius = 160
        })
        
        tailsObserver = NotificationCenter.default.addObserver(forName: Notification.Name("tailsImage"), object: nil, queue: .main, using: { (notification) in
            guard let object = notification.object as? [String: UIImage] else {
                return
            }
            guard let tails = object["tails"] else {
                return
            }
            self.resultImage[1] = tails
            self.coinImage.image = tails
            self.resultText.text = ""
            self.coinImage.layer.cornerRadius = 160
        })
        
        counterObserver = NotificationCenter.default.addObserver(forName: Notification.Name("counterAlpha"), object: nil, queue: .main, using: { (notification) in
            self.counterNumberHeads = 0
            self.counterNumberTails = 0
            self.resultText.text = ""
            self.counterAlpha()
            self.counter()
            self.tailsCounter.text = "Tails: 0"
            self.headsCounter.text = "Heads: 0"
        })
        
        let swipeUp = UISwipeGestureRecognizer(target: self, action:
        #selector(swipeFunc(gesture:)))
        swipeUp.direction = .up
        self.view.addGestureRecognizer(swipeUp)
        
        let swipeDown = UISwipeGestureRecognizer(target: self, action:
        #selector(swipeFunc(gesture:)))
        swipeDown.direction = .down
        self.view.addGestureRecognizer(swipeDown)
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action:
        #selector(swipeFunc(gesture:)))
        swipeLeft.direction = .left
        self.view.addGestureRecognizer(swipeLeft)
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action:
        #selector(swipeFunc(gesture:)))
        swipeRight.direction = .right
        self.view.addGestureRecognizer(swipeRight)
        
        resultText.text = ""

    }
    
    
    @objc func swipeFunc(gesture: UISwipeGestureRecognizer) {
        if gesture.direction == .up {
            performSegue(withIdentifier: "LoadingScreen", sender: self)
        } else if gesture.direction == .down {
            performSegue(withIdentifier: "SettingsSegue", sender: self)
        } else if gesture.direction == .left && UserDefaults.standard.bool(forKey: "switchState") {
            godMode = "Left"
            performSegue(withIdentifier: "LoadingScreen", sender: self)
        } else if gesture.direction == .right && UserDefaults.standard.bool(forKey: "switchState") {
            godMode = "Right"
            performSegue(withIdentifier: "LoadingScreen", sender: self)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        directions.alpha = 0
    }
    
    override func viewDidAppear(_ animated: Bool) {
        directionsAnimate()
        godMode = ""
        counter()
    }
   
    override func viewDidDisappear(_ animated: Bool) {
        generateResult()
        animateCoin()
    }
    
    
    func generateResult() {
        // Generate random number.
        let num = Int.random(in: 0...1)
        resultText.alpha = 0
        
        if godMode == "Left" {
            coinImage.image = resultImage[0]
            resultText.text = resultOptions[0]
        } else if godMode == "Right" {
            coinImage.image = resultImage[1]
            resultText.text = resultOptions[1]
        } else {
        //Use random number to get result image.
        coinImage.image = resultImage[num]
        resultText.text = resultOptions[num]
        }
    }
    
    
    func animateCoin() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.30) {
            UIView.animate(withDuration: 0.25, delay: 0, animations: {
                self.coinImage.center = self.view.center
        self.coinImage.frame = CGRect(x: 0, y: 0, width: 520, height: 520)
                self.coinHeight.constant = 520
                self.coinWidth.constant = 520
        self.coinImage.layer.cornerRadius = 257
        self.view.layoutIfNeeded()
        }, completion: { done in
        if done {
             UIView.animate(withDuration: 0.25) {
        self.coinImage.frame = CGRect(x: 0, y: 0, width: 320, height: 320)
        self.coinImage.center = self.view.center
            self.coinHeight.constant = 320
            self.coinWidth.constant = 320
        self.coinImage.layer.cornerRadius = 160
        self.view.layoutIfNeeded()
        }
        self.resultText.alpha = 1
        }
      })
     }
    }
    
    func directionsAnimate() {
        directions.text = "Swipe Down For Settings"
        UIView.animate(withDuration: 1.5) {
            self.directions.alpha = 1
        } completion: { (true) in
            UIView.animate(withDuration: 1.5) {
                self.directions.alpha = 0
            } completion: { (true) in
                self.directions.text = "Swipe Up To Flip Coin"
                UIView.animate(withDuration: 1.5) {
                    self.directions.alpha = 1
                }
            }
        }
    }
    
    func counterAlpha() {
        if UserDefaults.standard.bool(forKey: "counterState") {
            headsCounter.alpha = 1
            tailsCounter.alpha = 1
        } else {
            headsCounter.alpha = 0
            tailsCounter.alpha = 0
        }
    }
    
    func getHeads() -> Int {
        return counterNumberHeads
    }
    
    func getTails() -> Int {
        return counterNumberTails
    }
    
    func counter() {
        if resultText.text == "HEADS!" {
            counterNumberHeads += 1
        } else if resultText.text == "TAILS!" {
            counterNumberTails += 1
        } else {
            counterNumberTails = 0
            counterNumberTails = 0
        }
        headsCounter.text = "Heads: \(getHeads())"
        tailsCounter.text = "Tails: \(getTails())"
    }
    
    func loadImageFromDisk(fileName: String) -> UIImage? {
        let documentDirectory = FileManager.SearchPathDirectory.documentDirectory
        let userDomainMask = FileManager.SearchPathDomainMask.userDomainMask
        let paths = NSSearchPathForDirectoriesInDomains(documentDirectory, userDomainMask, true)
        if let dirPath = paths.first {
            let imageURL = URL(fileURLWithPath: dirPath).appendingPathComponent(fileName)
            let image = UIImage(contentsOfFile: imageURL.path)
            return image
        }
        return nil
    }
}


