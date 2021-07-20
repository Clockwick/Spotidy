//
//  LibraryViewController.swift
//  Spotify
//
//  Created by Paratthakorn Sribunyong on 10/7/2564 BE.
//

import UIKit

class LibraryViewController: UIViewController {
    
    private let playlistsVC = LibraryPlaylistsViewController()
    private let albumsVC = LibraryAlbumsViewController()
    
    private let toggleView = LibraryToggleView()
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.isPagingEnabled = true
        return scrollView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        scrollView.delegate = self
        toggleView.delegate = self
        scrollView.contentSize = CGSize(width: view.width * 2, height: scrollView.height)
        view.addSubview(scrollView)
        view.addSubview(toggleView)
        addChildren()
    }
    

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        scrollView.frame = CGRect(x: 0, y: view.safeAreaInsets.top + 55, width: view.width, height: view.height - view.safeAreaInsets.top - view.safeAreaInsets.bottom - 55)
        toggleView.frame = CGRect(x: 10, y: view.safeAreaInsets.top, width: 200, height: 55)
    }
    
    private func addChildren() {
        addChild(playlistsVC)
        scrollView.addSubview(playlistsVC.view)
        playlistsVC.view.frame = CGRect(x: 0, y: 0, width: scrollView.width, height: scrollView.height)
        playlistsVC.didMove(toParent: self)
        
        addChild(albumsVC)
        scrollView.addSubview(albumsVC.view)
        playlistsVC.view.frame = CGRect(x: view.width, y: 0, width: scrollView.width, height: scrollView.height)
        playlistsVC.didMove(toParent: self)
    }
}

extension LibraryViewController: UIScrollViewDelegate  {

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.x >= (view.width - 100) {
            toggleView.update(for: .album)
        }
        else {
            toggleView.update(for: .playlist)
        }
    }
}


extension LibraryViewController: LibraryToggleViewDelegate  {
    func libraryToggleViewDidTapPlaylist(_ toggleView: LibraryToggleView) {
        scrollView.setContentOffset(.zero, animated: true)
    }
    
    func libraryToggleViewDidTapAlbums(_ toggleView: LibraryToggleView) {
        scrollView.setContentOffset(CGPoint(x: view.width, y: 0), animated: true)
    }
    

}
