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

protocol ItemDetailLoader {
    func getItemDetail() -> Observable<MenuItem>
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
    let httpClient: HttpClient
    
    init(httpClient:HttpClient) {
        self.httpClient = httpClient
    }
    
    func getMenu() -> Observable<[Category]> {
        let url = "https://mock.vouchconcierge.com/ios/catalogue/home"
        return httpClient.load(urlString: url).map{data -> [Category] in
            return try HomeDtoMapper.map(data: data)
        }
    }
}

class RemoteItemDetailLoader : ItemDetailLoader {
    let httpClient: HttpClient
    
    init(httpClient:HttpClient) {
        self.httpClient = httpClient
    }
    
    func getItemDetail() -> Observable<MenuItem> {
        let url = "https://mock.vouchconcierge.com/ios/catalogue/detail"
        return httpClient.load(urlString: url).map{data -> MenuItem in
            return try DetailDtoMapper.map(data: data)
        }
    }
}
