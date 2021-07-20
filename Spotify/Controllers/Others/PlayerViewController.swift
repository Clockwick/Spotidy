//
//  PlayerViewController.swift
//  Spotify
//
//  Created by Paratthakorn Sribunyong on 10/7/2564 BE.
//

import UIKit
import SDWebImage
import AVFoundation

protocol PlayerViewControllerDelegate: AnyObject {
    func didTapPlayPauseButton()
    func didTapPreviousButton()
    func didTapNextButton()
    func didSlideSlider(_ value: Float)
}

class PlayerViewController: UIViewController {
    
    weak var dataSource: PlayerDataSource?
    weak var delegate: PlayerViewControllerDelegate?
    
    private let controlsView = PlayerControlsView()
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
        
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(imageView)
        view.addSubview(controlsView)
        controlsView.delegate = self
        configureBarButtons()
        configure()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        imageView.frame = CGRect(x: 0, y: view.safeAreaInsets.top, width: view.width, height: view.width)
        controlsView.frame = CGRect(x: 10,
                                    y: imageView.bottom + 10,
                                    width: view.width - 20,
                                    height: view.height - imageView.height - view.safeAreaInsets.top - view.safeAreaInsets.bottom - 15)
        
    }
    
    func refreshUI() {
        configure()
    }
    
    private func configure() {
        imageView.sd_setImage(with: dataSource?.imageURL, completed: nil)
        controlsView.configure(with: PlayerControlsViewViewModel(title: dataSource?.songName, subtitle: dataSource?.subtitle))
    }
    
    private func configureBarButtons() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(didTapClose))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(didTapAction))
    }
    
    @objc private func didTapClose() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func didTapAction() {
        // Actions
    }
    

}

extension PlayerViewController: PlayerControlsViewDelegate {
    func playerControlsViewDidTapPlayPause(_ playerControlsView: PlayerControlsView) {
        delegate?.didTapPlayPauseButton()
    }
    
    func playerControlsViewDidTapPreviousButton(_ playerControlsView: PlayerControlsView) {
        delegate?.didTapPreviousButton()
    }
    
    func playerControlsViewDidTapNextButton(_ playerControlsView: PlayerControlsView) {
        delegate?.didTapNextButton()
    }
    
    func playerControlsView(_ playerControlsView: PlayerControlsView, didSlideSlider value: Float) {
        delegate?.didSlideSlider(value)
    }
    
}
