//
//  Album.swift
//  LinkinParkRX
//
//  Created by Vladimirus on 04.02.2021.
//

import Foundation

struct Album: Codable {
    
    let id, name, albumArtWork, artist: String

    enum CodingKeys: String, CodingKey {
        case id, name
        case albumArtWork = "album_art_work"
        case artist
    }
}
