//
//  DetailViewController.swift
//  Trial1
//
//  Created by Jaya   on 09/03/17.
//  Copyright © 2017 AppCoda. All rights reserved.
//

import UIKit
import AVFoundation

class AudioViewController: UIViewController {

    
    @IBOutlet weak var detailImgView: UIImageView!

    @IBOutlet weak var artistLabel: UILabel!

    @IBOutlet weak var trackLabel: UILabel!
    
    @IBOutlet weak var playButton: UIButton!
    
    @IBOutlet weak var slider: UISlider!
    
   
    @IBOutlet weak var startTimeLabel: UILabel!
    
    
    @IBOutlet weak var endTimeLabel: UILabel!
    
    var audioPlayer = AVAudioPlayer()
    
    var timer = Timer()
    
    var startTime = 0
    
    var endTime = 0
    
    var duration = 0
    
    var seconds = 0
    
    var resultPodCastArray : [PodCast] = []
    
    var podCastObject =  PodCast()
    var indx : Int = 0
    
    var previewUrl : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presentDetailView(index: indx)
        
    }

    override func viewDidDisappear(_ animated: Bool) {
        
    }
    
    func presentDetailView(index : Int) {
        
        podCastObject = resultPodCastArray[index]
        
        artistLabel.text = podCastObject.artistName
        trackLabel.text = podCastObject.trackName
        previewUrl = podCastObject.previewUrl!
        let title = podCastObject.artistName!

        let documentDirectoryUrl = Utility.getDocumentDirectoryURL()
        
        let filePath = documentDirectoryUrl.appendingPathComponent("audio"+title)
        
        if FileManager.default.fileExists(atPath: String(describing: filePath)){
            
             self.triggerAudioPlayer(fileUrl: filePath)
            
        } else {
        
            self.fetchAudioData(filePath: filePath,title: title,previewUrl : self.previewUrl) { (fileUrl : URL) -> Void in
                
                 self.triggerAudioPlayer(fileUrl: filePath)
                
           }
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func playOrPause(_ sender: Any) {
       
        if (self.audioPlayer.isPlaying){
            self.playButton.setImage(UIImage(named : "playIcon"), for: UIControlState.normal)
            timer.invalidate()
            self.audioPlayer.pause()
        } else {
            self.playButton.setImage(UIImage(named : "pause"), for: UIControlState.normal)
            seconds = 0
            self.initialiseSlider()
            self.playAudio(audioPlayer: self.audioPlayer)
            
        }
    }
    

    @IBAction func forwardMusic(_ sender: Any) {
        
        let index = self.indx + 1
        indx = index
        print(indx)
        if indx >= resultPodCastArray.count  {
            indx = 0
        }
         presentDetailView(index: indx)
    }
    
    @IBAction func rewindMusic(_ sender: Any) {
        
        let index = self.indx - 1
        indx = index
        print(indx)
        if indx == -1 {
            indx = resultPodCastArray.count - 1
        }
         presentDetailView(index: indx)
       
    }
    
    
    
    @IBAction func isSliderValueChanged(_ sender: Any) {
        
        audioPlayer.currentTime = TimeInterval(slider.value)
        self.counter()
    }
  
    func triggerAudioPlayer(fileUrl : URL) {
        
        DispatchQueue.main.async {
            
            do {
                if self.timer != nil{
                   self.timer.invalidate()
                }
                self.audioPlayer = try AVAudioPlayer(contentsOf:fileUrl)
                
                let url = Foundation.URL(string: self.podCastObject.artworkUrl100!)
                let testImage =  try Data(contentsOf: url!)
                self.detailImgView.image = UIImage(data: testImage)
                
                self.playOrPause(UIButton())
                
            }
            catch {
                print("Audio Error")
            }
        }
    }
    
    func duration(previewUrl : String) -> String {
        
        let asset: AVURLAsset = AVURLAsset(url: Foundation.URL(string:previewUrl)!)
        let durationFromAsset = Int(CMTimeGetSeconds(asset.duration))
        duration = Int(durationFromAsset.toIntMax())
        let durStr = String(duration)
        return durStr
    }
    
    func playAudio( audioPlayer : AVAudioPlayer) {
        
            audioPlayer.prepareToPlay()
            audioPlayer.volume = 5
            audioPlayer.play()
    }
    
    func initialiseSlider() {
        
        let totalTime = Int(self.audioPlayer.duration)
        let minutes = totalTime/60
        let seconds = totalTime - minutes * 60
        self.endTimeLabel.text = NSString(format: "%02d:%02d", minutes,seconds) as String
        
        self.slider.value = Float(self.audioPlayer.currentTime)
        self.slider.maximumValue = Float(self.audioPlayer.duration)
        
        self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(AudioViewController.counter), userInfo: nil, repeats: true)
    }
    
    func counter(){
        
        let currentTime = Int(audioPlayer.currentTime)
        let minutes = currentTime/60
        let seconds = currentTime - minutes * 60
        startTimeLabel.text = NSString(format: "%02d:%02d", minutes,seconds) as String
        slider.value = Float(audioPlayer.currentTime)
    
    }
    
    func fetchAudioData(filePath : URL,title:String, previewUrl : String, completion: @escaping ( _ dataFromFile : URL) -> Void) {
    
        DispatchQueue.global(qos: .userInitiated).async {
            
        LoadDataFromURl.instance.getData(urlString: previewUrl){ (data : Data ) -> Void in
            
            do {
                try data.write(to: filePath, options: .atomic)
                completion(filePath)
                
            } catch let error as NSError {
                print("error writing to url \(filePath)")
                print(error.localizedDescription)
            }
           
        }
        }
    }


}
