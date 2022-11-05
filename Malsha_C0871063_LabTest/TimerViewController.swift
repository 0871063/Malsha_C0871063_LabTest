//
//  ViewController.swift
//  Malsha_C0871063_LabTest
//
//  Created by Malsha Lambton on 2022-11-04.
//

import UIKit
import AVFoundation

class TimerViewController: UIViewController {

    @IBOutlet weak var startTimerBtn: UIButton!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var cencelButton: UIButton!
    @IBOutlet weak var timerPicker: UIPickerView!
    
    var timer = Timer()
    var seconds = 0
    var selectedSeconds = 0
    var timerStarted = false
    var player: AVAudioPlayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        timerLabel.isHidden = true
        timerPicker.isHidden = false
        // Do any additional setup after loading the view.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        player?.stop()
    }

    @IBAction func startTimerButtonClicked() {
        if timerStarted {
            timer.invalidate()
            timerStarted = false
            startTimerBtn.setTitle("Start", for: .normal)
        }else{
            startTimerBtn.setTitle("Pause", for: .normal)
            cencelButton.isEnabled = true
            timerStart()
            timerStarted = true
        }
    }

    @IBAction func cencelTimer() {
        seconds = selectedSeconds
        timerLabel.text = calculateTime(time: TimeInterval(seconds))
        cencelButton.isEnabled = false
        startTimerBtn.setTitle("Start", for: .normal)
        timerLabel.isHidden = true
        timerPicker.isHidden = false
        timer.invalidate()
        timerStarted = false

    }

    //MARK: Timer Function
    private func timerStart(){
        timerLabel.isHidden = false
        timerPicker.isHidden = true
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(timerAction), userInfo: nil, repeats: true)
   }
    
    @objc func timerAction(){
        if seconds == 0 && timerStarted {
            playSound()
            timer.invalidate()
            startTimerBtn.setTitle("Start", for: .normal)
            let alert = UIAlertController(title:"Time" , message:"Your time is up!" , preferredStyle: .alert)
            let action = UIAlertAction(title: "Ok", style: .cancel)
            alert.addAction(action)
            present(alert, animated: true)
        }else{
            seconds -= 1
            timerLabel.text = calculateTime(time: TimeInterval(seconds))
        }
    }

    func calculateTime(time:TimeInterval) -> String {
        let hours = Int(time) / 3600
        let minutes = Int(time) / 60 % 60
        let seconds = Int(time) % 60
        return String(format:"%02i:%02i:%02i", hours, minutes, seconds)
    }
        
    //MARK: Player Function
    func playSound() {
        player?.stop()
        
        guard let url = Bundle.main.url(forResource: "alarm2", withExtension: "wav") else { return }
        
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)

            player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)
            guard let player = player else { return }

            player.play()

        } catch let error {
            print(error.localizedDescription)
        }
    }
}

//MARK: Picker Delegate Function
extension TimerViewController :  UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
            return 4
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch component {
            case 0:
                return 25
            case 1:
                return 1
            case 2:
                return 60
            case 3:
                return 1
           default:
                return 0
        }
    }

    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        return pickerView.frame.size.width/4
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch component {
           case 0:
               return "\(row)"
           case 1:
               return "hours"
           case 2:
               return "\(row)"
           case 3:
               return "min"
           default:
               return ""
           }
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        var minutes = 0
        var hours = 0
        
        switch component {
            case 0:
                hours = row
            case 2:
                minutes = row
            default:
                break;
        }
        convertToSeconds(hours: hours, minute: minutes)
    }
    
    private func convertToSeconds(hours : Int , minute : Int){
        let hours = hours * 3600
        let minutes = minute * 60
        self.seconds = hours + minutes
        selectedSeconds = self.seconds
    }
}
