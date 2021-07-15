//
//  AllCategoriesResponse.swift
//  Spotify
//
//  Created by Paratthakorn Sribunyong on 15/7/2564 BE.
//

import Foundation

struct AllCategoriesResponse: Codable {
    let categories: Categories
}

struct Categories: Codable {
    let items: [Category]
}

struct Category: Codable {
    let id: String
    let name: String
    let icons: [APIImage]
}
