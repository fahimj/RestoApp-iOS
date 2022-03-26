//
//  HomeCodable.swift
//  RestoApp-iOS
//
//  Created by Fahim Jatmiko on 25/03/22.
//

import Foundation

struct HomeRoot : Decodable {
    let categories : [HomeCategory]
    var list : [HomeList]

    enum CodingKeys: String, CodingKey {
        case categories = "categories"
        case list = "list"
    }
    
    var categoryItems:[Category] {
        var resultCategories = categories.map{Category(id: $0.id ?? "", name: $0.name ?? "", items: [])}
        list.forEach({listItem in
            let menuItems = listItem.items.map{MenuItem(id: $0.id, descriptionField: $0.descriptionField, discountPercent: $0.discountPercent, displayPrice: $0.displayPrice, imageUrl: $0.imageUrl, isDiscount: $0.isDiscount, name: $0.name, price: $0.price, tags: $0.tags, variants: [], addOnCategories: [])}
            guard let categoryIndex = resultCategories.firstIndex(where: {$0.id == listItem.categoryId}) else {return}
            resultCategories[categoryIndex].items = menuItems
        })
        
        return resultCategories
    }
}

struct HomeList : Decodable {
    let categoryId : String
    let items : [HomeItem]

    enum CodingKeys: String, CodingKey {
        case categoryId = "category_id"
        case items = "items"
    }
}

struct HomeItem : Decodable {
    let id : String
    let descriptionField : String
    let discountPercent : Int
    let displayPrice : Double
    let imageUrl : String
    let isDiscount : Bool
    let name : String
    let price : Double
    let tags : [String]

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case descriptionField = "description"
        case discountPercent = "discount_percent"
        case displayPrice = "display_price"
        case imageUrl = "image_url"
        case isDiscount = "is_discount"
        case name = "name"
        case price = "price"
        case tags = "tags"
    }
}

struct HomeCategory : Decodable {
    let id : String?
    let name : String?

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case name = "name"
    }
}
