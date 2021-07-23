//
//  LibraryAlbumResponse.swift
//  Spotify
//
//  Created by Paratthakorn Sribunyong on 23/7/2564 BE.
//

import Foundation

struct LibraryAlbumResponse: Codable {
    let items: [SavedAlbum]
}

struct SavedAlbum: Codable {
    let album: Album
    let added_at: String
}

