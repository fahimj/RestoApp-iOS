//
//  MenuLoader.swift
//  RestoApp-iOS
//
//  Created by Fahim Jatmiko on 26/03/22.
//

import Foundation
import RxSwift

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
