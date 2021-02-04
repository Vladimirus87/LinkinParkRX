//
//  TracksTableViewVC.swift
//  LinkinParkRX
//
//  Created by Vladimirus on 04.02.2021.
//

import UIKit
import RxSwift
import RxCocoa

class TracksTableViewVC: UIViewController {

    @IBOutlet private weak var tracksTableView: UITableView!
    
    private let cellIdentifier = "TrackTableViewCell"
    private let bag = DisposeBag()
    
    public var tracks = PublishSubject<[Track]>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupBinding()
    }
    
    
    private func setupUI() {
        tracksTableView.rowHeight = 60
        tracksTableView.tableFooterView = UIView()
    }
    

    private func setupBinding() {
        let nib = UINib(nibName: cellIdentifier, bundle: nil)
        tracksTableView.register(nib, forCellReuseIdentifier: cellIdentifier)
        
        tracks.bind(to: tracksTableView.rx.items(cellIdentifier: cellIdentifier, cellType: TrackTableViewCell.self)) {row, track, cell in
            cell.updateData(cellTrack: track)
        }.disposed(by: bag)
        
    }

}
