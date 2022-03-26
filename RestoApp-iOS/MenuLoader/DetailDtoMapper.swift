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
    
    private struct DetailRoot : Codable {

        let id : String
        let addons : [DetailAddon]
        let descriptionField : String
        let discountPercent : Int
        let displayPrice : Double
        let imageUrl : String
        let isDiscount : Bool
        let name : String
        let price : Double
        let tags : [String]
        let variants : [DetailVariant]

        enum CodingKeys: String, CodingKey {
            case id = "_id"
            case addons = "addons"
            case descriptionField = "description"
            case discountPercent = "discount_percent"
            case displayPrice = "display_price"
            case imageUrl = "image_url"
            case isDiscount = "is_discount"
            case name = "name"
            case price = "price"
            case tags = "tags"
            case variants = "variants"
        }
        
        var menuItem:MenuItem {
            let variants = variants.map{Variant(id: $0.id, name: $0.name)}
            let addonCategories = self.addons.map{dto -> AddonCategory in
                let addons = dto.addonItems.map{Addon(id: $0.id, name: $0.name, additionalPrice: $0.additionalPrice)}
                return AddonCategory(id: dto.addonCategoryId, name: dto.addonCateogryName, addons: addons)
            }
            return MenuItem(id: id, descriptionField: descriptionField, discountPercent: discountPercent, displayPrice: displayPrice, imageUrl: imageUrl, isDiscount: isDiscount, name: name, price: price, tags: tags, variants: variants, addOnCategories: addonCategories)
        }
    }

    private struct DetailVariant : Codable {

        let id : String
        let name : String


        enum CodingKeys: String, CodingKey {
            case id = "_id"
            case name = "name"
        }
    }

    private struct DetailAddon : Codable {

        let addonCategoryId : String
        let addonCateogryName : String
        let addonItems : [DetailAddonItem]


        enum CodingKeys: String, CodingKey {
            case addonCategoryId = "addon_category_id"
            case addonCateogryName = "addon_cateogry_name"
            case addonItems = "addon_items"
        }
    }

    private struct DetailAddonItem : Codable {

        let id : String
        let additionalPrice : Double
        let name : String

        enum CodingKeys: String, CodingKey {
            case id = "_id"
            case additionalPrice = "additional_price"
            case name = "name"
        }
    }

    
    private init() {}
    
    static func map(data:Data) throws -> MenuItem {
        let decoder = JSONDecoder()
        guard let json = try? decoder.decode(DetailRoot.self, from: data) else {throw JsonMapperError.invalidJson}
        let menuItem = json.menuItem
        return menuItem
    }
}
