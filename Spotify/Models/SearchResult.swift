//
//  SearchResult.swift
//  Spotify
//
//  Created by Paratthakorn Sribunyong on 16/7/2564 BE.
//

import Foundation

enum SearchResult {
    case artist(model: Artist)
    case album(model: Album)
    case playlist(model: Playlist)
    case track(model: AudioTrack)
}
