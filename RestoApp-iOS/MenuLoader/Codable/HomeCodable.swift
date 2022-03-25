//
//  HomeCodable.swift
//  RestoApp-iOS
//
//  Created by Fahim Jatmiko on 25/03/22.
//

import Foundation

struct HomeRoot : Codable {
    let categories : [HomeCategory]?
    let list : [HomeList]?

    enum CodingKeys: String, CodingKey {
        case categories = "categories"
        case list = "list"
    }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        categories = try values.decodeIfPresent([HomeCategory].self, forKey: .categories)
        list = try values.decodeIfPresent([HomeList].self, forKey: .list)
    }
}

struct HomeList : Codable {
    let categoryId : String?
    let items : [HomeItem]?

    enum CodingKeys: String, CodingKey {
        case categoryId = "category_id"
        case items = "items"
    }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        categoryId = try values.decodeIfPresent(String.self, forKey: .categoryId)
        items = try values.decodeIfPresent([HomeItem].self, forKey: .items)
    }
}

struct HomeItem : Codable {
    let id : String?
    let descriptionField : String?
    let discountPercent : Int?
    let displayPrice : Int?
    let imageUrl : String?
    let isDiscount : Bool?
    let name : String?
    let price : Int?
    let tags : [String]?

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
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(String.self, forKey: .id)
        descriptionField = try values.decodeIfPresent(String.self, forKey: .descriptionField)
        discountPercent = try values.decodeIfPresent(Int.self, forKey: .discountPercent)
        displayPrice = try values.decodeIfPresent(Int.self, forKey: .displayPrice)
        imageUrl = try values.decodeIfPresent(String.self, forKey: .imageUrl)
        isDiscount = try values.decodeIfPresent(Bool.self, forKey: .isDiscount)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        price = try values.decodeIfPresent(Int.self, forKey: .price)
        tags = try values.decodeIfPresent([String].self, forKey: .tags)
    }
}

struct HomeCategory : Codable {
    let id : String?
    let name : String?

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case name = "name"
    }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(String.self, forKey: .id)
        name = try values.decodeIfPresent(String.self, forKey: .name)
    }
}
