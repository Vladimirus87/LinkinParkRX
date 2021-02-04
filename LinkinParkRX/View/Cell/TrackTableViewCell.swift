//
//  TrackTableViewCell.swift
//  LinkinParkRX
//
//  Created by Vladimirus on 04.02.2021.
//

import UIKit
import Kingfisher

class TrackTableViewCell: UITableViewCell {

    @IBOutlet weak var trackImage : UIImageView!
    @IBOutlet weak var trackArtist : UILabel!
    @IBOutlet weak var trackTitle: UILabel!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.trackImage.clipsToBounds = true
        self.trackImage.layer.cornerRadius = 3
    }

    func updateData(cellTrack: Track) {
        self.trackTitle.text = cellTrack.name
        self.trackArtist.text = cellTrack.artist
        
        if let urlImage = URL(string: cellTrack.trackArtWork) {
            let placeholder = #imageLiteral(resourceName: "background")
            self.trackImage.kf.setImage(with: urlImage, placeholder: placeholder)
        }
    }
    
}
