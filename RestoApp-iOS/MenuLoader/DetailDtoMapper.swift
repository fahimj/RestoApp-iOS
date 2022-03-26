//
//  DetailDtoMapper.swift
//  RestoApp-iOS
//
//  Created by Fahim Jatmiko on 26/03/22.
//

import Foundation

final class DetailDtoMapper {
    enum JsonMapperError: Error {
        case invalidJson
    }
    
    private init() {}
    
    static func map(data:Data) throws -> MenuItem {
        let decoder = JSONDecoder()
        guard let json = try? decoder.decode(DetailRoot.self, from: data) else {throw JsonMapperError.invalidJson}
        let menuItem = json.menuItem
        return menuItem
    }
}
