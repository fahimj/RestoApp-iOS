//
//  JsonDtoMapper.swift
//  RestoApp-iOS
//
//  Created by Fahim Jatmiko on 19/03/22.
//

import Foundation

struct JsonDtoMapper {
    enum JsonMapperError: Error {
        case invalidJson
    }
    
    func map(data:Data) throws -> [Category] {
        let decoder = JSONDecoder()
        guard let json = try? decoder.decode(HomeRoot.self, from: data) else {throw JsonMapperError.invalidJson}
        let itemList = json.categoryItems
        return itemList
    }
}
