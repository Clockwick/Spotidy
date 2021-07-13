//
//  AuthResponse.swift
//  Spotify
//
//  Created by Paratthakorn Sribunyong on 12/7/2564 BE.
//

import Foundation

struct AuthResponse: Codable {
    let access_token: String
    let expires_in: Int
    let refresh_token: String?
    let scope: String
    let token_type: String
}
