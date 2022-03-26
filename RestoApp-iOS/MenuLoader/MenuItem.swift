//
//  MenuItem.swift
//  RestoApp-iOS
//
//  Created by Fahim Jatmiko on 19/03/22.
//

import Foundation

struct Category {
    let id: String
    let name: String
    
    var items:[MenuItem]
}

struct MenuItem {
    let id : String
    let descriptionField : String
    let discountPercent : Int
    let displayPrice : Double
    let imageUrl : String
    let isDiscount : Bool
    let name : String
    let price : Double
    let tags : [String]
    
    let variants:[Variant]
    let addOnCategories:[AddonCategory]
}

struct Variant {
    let id: String
    let name: String
}

struct AddonCategory {
    let id: String
    let name: String
    
    let addons:[Addon]
}

struct Addon {
    let id: String
    let name: String
    let additionalPrice: Double
}
