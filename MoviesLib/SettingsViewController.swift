//
//  SettingsViewController.swift
//  MoviesLib
//
//  Created by Usuário Convidado on 22/03/17.
//  Copyright © 2017 EricBrito. All rights reserved.
//

import UIKit
import CoreMotion

enum SettingsType: String {
    case colorScheme = "colorScheme"
    case autoPlay = "autoPlay"
}

class SettingsViewController: UIViewController {

    @IBOutlet weak var scColorScheme: UISegmentedControl!
    @IBOutlet weak var swAutoPlay: UISwitch!
    @IBOutlet weak var ivBG: UIImageView!
    @IBOutlet weak var tfFood: UITextField!
    
    var pickerView: UIPickerView!
    var motionManager = CMMotionManager()
    var dataSource = [
        "Arroz",
        "Feijão",
        "Ovo",
        "Salada"
    ]
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pickerView = UIPickerView()
        pickerView.delegate = self
        pickerView.dataSource = self
        
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 44))
        
        let btCancel = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancel))
        
        
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        
        let btDone = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done))
        
        toolBar.items = [btCancel,space,btDone]
        
        tfFood.inputView = pickerView
        tfFood.inputAccessoryView = toolBar
        
        if motionManager.isDeviceMotionAvailable {
            motionManager.startDeviceMotionUpdates(to: .main, withHandler: { (data, error) in
                guard error == nil && data != nil else {
                    return
                }
                let angle = atan2(data!.gravity.x, data!.gravity.y) - M_PI
                self.ivBG.transform = CGAffineTransform(rotationAngle: CGFloat(angle))
            })
        }
    }
    
    func cancel() {
        tfFood.resignFirstResponder()
    }
    
    func done() {
        tfFood.text = dataSource[pickerView.selectedRow(inComponent: 0)]
        cancel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        scColorScheme.selectedSegmentIndex = UserDefaults.standard.integer(forKey: SettingsType.colorScheme.rawValue)
        swAutoPlay.setOn(UserDefaults.standard.bool(forKey: SettingsType.autoPlay.rawValue), animated: false)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.becomeFirstResponder()
    }
    
    
    @IBAction func changeColor(_ sender: UISegmentedControl) {
        UserDefaults.standard.set(sender.selectedSegmentIndex, forKey: SettingsType.colorScheme.rawValue)
    }
    
    @IBAction func changeAutoPlay(_ sender: UISwitch) {
        UserDefaults.standard.set(sender.isOn, forKey: SettingsType.autoPlay.rawValue)
    }
}

extension SettingsViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
    }
}

extension SettingsViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let item = dataSource[row]
        return item
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
    }
}

extension SettingsViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return dataSource.count
    }
}





