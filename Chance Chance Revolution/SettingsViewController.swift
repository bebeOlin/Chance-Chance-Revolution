//
//  SettingsViewController.swift
//  Chance Chance Revolution
//
//  Created by Bruce Bolin on 5/12/21.
//

import UIKit






class SettingsViewController: UIViewController {
    
    let viewController = ViewController()
    var headsOrTails: String = ""
    @IBOutlet weak var soundSwitch: UISwitch!
    @IBOutlet weak var counterSwitch: UISwitch!
    @IBOutlet weak var modeSubtext: UILabel!
    @IBOutlet weak var switchButton: UISwitch!
    @IBOutlet weak var headsButton: UIButton!
    @IBOutlet weak var tailsButton: UIButton!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        switchButton.isOn = UserDefaults.standard.bool(forKey: "switchState")
        counterSwitch.isOn = UserDefaults.standard.bool(forKey: "counterState")
        soundSwitch.isOn = UserDefaults.standard.bool(forKey: "soundState")
        switchText()
        headsButton.layer.cornerRadius = 30
        tailsButton.layer.cornerRadius = 30
        
        
    }
    
    @IBAction func switchToggled(_ sender: UISwitch) {
        UserDefaults.standard.set(sender.isOn, forKey: "switchState")
        switchText()
    }
    
    @IBAction func counterToggle(_ sender: UISwitch) {
        UserDefaults.standard.set(sender.isOn, forKey: "counterState")
        NotificationCenter.default.post(name: Notification.Name("counterAlpha"), object: self)
    }
    
    @IBAction func soundToggle(_ sender: UISwitch) {
        UserDefaults.standard.set(sender.isOn, forKey: "soundState")
    }
    
    @IBAction func headsPicker(_ sender: UIButton) {
        coinImagePicker()
        headsOrTails = "heads"
    }
    
    @IBAction func tailsPicker(_ sender: UIButton) {
        coinImagePicker()
        headsOrTails = "tails"
    }
    
    @IBAction func restoreButton(_ sender: UIButton) {
        let alert = UIAlertController(title: "Restore Images", message: "Restore Default Images?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Restore", style: .default, handler: {
            action in
            NotificationCenter.default.post(name: Notification.Name("restoreDefaults"), object: nil)
            self.headsOrTails = ""
            UserDefaults.standard.setValue(false, forKey: "customCoin")
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(alert, animated: true)
    }
    
    func coinImagePicker() {
        let vc = UIImagePickerController()
        vc.sourceType = .photoLibrary
        vc.delegate = self
        vc.allowsEditing = true
        present(vc, animated: true)
    }
    
    
    func switchText() {
        if switchButton.isOn == true {
            modeSubtext.text = "Swipe Left for Heads. Swipe Right for Tails."
        } else {
            modeSubtext.text = "Leave nothing to Chance."
        }
    }
}

extension SettingsViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey(rawValue: "UIImagePickerControllerEditedImage")] as? UIImage {
            if headsOrTails == "heads" { NotificationCenter.default.post(name: Notification.Name("headsImage"), object: ["heads": image])
                saveHeadsImage(imageName: "Heads", image: image)
            } else if headsOrTails == "tails" {
                NotificationCenter.default.post(name: Notification.Name("tailsImage"), object: ["tails": image])
                saveHeadsImage(imageName: "Tails", image: image)
            }
        }
        UserDefaults.standard.setValue(true, forKey: "customCoin")
        picker.dismiss(animated: true, completion: nil)
        
        
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func saveHeadsImage(imageName: String, image: UIImage) {
        guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {return}
        let fileName = imageName
        let fileURL = documentsDirectory.appendingPathComponent(fileName)
        guard let data = image.jpegData(compressionQuality: 1) ?? image.pngData() else {return}
        if FileManager.default.fileExists(atPath: fileURL.path) {
            do {
                try FileManager.default.removeItem(atPath: fileURL.path) }
            catch let removeError {
                print(removeError)
            }
        }
        do {
            try data.write(to: fileURL)
        } catch let error {
            print(error)
        }
    }
    
    
}
