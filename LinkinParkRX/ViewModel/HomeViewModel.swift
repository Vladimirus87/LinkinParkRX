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
import Alamofire

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
    
    
    public func AFRequestData() {
        let urlTailString = "dcd86ebedb5e519fd7b09b79dd4e4558/raw/b7505a54339f965413f5d9feb05b67fb7d0e464e/MvvmExampleApi.json"
        let header: HTTPHeader =  HTTPHeader(name: "Content-Type", value: "application/x-www-form-urlencoded")
        self.loading.onNext(true)
        AF.request(APIManager.baseUrl + urlTailString, headers: [header])
            .validate()
            .responseDecodable(of: LinlinData.self) { [weak self] (response) in
            self?.loading.onNext(false)
                switch response.result {
                case .success(let linkinData):
                    self?.albums.onNext(linkinData.Albums ?? [])
                    self?.tracks.onNext(linkinData.Tracks ?? [])
                case .failure(let error):
                    switch error.responseCode {
                    case 404:
                        self?.error.onNext(.serverMessage("Not Found"))
                    default:
                        if let data = response.data, let errorInfo = try? JSONDecoder().decode(ErrorInfo.self, from: data) {
                            self?.error.onNext(.serverMessage(errorInfo.message))
                            return
                        }
                        
                        if error.isResponseSerializationError {
                            print(error)
                            self?.error.onNext(.parseError("Sorry, parsing error"))
                        } else {
                            self?.error.onNext(.internetError(error.localizedDescription))
                        }
                    }
                    
                }
            
            
        }
        
    }
    
    
}
