//
//  SettingsModels.swift
//  Spotify
//
//  Created by Paratthakorn Sribunyong on 13/7/2564 BE.
//

import Foundation

struct Section {
    let title: String
    let options: [Option]
}

struct Option {
    let title: String
    let handler: () -> Void
}
