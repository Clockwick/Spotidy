//
//  LibraryPlaylistsViewController.swift
//  Spotify
//
//  Created by Paratthakorn Sribunyong on 20/7/2564 BE.
//

import UIKit

class LibraryPlaylistsViewController: UIViewController {

    var playlists = [Playlist]()
    
    private let noPlaylistsView = ActionLabelView()
    
    private let tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
        table.register(SearchResultSubtitleTableViewCell.self, forCellReuseIdentifier: SearchResultSubtitleTableViewCell.identifier)
        table.isHidden = true
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
        setUpNoPlaylistsViews()
        fetchPlaylists()
        
    }
    
    
    
    private func fetchPlaylists() {
        APICaller.shared.getCurrentUserPlaylists { [weak self](result) in
            DispatchQueue.main.async {
                switch result {
                case .success(let playlists):
                    self?.playlists = playlists
                    self?.updateUI()
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    private func setUpNoPlaylistsViews() {
        noPlaylistsView.delegate = self
        view.addSubview(noPlaylistsView)
        noPlaylistsView.configure(with: ActionLabelViewViewModel(text: "You don't have any playlists yet.", actionTitle: "Create"))
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        noPlaylistsView.frame = CGRect(x: 0, y: 0, width: 150, height: 150)
        noPlaylistsView.center = view.center
        
        tableView.frame = view.bounds
    }
    
    private func updateUI() {
        if playlists.isEmpty {
            // Show label
            noPlaylistsView.isHidden = false
            
        }
        else {
            // Show table
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
            noPlaylistsView.isHidden = true
            tableView.isHidden = false
        }
        
    }
    
    public func showCreatePlaylistAlert() {
        let alert = UIAlertController(
            title: "New Playlists",
            message: "Enter playlist name",
            preferredStyle: .alert
        )
        alert.addTextField { (textField) in
            textField.placeholder = "playlist..."
        }
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Create", style: .default, handler: { _ in
            guard let field = alert.textFields?.first,
                  let text = field.text,
                  !text.trimmingCharacters(in: .whitespaces).isEmpty else {
                return
            }
            APICaller.shared.createPlaylist(with: text) { (success) in
                if success {
                    // Refresh list of playlists
                    self.fetchPlaylists()
                }
                else {
                    print("Failed to create playlist")
                    
                }
            }
        }))
        present(alert, animated: true, completion: nil)
    }
    
}

extension LibraryPlaylistsViewController: ActionLabelViewDelegate {
    func actionLabelViewDidTapButon(_ actionView: ActionLabelView) {
        // Show creation UI

        showCreatePlaylistAlert()
    }
}


extension LibraryPlaylistsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return playlists.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchResultSubtitleTableViewCell.identifier, for: indexPath) as? SearchResultSubtitleTableViewCell else {
            return UITableViewCell()
        }
        let playlist = playlists[indexPath.row]
        cell.configure(with: SearchResultSubtitleTableViewCellViewModel(title: playlist.name, subtitle: playlist.owner.display_name, imageURL: URL(string: playlist.images.first?.url ?? "")))
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let playlist = playlists[indexPath.row]
        let vc = PlaylistViewController(playlist: playlist)
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
}
