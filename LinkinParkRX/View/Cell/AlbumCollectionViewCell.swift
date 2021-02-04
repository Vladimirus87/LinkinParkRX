//
//  AlbumCollectionViewCell.swift
//  LinkinParkRX
//
//  Created by Vladimirus on 04.02.2021.
//

import UIKit

class AlbumCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var albumImage: UIImageView!
    @IBOutlet weak var albumTitle: UILabel!
    @IBOutlet weak var albumArtist: UILabel!
    

    
    func updateData(album: Album) {
        self.albumTitle.text = album.name
        self.albumArtist.text = album.artist
        
        if let urlImage = URL(string: album.albumArtWork) {
            let placeholder = #imageLiteral(resourceName: "background")
            self.albumImage.kf.setImage(with: urlImage, placeholder: placeholder)
        }
    }
}
