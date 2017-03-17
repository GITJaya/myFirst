//
//  DetailViewController.swift
//  Trial1
//
//  Created by Jaya   on 09/03/17.
//  Copyright © 2017 AppCoda. All rights reserved.
//

import UIKit
import AVFoundation

class DetailViewController: UIViewController {

    
    @IBOutlet weak var detailImgView: UIImageView!

    @IBOutlet weak var artistLabel: UILabel!

    @IBOutlet weak var trackLabel: UILabel!
    
    @IBOutlet weak var playButton: UIButton!
    
    var audioPlayer = AVAudioPlayer()
    
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
       
            DispatchQueue.global(qos: .userInitiated).async {
                do{
                    let url = Foundation.URL(string: podCastObject.artworkUrl100!)
                    let testImage =  try Data(contentsOf: url!)
                    
                    //I am writing in documents directory or file system
                    DispatchQueue.main.async {
                    
                       self.detailImgView.image = UIImage(data: testImage)
                        
                        self.fetchAudioData(title: podCastObject.artistName!,previewUrl : self.previewUrl) { (fileUrl : URL) -> Void in
                            do {
                           
                            self.audioPlayer = try AVAudioPlayer(contentsOf:fileUrl)
                            
                            self.playOrPause(UIButton())
                
                            } catch {
                                print("Audio Error")
                            }
                        }
                    }
                }catch  {
                    print(Error.self)
            
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
            self.audioPlayer.pause()
        } else {
            self.playButton.setImage(UIImage(named : "pause"), for: UIControlState.normal)
            self.playAudio(audioPlayer: self.audioPlayer)
            
        }
    }
    

    @IBAction func forwardMusic(_ sender: Any) {
        
        let index = self.indx + 1
        presentDetailView(index: index)
        indx = index
    }
    
    @IBAction func rewindMusic(_ sender: Any) {
        
        let index = self.indx - 1
        presentDetailView(index: index)
        indx = index
    }
    
    func playAudio( audioPlayer : AVAudioPlayer) {
            audioPlayer.prepareToPlay()
            audioPlayer.volume = 5
            audioPlayer.play()
    }
    
    func fetchAudioData(title:String, previewUrl : String, completion: @escaping ( _ dataFromFile : URL) -> Void) {
    
        LoadDataFromURl.instance.getData(urlString: previewUrl){ (data : Data ) -> Void in
            
            self.fileWrite(tile: title,data: data){ (dataFromFile: URL) -> Void in
                completion(dataFromFile)
            }
        }
    }

    func fileWrite(tile:String,data: Data , completion:  @escaping (_ dataFromFile : URL ) -> Void)  {
        
        do {
            // get the documents folder url
            let documentDirectoryURL = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            // create the destination url for the text file to be saved
            let fileDestinationUrl = documentDirectoryURL.appendingPathComponent("audio"+tile)
    
            do {
                try data.write(to: fileDestinationUrl, options: .atomic)
                do {
                    try data.write(to: fileDestinationUrl, options: .atomic)
                } catch let error as NSError {
                    print("error loading contentsOf url \(fileDestinationUrl)")
                    print(error.localizedDescription)
                }
                completion(fileDestinationUrl)
                
            } catch let error as NSError {
                print("error writing to url \(fileDestinationUrl)")
                print(error.localizedDescription)
            }
        } catch let error as NSError {
            print("error getting documentDirectoryURL")
            print(error.localizedDescription)
        }
    }


}
