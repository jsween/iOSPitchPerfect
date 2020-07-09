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
    
    // Start Recording
    @IBAction func recordAudio(_ sender: UIButton) {
        configureRecordUI(isRecording: true)
        
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
        configureRecordUI(isRecording: false)
        
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
    }
    // Finish Recording
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag {
            performSegue(withIdentifier: "stopRecording", sender: audioRecorder.url)
        } else {
            showAlert(AlertMsgs.RecordingFailedTitle, message: AlertMsgs.RecordingFailedMessage)
        }
    }
    // Config Record UI
    func configureRecordUI(isRecording: Bool) {
        stopRecordingBtn.isEnabled = isRecording // to enable or disable button
        recordBtn.isEnabled = !isRecording // opposite of state of stop btn
        recordingLbl.text = isRecording ? "Recording in Progress" : "Tap to Record"
    }
    // Show Alert to User
    func showAlert(_ title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: AlertMsgs.DismissAlert, style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}

