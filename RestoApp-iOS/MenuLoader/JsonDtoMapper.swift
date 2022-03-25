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
    
    func map(data:Data) throws -> [HomeItem] {
        let decoder = JSONDecoder()
        let json = try decoder.decode(HomeRoot.self, from: data)
        guard let itemList = json.list else {throw JsonMapperError.invalidJson}
//        return itemList
//        guard let bpis = json.bpi else {throw JsonMapperError.invalidJson }
//
//        let dtos = [bpis.eur!, bpis.gbp!, bpis.usd!]
//        let items = dtos.map{bpi in
//            Price(pairName: "BTC" + bpi.code!, price: bpi.rateFloat!, date: Date())
//        }
//        return items
        return []
    }
}
