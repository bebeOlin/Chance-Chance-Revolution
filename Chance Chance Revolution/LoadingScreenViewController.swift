//
//  LoadingScreenViewController.swift
//  Chance Chance Revolution
//
//  Created by Bruce Bolin on 4/19/21.
//

import UIKit
import AVFoundation

class LoadingScreenViewController: UIViewController {
    
    var player: AVAudioPlayer!
    
    @IBOutlet weak var loadingLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if UserDefaults.standard.bool(forKey: "soundState") { playSound(soundName: "Bloop2")
        } else {
    }
        loadingAnimation()
        Timer.scheduledTimer(withTimeInterval: 4.0, repeats: false) { (timer) in
            self.navigationController?.popToRootViewController(animated: true)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if UserDefaults.standard.bool(forKey: "soundState") { playSound(soundName: "Drop")
        } else {
      }
    }
    
    func loadingAnimation() {
        loadingLabel.text = "Loadin"
        var charIndex = 0.0
        let dotDotDot = "g. . ."
        for dots in dotDotDot {
            Timer.scheduledTimer(withTimeInterval: 1.0 * charIndex, repeats: false) { (timer) in
                self.loadingLabel.text?.append(dots)
            }
            charIndex += 0.40
        }
    }
    
    func playSound(soundName: String) {
        let url = Bundle.main.url(forResource: soundName, withExtension: "m4a")
        player = try! AVAudioPlayer(contentsOf: url!)
        player.play()
    }
}
