//
//  ViewController.swift
//  Quiz Of Knowledge
//
//  Created by Intern on 07/10/2020.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    //MARK:- IBOUTLets
    @IBOutlet weak var titleLBL: UILabel!
    @IBOutlet weak var bottomStackView: UIStackView!
    @IBOutlet weak var scoreLBL: UILabel!
    @IBOutlet weak var aboutLBL: UILabel!
    @IBOutlet weak var musicLBL: UILabel!
    @IBOutlet weak var playLBL: UILabel!
    @IBOutlet weak var musicImageView: UIButton!
    @IBOutlet weak var bottomStackViewHeightMultiplier: NSLayoutConstraint!
    
    //MARK:- varibales
    private var musicPlayer: AVAudioPlayer?
    private var isMusicPlaying = true
    
    override var prefersStatusBarHidden: Bool{
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setIpadSettings()
        playBackGroundMusic()
        CheckForiPhoneModel()
    }
    
    //MARK:- functions to change views settings depending on the device
    
    // adjusting settings for ipad for better user experience
    private func setIpadSettings(){
        let deviceIdiom = UIScreen.main.traitCollection.userInterfaceIdiom
        switch (deviceIdiom) {
        case .pad:
            
            titleLBL.font = UIFont.init(name: Constants.Fonts.comfartaaBold, size: 40)
            playLBL.font = UIFont.init(name: Constants.Fonts.comfartaaRegular, size: 30)
            scoreLBL.font = UIFont.init(name: Constants.Fonts.comfartaaRegular, size: 20)
            aboutLBL.font = UIFont.init(name: Constants.Fonts.comfartaaRegular, size: 20)
            musicLBL.font = UIFont.init(name: Constants.Fonts.comfartaaRegular, size: 20)
            bottomStackView.spacing = 40
            
        default:
            break
        }
    }
    
    //function to change bottom view width multiplier
    private func changeBottomViewheightMultiplier(with height: CGFloat) {
        let newConstraint = bottomStackViewHeightMultiplier.constraintWithMultiplier(height)
        view.removeConstraint(bottomStackViewHeightMultiplier)
        view.addConstraint(newConstraint)
        view.layoutIfNeeded()
        bottomStackViewHeightMultiplier = newConstraint
    }
    
    //function for backgroundMusic
    private func playBackGroundMusic() {
        guard let path = Bundle.main.path(forResource: Constants.AudioFiles.homePageAudio, ofType: "mp3") else { return }
        let url = URL(fileURLWithPath: path)
        
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback)
            try AVAudioSession.sharedInstance().setActive(true)
            musicPlayer = try AVAudioPlayer(contentsOf: url)
            musicPlayer?.play()
        } catch(let error) {
            print(error.localizedDescription)
        }
    }
    
    //function to check which iPhone model is app running on, so to adjust button heights and widths accordingly.
    private func CheckForiPhoneModel(){
        
        let size = UIScreen.main.bounds.size
        let height = size.height
        if height <= 736 {
            changeBottomViewheightMultiplier(with: 0.16)
        }
        else if height <= 900 {
            changeBottomViewheightMultiplier(with: 0.14)
        } else {
            changeBottomViewheightMultiplier(with: 0.17)
        }
    }
    
    //MARK:- buttons pressed functions
    @IBAction func playButton(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let newVC = storyboard.instantiateViewController(withIdentifier: Constants.StoryboardIDs.quizVCStoryboard) as! QuizViewController
        navigationController?.pushViewController(newVC, animated: true)
    }
    
    @IBAction func scoreButton(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let newVC = storyboard.instantiateViewController(withIdentifier: Constants.StoryboardIDs.scoreVCStoryboard) as! ScoreViewController
        navigationController?.pushViewController(newVC, animated: true)
    }
    
    @IBAction func aboutButton(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let newVC = storyboard.instantiateViewController(withIdentifier: Constants.StoryboardIDs.aboutVCStoryboard) as! AboutViewController
        navigationController?.pushViewController(newVC, animated: true)
    }
    
    @IBAction func musicButton(_ sender: UIButton) {
        if isMusicPlaying {
            musicPlayer?.stop()
            musicImageView.setBackgroundImage(UIImage(named: Constants.ImagesAssets.musicOff), for: UIControl.State.normal)
            isMusicPlaying = false
        } else {
            musicPlayer?.play()
            musicImageView.setBackgroundImage(UIImage(named: Constants.ImagesAssets.musicOn), for: UIControl.State.normal)
            isMusicPlaying = true
        }
    }
    
}


//MARK:- extension to change multiplier at run time depending on device
extension NSLayoutConstraint {
    func constraintWithMultiplier(_ multiplier: CGFloat) -> NSLayoutConstraint {
        return NSLayoutConstraint(item: self.firstItem!, attribute: self.firstAttribute, relatedBy: self.relation, toItem: self.secondItem, attribute: self.secondAttribute, multiplier: multiplier, constant: self.constant)
    }
}
