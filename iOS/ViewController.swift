//
//  ViewController.swift
//  iOS
//
//  Created by Jeong YunWon on 2016. 9. 24..
//  Copyright © 2016년 youknowone.org. All rights reserved.
//

import UIKit

class ViewController: UIViewController, SpeakerDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    

    @IBOutlet var panGesture: UIPanGestureRecognizer! = nil
    @IBOutlet weak var textView: UITextView! = nil
    @IBOutlet weak var playButton: UIBarButtonItem! = nil

    let speaker = Speaker.defaultSpeaker
    var languageNames: [String] = []
    
    @IBAction func playClicked(_ sender: AnyObject) {
        if speaker.isSpeaking {
            if speaker.isPaused {
                speaker.continueSpeaking()
                playButton.image = UIImage(named: "Pause.png")
            } else {
                speaker.pauseSpeaking()
                playButton.image = UIImage(named: "Play.png")
            }
        } else if let text = self.textView.text {
            speaker.speakText(text: text)
            playButton.image = UIImage(named: "Pause.png")
        }
    }
    

    @IBAction func DismissKeyboard(sender: UIPanGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    @IBAction func stopClicked(_ sender: AnyObject) {
        speaker.stopSpeaking()
        playButton.image = UIImage(named: "Play.png")
    }
    
    func speaker(speaker: Speaker, didFinishSpeechString: String) {
        playButton.image = UIImage(named: "Play.png")
    }
    
    @IBAction func rateSegmentChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            speaker.rate = 0.3
        case 1:
            speaker.rate = 0.5
        case 2:
            speaker.rate = 0.7
        default: break
        }
    }

    @IBAction func changeVoiceClicked(_ sender: AnyObject) {
        // create action sheet & picker view dynamically
        let alertController = UIAlertController(title: "Select Launguage", message: "\n\n\n\n\n\n\n\n\n\n", preferredStyle: UIAlertControllerStyle.actionSheet);
        let alertFrame = alertController.view.frame
        let languagePicker = UIPickerView(frame: CGRect(x: alertFrame.minX, y: alertFrame.minY + 20, width: alertFrame.width - 50, height: 250))
        languagePicker.center.x = self.view.center.x
        languagePicker.autoresizingMask = [UIViewAutoresizing.flexibleLeftMargin, UIViewAutoresizing.flexibleRightMargin]
        languagePicker.delegate = self
        languagePicker.dataSource = self
        languagePicker.showsSelectionIndicator = true
        alertController.view.addSubview(languagePicker)
        
        let action = UIAlertAction(title: "DONE", style: .default) { (action) in
            let value = languagePicker.selectedRow(inComponent: 0)
            self.speaker.changeLanguage(language: self.speaker.voices[value].language)
        }
        alertController.addAction(action)
        present(alertController, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addGestureRecognizer(panGesture)
        speaker.delegate = self
        //init language names
        let voices = self.speaker.voices
        for voice in voices {
            languageNames.append(voice.name)
        }
    
        // add 'Done' toolbar on keyboard
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 50))
        toolBar.barStyle = UIBarStyle.default
        toolBar.items = [
            UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil),
            UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.plain, target: self, action: #selector(ViewController.doneClicked))]
        toolBar.sizeToFit()
        
        textView.inputAccessoryView = toolBar
    }
    
    func doneClicked() {
        textView.resignFirstResponder()
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.speaker.voices.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let name = self.languageNames[row]
        let languageCode = self.speaker.voices[row].language
        return "\(name)(\(languageCode))"
    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
