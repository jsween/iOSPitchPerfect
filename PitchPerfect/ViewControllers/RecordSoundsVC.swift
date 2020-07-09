//
//  RecordSoundsVC.swift
//  PitchPerfect
//
//  Created by Jonathan Sweeney on 7/8/20.
//  Copyright © 2020 Jonathan Sweeney. All rights reserved.
//

// MARK: - RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate

import UIKit
import AVFoundation

class RecordSoundsVC: UIViewController, AVAudioRecorderDelegate {
    
    // MARK: IBOutlets
    @IBOutlet weak var recordingLbl: UILabel!
    @IBOutlet weak var recordBtn: UIButton!
    @IBOutlet weak var stopRecordingBtn: UIButton!
    
    // MARK: Audio Recorder: AVAudioRecorder
    var audioRecorder: AVAudioRecorder!
    
    // MARK: Override Methods
    // View loaded
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    // View will Appear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        stopRecordingBtn.isEnabled = false
    }
    // View Did Appear
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    // Prepare for segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "stopRecording" {
            let playSoundsVC = segue.destination as! PlaySoundsVC
            let recordedAudioURL = sender as! URL
            playSoundsVC.recordedAudioURL = recordedAudioURL
        }
    }

    // MARK: Methods
    @IBAction func recordAudio(_ sender: UIButton) {
        recordingLbl.text = "Recording in progress..."
        stopRecordingBtn.isEnabled = true
        recordBtn.isEnabled = false
        
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask, true)[0] as String
        let recordingName = "recordedVoice.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = URL(string: pathArray.joined(separator: "/"))

        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSession.Category.playAndRecord, mode: AVAudioSession.Mode.default, options: AVAudioSession.CategoryOptions.defaultToSpeaker)

        try! audioRecorder = AVAudioRecorder(url: filePath!, settings: [:])
        audioRecorder.delegate = self
        audioRecorder.isMeteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }
    // Stop Recording
    @IBAction func stopRecording(_ sender: UIButton) {
        recordingLbl.text = "Tap to Record"
        stopRecordingBtn.isEnabled = false
        recordBtn.isEnabled = true
        
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
    }
    // Finish Recording
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag {
            performSegue(withIdentifier: "stopRecording", sender: audioRecorder.url)
        } else {
            print("Error: Unsuccessful Recording")
        }
    }
}

