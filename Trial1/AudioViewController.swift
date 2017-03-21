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
    
    var indx : Int = 0
    
    var previewUrl : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presentDetailView(index: indx)
        
    }

    override func viewDidDisappear(_ animated: Bool) {
        
    }
    
    func presentDetailView(index : Int) {
        
        let podCastObject = resultPodCastArray[index]
        
        artistLabel.text = podCastObject.artistName
        trackLabel.text = podCastObject.trackName
        previewUrl = podCastObject.previewUrl!
        let title = podCastObject.artistName!
        
        DispatchQueue.global(qos: .userInitiated).async {
            do{
                let url = Foundation.URL(string: podCastObject.artworkUrl100!)
                let testImage =  try Data(contentsOf: url!)
                self.detailImgView.image = UIImage(data: testImage)
            }catch  {
                print(Error.self)
                
            }
        }
        let documentDirectoryUrl = Utility.utilityInstance.getUrl()
        let filePath = documentDirectoryUrl.appendingPathComponent("audio"+title)
        
        if FileManager.default.fileExists(atPath: String(describing: filePath)){
            
        } else {
        
            self.fetchAudioData(filePath: filePath,title: title,previewUrl : self.previewUrl) { (fileUrl : URL) -> Void in
                 DispatchQueue.main.async {
            do {
               
                
                self.audioPlayer = try AVAudioPlayer(contentsOf:fileUrl)
                
                self.playOrPause(UIButton())
                
                //let totalTime = self.duration(previewUrl : self.previewUrl)
                let totalTime = self.audioPlayer.duration
                //self.endTimeLabel.text = totalTime
                
                self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(AudioViewController.counter), userInfo: nil, repeats: true)
                }
             catch {
                print("Audio Error")
            }
                }
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
    
    
    @IBAction func slidingSlider(_ sender: UISlider) {
        
        slider.value = Float(audioPlayer.currentTime)
        slider.maximumValue = Float(audioPlayer.duration)
        
    }
  
    
    func duration(previewUrl : String) -> String {
        
        let asset: AVURLAsset = AVURLAsset(url: Foundation.URL(string:previewUrl)!)
        let durationFromAsset = Int(CMTimeGetSeconds(asset.duration))
        duration = Int(durationFromAsset.toIntMax())
        let durStr = String(duration)
        return durStr
        print("duration \(duration)")
    }
    
    func playAudio( audioPlayer : AVAudioPlayer) {
        
            audioPlayer.prepareToPlay()
            audioPlayer.volume = 5
            audioPlayer.play()
        
    }
    
    func counter(){
        
        seconds = seconds + 1
        
        startTimeLabel.text = String(seconds)
        
        if ( seconds == duration) {
            timer.invalidate()
        }
    }
    
    func fetchAudioData(filePath : URL,title:String, previewUrl : String, completion: @escaping ( _ dataFromFile : URL) -> Void) {
    
        
        LoadDataFromURl.instance.getData(urlString: previewUrl){ (data : Data ) -> Void in
            
            self.fileWrite(fileDestinationUrl : filePath,title: title,data: data){ (dataFromFile: URL) -> Void in
                completion(dataFromFile)
            }
        }
    }

    func fileWrite(fileDestinationUrl: URL,title:String,data: Data , completion:  @escaping (_ dataFromFile : URL ) -> Void)  {
        
            do {
                try data.write(to: fileDestinationUrl, options: .atomic)
                completion(fileDestinationUrl)
                
            } catch let error as NSError {
                print("error writing to url \(fileDestinationUrl)")
                print(error.localizedDescription)
            }
        
    }


}
