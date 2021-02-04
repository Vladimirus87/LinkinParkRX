//
//  HomeViewModel.swift
//  LinkinParkRX
//
//  Created by Vladimirus on 04.02.2021.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

class HomeViewModel {
    
    public enum HomeError {
        case internetError(String)
        case serverMessage(String)
        case parseError(String)
    }
    
    public let albums : PublishSubject<[Album]> = PublishSubject()
    public let tracks : PublishSubject<[Track]> = PublishSubject()
    public let loading: PublishSubject<Bool> = PublishSubject()
    public let error : PublishSubject<HomeError> = PublishSubject()
    
    private let disposable = DisposeBag()
    
    public func requestData() {
        let urlTailString = "dcd86ebedb5e519fd7b09b79dd4e4558/raw/b7505a54339f965413f5d9feb05b67fb7d0e464e/MvvmExampleApi.json"
        self.loading.onNext(true)
        APIManager.requestData(url: urlTailString,
                               method: .get,
                               parameters: nil) { [weak self] (result) in
            self?.loading.onNext(false)
            switch result {
            case .success(let resultData):
                do {
                    let linkinData = try JSONDecoder().decode(LinlinData.self, from: resultData)
                    self?.albums.onNext(linkinData.Albums ?? [])
                    self?.tracks.onNext(linkinData.Tracks ?? [])
                } catch {
                    self?.error.onNext(HomeError.parseError(error.localizedDescription))
                }
                
            case .failure(let requestError):
                switch requestError {
                case .connectionError:
                    self?.error.onNext(.internetError("Check your Internet connection."))
                case .authorizationError(let errorData):
                    do {
                        let errorInfo = try JSONDecoder().decode(ErrorInfo.self, from: errorData)
                        self?.error.onNext(.serverMessage(errorInfo.message))
                    } catch {
                        self?.error.onNext(HomeError.parseError(error.localizedDescription))
                    }
                default:
                    self?.error.onNext(.serverMessage("Unknown Error"))
                }
            }
            
        }
    }
    
    
}
