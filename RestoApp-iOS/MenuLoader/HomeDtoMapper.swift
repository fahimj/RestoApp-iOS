//
//  JsonDtoMapper.swift
//  RestoApp-iOS
//
//  Created by Fahim Jatmiko on 19/03/22.
//

import Foundation

final class HomeDtoMapper {
    enum JsonMapperError: Error {
        case invalidJson
    }
    
    private init() {}
    
    static func map(data:Data) throws -> [Category] {
        let decoder = JSONDecoder()
        guard let json = try? decoder.decode(HomeRoot.self, from: data) else {throw JsonMapperError.invalidJson}
        let itemList = json.categoryItems
        return itemList
    }
}
