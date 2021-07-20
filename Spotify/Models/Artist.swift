//
//  Artist.swift
//  Spotify
//
//  Created by Paratthakorn Sribunyong on 10/7/2564 BE.
//

import Foundation

struct Artist: Codable {
    let id: String
    let name: String
    let type: String
    let external_urls: [String: String]
    let images: [APIImage]?
}
