//
//  LibraryAlbumsViewController.swift
//  Spotify
//
//  Created by Paratthakorn Sribunyong on 20/7/2564 BE.
//

import UIKit

class LibraryAlbumsViewController: UIViewController {
    
    var albums = [Album]()
    
    private let noAlbumsView = ActionLabelView()
    
    private let tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
        table.register(SearchResultSubtitleTableViewCell.self, forCellReuseIdentifier: SearchResultSubtitleTableViewCell.identifier)
        table.isHidden = true
        return table
    }()
    
    private var observer: NSObjectProtocol?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setUpNoAlbumsViews()
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
        fetchAlbums()
        observer = NotificationCenter.default.addObserver(
            forName: .albumSavedNotification,
            object: nil,
            queue: .main,
            using: { [weak self] _ in
                self?.fetchAlbums()
        })
        
    }
    
    @objc private func didTapClose() {
        dismiss(animated: true, completion: nil)
    }
    
    
    private func fetchAlbums() {
        albums.removeAll()
        APICaller.shared.getCurrentUserAlbums { [weak self] (result) in
            DispatchQueue.main.async {
                switch result {
                case .success(let albums):
                    self?.albums = albums
                    self?.updateUI()
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    private func setUpNoAlbumsViews() {
        noAlbumsView.delegate = self
        view.addSubview(noAlbumsView)
        noAlbumsView.configure(with: ActionLabelViewViewModel(text: "You don't have saved any albums yet.", actionTitle: "Browse"))
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        noAlbumsView.frame = CGRect(x: (view.width - 150) / 2, y: (view.height - 150) / 2, width: 150, height: 150)
        tableView.frame = CGRect(x: 0, y: 0, width: view.width, height: view.height)
    }
    
    private func updateUI() {
        if albums.isEmpty {
            // Show label
            noAlbumsView.isHidden = false
            tableView.isHidden = true
        }
        else {
            // Show table
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
            noAlbumsView.isHidden = true
            tableView.isHidden = false
        }
        
    }
    
}

extension LibraryAlbumsViewController: ActionLabelViewDelegate {
    func actionLabelViewDidTapButon(_ actionView: ActionLabelView) {
        // Show creation UI
        tabBarController?.selectedIndex = 0
    }
}


extension LibraryAlbumsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return albums.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchResultSubtitleTableViewCell.identifier, for: indexPath) as? SearchResultSubtitleTableViewCell else {
            return UITableViewCell()
        }
        let album = albums[indexPath.row]
        cell.configure(with: SearchResultSubtitleTableViewCellViewModel(title: album.name, subtitle: album.artists.first?.name ?? "Unknown", imageURL: URL(string: album.images.first?.url ?? "")))
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        HapticManager.shared.vibrateForSelection()
        let album = albums[indexPath.row]
        let vc = AlbumViewController(album: album)
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }

}


