//
//  MenuItem.swift
//  RestoApp-iOS
//
//  Created by Fahim Jatmiko on 19/03/22.
//

import Foundation

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
