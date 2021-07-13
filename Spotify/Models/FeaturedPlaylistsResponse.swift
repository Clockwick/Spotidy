//
//  FeaturePlaylistsResponse.swift
//  Spotify
//
//  Created by Paratthakorn Sribunyong on 13/7/2564 BE.
//

import Foundation

struct FeaturedPlaylistsResponse: Codable {
    let playlists: PlaylistResponse
    
}

struct PlaylistResponse: Codable {
    let items: [Playlist]
}


struct User: Codable {
    let display_name: String
    let external_urls: [String: String]
    let id: String
}

