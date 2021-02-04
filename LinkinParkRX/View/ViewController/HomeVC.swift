//
//  HomeVC.swift
//  LinkinParkRX
//
//  Created by Vladimirus on 04.02.2021.
//

import UIKit
import RxCocoa
import RxSwift

class HomeVC: UIViewController {
    
    @IBOutlet weak var albumsVCView: UIView!
    @IBOutlet weak var tracksVCView: UIView!
    
    private lazy var albumsViewController: AlbumsCollectionViewVC = {
        let storyboard = UIStoryboard(name: "Home", bundle: nil)
        var vc = storyboard.instantiateViewController(withIdentifier: "AlbumsCollectionViewVC") as! AlbumsCollectionViewVC
        self.add(asChildViewController: vc, to: albumsVCView)
        return vc
    }()
    
    private lazy var tracksViewController: TracksTableViewVC = {
        let storyboard = UIStoryboard(name: "Home", bundle: nil)
        var vc = storyboard.instantiateViewController(withIdentifier: "TracksTableViewVC") as! TracksTableViewVC
        self.add(asChildViewController: vc, to: tracksVCView)
        return vc
    }()
    
    
    var homeViewModel = HomeViewModel()
    
    let bag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addBlurArea(area: self.view.frame, style: .dark)
        setupBindings()
        homeViewModel.AFRequestData()
    }
    

    private func setupBindings() {
        
        // binding loading to vc
        homeViewModel.loading
            .bind(to: self.rx.isAnimating)
            .disposed(by: bag)
        
        // observing errors to show
        homeViewModel.error
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { error in
                switch error {
                case .internetError(let message):
                    MessageView.sharedInstance.showOnView(message: message, theme: .error)
                case .parseError(let message):
                    MessageView.sharedInstance.showOnView(message: message, theme: .error)
                case .serverMessage(let message):
                    MessageView.sharedInstance.showOnView(message: message, theme: .warning)
                }
            }).disposed(by: bag)
        
        
        // binding albums to album container
        homeViewModel.albums
            .observeOn(MainScheduler.instance)
            .bind(to: albumsViewController.albums)
            .disposed(by: bag)
     
        // binding tracks to track container
        homeViewModel.tracks
            .observeOn(MainScheduler.instance)
            .bind(to: tracksViewController.tracks)
            .disposed(by: bag)
    }

    

}
