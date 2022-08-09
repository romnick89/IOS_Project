//
//  MainMenuViewController.swift
//  MyGameIOS
//
//  Created by user196253 on 4/29/22.
//

import UIKit
import AVFoundation

class MainMenuViewController:
    UIViewController {
    
    var clickSound = NSURL(fileURLWithPath: Bundle.main.path(forResource: "click", ofType: "wav")!)
    var audioPlayer = AVAudioPlayer()
    //exit button function
    @IBAction func exitButton(_ sender: Any) {
        do{
            audioPlayer = try AVAudioPlayer(contentsOf: clickSound as URL)
            audioPlayer.play()
            print("sound is working")
        } catch {
            print("could not load the file")
        }
        exit(0)
    }
    //help button function
    @IBAction func HelButton(_ sender: Any) {
        do{
            audioPlayer = try AVAudioPlayer(contentsOf: clickSound as URL)
            audioPlayer.play()
            print("sound is working")
        } catch {
            print("could not load the file")
        }
    }
    //start button function
    @IBAction func StartButton(_ sender: Any) {
        do{
            audioPlayer = try AVAudioPlayer(contentsOf: clickSound as URL)
            audioPlayer.play()
            print("sound is working")
        } catch {
            print("could not load the file")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //set background image
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = UIImage(named: "biological.jpg")
        backgroundImage.contentMode = UIView.ContentMode.scaleAspectFill
        self.view.insertSubview(backgroundImage, at: 0)
    }
}
