//
//  AlbumsCollectionViewVC.swift
//  LinkinParkRX
//
//  Created by Vladimirus on 04.02.2021.
//

import UIKit
import RxSwift
import RxCocoa

class AlbumsCollectionViewVC: UIViewController {

    @IBOutlet private weak var albumsCollectionView: UICollectionView!
    
    private let cellIdentifier = "AlbumCollectionViewCell"
    
    public var albums = PublishSubject<[Album]>()
    
    private let bag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setCollectionView()
        setupBindings()
    }
    
    private func setCollectionView() {
        let width: CGFloat = 133
        let cellSize = CGSize(width: width, height: albumsCollectionView.frame.height)
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = cellSize
        layout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        layout.minimumLineSpacing = 10
        albumsCollectionView.setCollectionViewLayout(layout, animated: false)
        albumsCollectionView.reloadData()
    }
    

    private func setupBindings() {
        let nib = UINib(nibName: cellIdentifier, bundle: nil)
        albumsCollectionView.register(nib, forCellWithReuseIdentifier: cellIdentifier)
        
        albums.bind(to: albumsCollectionView.rx.items(cellIdentifier: cellIdentifier, cellType: AlbumCollectionViewCell.self)) { row, album, cell in
            cell.updateData(album: album)
        }.disposed(by: bag)
        
    }

}
