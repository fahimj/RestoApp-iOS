//
//  DetailCodable.swift
//  RestoApp-iOS
//
//  Created by Fahim Jatmiko on 25/03/22.
//

struct DetailRoot : Codable {

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
    
//    init(from decoder: Decoder) throws {
//        let values = try decoder.container(keyedBy: CodingKeys.self)
//        id = try values.decodeIfPresent(String.self, forKey: .id)
//        addons = try values.decodeIfPresent([DetailAddon].self, forKey: .addons)
//        descriptionField = try values.decodeIfPresent(String.self, forKey: .descriptionField)
//        discountPercent = try values.decodeIfPresent(Int.self, forKey: .discountPercent)
//        displayPrice = try values.decodeIfPresent(Int.self, forKey: .displayPrice)
//        imageUrl = try values.decodeIfPresent(String.self, forKey: .imageUrl)
//        isDiscount = try values.decodeIfPresent(Bool.self, forKey: .isDiscount)
//        name = try values.decodeIfPresent(String.self, forKey: .name)
//        price = try values.decodeIfPresent(Int.self, forKey: .price)
//        tags = try values.decodeIfPresent([String].self, forKey: .tags)
//        variants = try values.decodeIfPresent([DetailVariant].self, forKey: .variants)
//    }
}

struct DetailVariant : Codable {

    let id : String
    let name : String


    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case name = "name"
    }
//    init(from decoder: Decoder) throws {
//        let values = try decoder.container(keyedBy: CodingKeys.self)
//        id = try values.decodeIfPresent(String.self, forKey: .id)
//        name = try values.decodeIfPresent(String.self, forKey: .name)
//    }


}

struct DetailAddon : Codable {

    let addonCategoryId : String
    let addonCateogryName : String
    let addonItems : [DetailAddonItem]


    enum CodingKeys: String, CodingKey {
        case addonCategoryId = "addon_category_id"
        case addonCateogryName = "addon_cateogry_name"
        case addonItems = "addon_items"
    }
//    init(from decoder: Decoder) throws {
//        let values = try decoder.container(keyedBy: CodingKeys.self)
//        addonCategoryId = try values.decodeIfPresent(String.self, forKey: .addonCategoryId)
//        addonCateogryName = try values.decodeIfPresent(String.self, forKey: .addonCateogryName)
//        addonItems = try values.decodeIfPresent([DetailAddonItem].self, forKey: .addonItems)
//    }
}

struct DetailAddonItem : Codable {

    let id : String
    let additionalPrice : Double
    let name : String


    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case additionalPrice = "additional_price"
        case name = "name"
    }
//    init(from decoder: Decoder) throws {
//        let values = try decoder.container(keyedBy: CodingKeys.self)
//        id = try values.decodeIfPresent(String.self, forKey: .id)
//        additionalPrice = try values.decodeIfPresent(Int.self, forKey: .additionalPrice)
//        name = try values.decodeIfPresent(String.self, forKey: .name)
//    }


}
