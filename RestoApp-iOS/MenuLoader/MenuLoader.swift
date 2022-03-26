//
//  MenuLoader.swift
//  RestoApp-iOS
//
//  Created by Fahim Jatmiko on 26/03/22.
//

import Foundation
import RxSwift
import RxCocoa

protocol MenuLoader {
    func getMenu() -> Observable<[Category]>
}

protocol HttpClient {
    func load(urlString:String) -> Observable<Data>
}

class UrlSessionHttpClient : HttpClient {
    enum HttpClientError : Error {
        case invalidUrl
        case responseError
    }
    
    private let session: URLSession
    
    public init(session: URLSession) {
        self.session = session
    }
    
    func load(urlString:String) -> Observable<Data> {
        guard let url = URL.init(string: urlString) else {
            return .error(HttpClientError.invalidUrl)
        }
        
        let request = URLRequest(url: url)
        
        return session.rx.response(request: request)
            .debug("r")
            .map{ response in
                guard response.response.statusCode == 200 else {
                    throw HttpClientError.responseError
                }
                return response.data
            }
    }
}

class RemoteMenuLoader : MenuLoader {
    func getMenu() -> Observable<[Category]> {
        return .just([])
    }
}
