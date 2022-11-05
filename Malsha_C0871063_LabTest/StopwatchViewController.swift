//
//  StopwatchViewController.swift
//  Malsha_C0871063_LabTest
//
//  Created by Malsha Lambton on 2022-11-04.
//

import UIKit

class StopwatchViewController: UIViewController {

    @IBOutlet weak var startTimerBtn: UIButton!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var lapButton: UIButton!
    @IBOutlet weak var timerTableView: UITableView! {
        didSet {
            timerTableView.dataSource = self
            timerTableView.delegate = self
        }
    }
    
    var timer = Timer()
    var seconds = 0
    var timerStarted = false
    var timerArray = [TimerStruct]()
    var lapcount = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lapButton.isEnabled = false
        // Do any additional setup after loading the view.
    }
    
    private func timerStart(){

        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(timerAction), userInfo: nil, repeats: true)

       }
    
    @IBAction func startTimerButtonClicked() {
        if timerStarted {
            stopTimer()
        }else{
            startTimerBtn.setTitle("Stop", for: .normal)
            lapButton.isEnabled = true
            timerStart()
            timerStarted = true
        }

    }
    
    @IBAction func lapButtonClicked() {
        if timerStarted {
            let lapCount = "Lap " + String(lapcount)
            let timerStruct = TimerStruct(timerValue: timerLabel.text ?? "00:00:00", lapCount: lapCount)
            timerArray.append(timerStruct)
            timerTableView.reloadData()
            lapcount += 1
        }else{
            lapButton.setTitle("Lap", for: .normal)
            seconds = 0
            lapcount = 1
            timerLabel.text = "00:00:00"
            lapButton.isEnabled = false
            timerArray.removeAll()
            timerTableView.reloadData()
        }
    }
    
    private func stopTimer(){
        startTimerBtn.setTitle("Start", for: .normal)
        lapButton.setTitle("Reset", for: .normal)
        timer.invalidate()
        timerStarted = false
    }
    
    @objc func timerAction(){
        seconds += 1
        timerLabel.text = calculateTime(time: TimeInterval(seconds))
    }

    func calculateTime(time:TimeInterval) -> String {
        let hours = Int(time) / 3600
        let minutes = Int(time) / 60 % 60
        let seconds = Int(time) % 60
        return String(format:"%02i:%02i:%02i", hours, minutes, seconds)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension StopwatchViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return timerArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TimerCell") as! TimerCell
        cell.timerValueLabel?.text = timerArray[indexPath.row].timerValue
        cell.lapCountLabel?.text = timerArray[indexPath.row].lapCount
        
        return cell
        
    }
}
