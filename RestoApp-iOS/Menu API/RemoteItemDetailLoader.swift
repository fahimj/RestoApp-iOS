//
//  ItemDetailLoader.swift
//  RestoApp-iOS
//
//  Created by Fahim Jatmiko on 26/03/22.
//

import Foundation
import RxSwift

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
