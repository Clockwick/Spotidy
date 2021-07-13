//
//  Playlist.swift
//  Spotify
//
//  Created by Paratthakorn Sribunyong on 10/7/2564 BE.
//

import Foundation

struct Playlist: Codable {
    let description: String
    let external_urls: [String: String]
    let id: String
    let images: [APIImage]
    let name: String
    let owner: User
}
