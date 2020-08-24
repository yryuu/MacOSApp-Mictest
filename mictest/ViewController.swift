//
//  ViewController.swift
//  mictest
//
//  Created by ryuu yamazaki on 2020/08/23.
//  Copyright © 2020 ryuu yamazaki. All rights reserved.
//

import Cocoa
import Speech
import AVFoundation

let audioEngine = AVAudioEngine()
var recognitionReq: SFSpeechAudioBufferRecognitionRequest = SFSpeechAudioBufferRecognitionRequest()
var recognitionTask: SFSpeechRecognitionTask?
let recognizer = SFSpeechRecognizer(locale: Locale.init(identifier: "ja_JP"))!

class ViewController: NSViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewDidAppear() {
        SFSpeechRecognizer.requestAuthorization { (authStatus) in
          DispatchQueue.main.async {
            if authStatus != SFSpeechRecognizerAuthorizationStatus.authorized {
                print("test2")
                
            }
            else {
                print("test1")
                try! self.start()
            }
          }
        }
        
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
    func start() throws {
        let audioEngine = AVAudioEngine()
        let inputNode = audioEngine.inputNode
        
        recognitionReq.shouldReportPartialResults = true

        // マイク入力の設定
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 2048, format: recordingFormat) { (buffer, time) in
            print(buffer)
          recognitionReq.append(buffer)
        }
        audioEngine.prepare()
        try audioEngine.start()
        
        recognitionTask = recognizer.recognitionTask(with: recognitionReq, resultHandler: { (result, error) in
          if let error = error {
            print("\(error)")
          } else {
            DispatchQueue.main.async {
              
                print(result?.bestTranscription.formattedString as Any)
            }
          }
        })
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            audioEngine.stop()
            audioEngine.inputNode.removeTap(onBus: 0)
            recognitionReq.endAudio()
        }
        
    }


}

