//
//  AudioPlayerViewController.swift
//  Lightening
//
//  Created by claire on 2022/4/18.
//

import UIKit

class AudioPlayerViewController: UIViewController {
    
    var selectedAudioIndex: Int = 0
    
    var datas: [Audio] = [] {
        
        didSet {
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.clear
        
        layoutButton()
        
        fetchData()
    }
    
    func layoutButton() {
        let playerButton = UIButton()
        
        self.view.addSubview(playerButton)
        
        playerButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint(item: playerButton, attribute: .bottom, relatedBy: .equal, toItem: view.safeAreaLayoutGuide, attribute: .bottom, multiplier: 1, constant: -60).isActive = true
        
        NSLayoutConstraint(item: playerButton, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 40).isActive = true
        
        NSLayoutConstraint(item: playerButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 40).isActive = true
        
        NSLayoutConstraint(item: playerButton, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1, constant: -36).isActive = true
        
        playerButton.setImage(UIImage(systemName: "play"), for: .normal)
        
        playerButton.isEnabled = true
        
        playerButton.addTarget(self, action: #selector(playAudioFile), for: .touchUpInside)
    
    }
    
    
    func fetchData() {
        AudioManager.shared.fetchAudioFiles { [weak self] result in
            
            switch result {
            
            case .success(let audioFiles):
                
                self?.datas = audioFiles
                
            case .failure(let error):
                
                print("fetchData.failure: \(error)")
            }
            
        }

    }
    
    
    @objc func playAudioFile(_ sender: Any) {
        
        AudioManager.shared.playAudioFile(url: datas[selectedAudioIndex ?? 0].audioUrl)
        
    }

    
}

class AudioPlayerView: UIView {
    
    
    let nibName = "AudioPlayerView"
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        guard let view = loadViewFromNib() else { return }
        view.frame = self.bounds
        self.addSubview(view)
    }
    
    private func loadViewFromNib() -> UIView? {
        let nib = UINib(nibName: nibName, bundle: nil)
        return nib.instantiate(withOwner: self, options: nil).first as? UIView
    }
    
}

