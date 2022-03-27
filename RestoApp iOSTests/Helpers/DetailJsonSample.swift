//
//  DetailJsonSample.swift
//  RestoApp-iOS
//
//  Created by Fahim Jatmiko on 27/03/22.
//

import Foundation

final class DetailJsonSample {
    private init() {}
    static var text:String {
        return """
        {
            "_id": "6176686afc13ae4e76000004",
            "price": 3,
            "display_price": 3,
            "is_discount": false,
            "discount_percent": 0,
            "image_url": "https://i.picsum.photos/id/292/3852/2556.jpg?hmac=cPYEh0I48Xpek2DPFLxTBhlZnKVhQCJsbprR-Awl9lo",
            "name": "Rosemary and bacon cupcakes",
            "description": "Crumbly cupcakes made with dried rosemary and back bacon",
            "tags": [
                "flour",
                "butter",
                "egg",
                "sugar",
                "rosemary",
                "bacon"
            ],
            "variants": [
                {
                    "_id": "varian_1",
                    "name": "Mashed Potato"
                },
                {
                    "_id": "varian_2",
                    "name": "French Fries"
                },
                {
                    "_id": "varian_3",
                    "name": "Potato Wedges"
                }
            ],
            "addons": [
                {
                    "addon_category_id": "sauce",
                    "addon_cateogry_name": "Sauce",
                    "addon_items": [
                        {
                            "_id": "addon_sauce_a",
                            "name": "BBQ",
                            "additional_price": 0
                        },
                        {
                            "_id": "addon_sauce_a",
                            "name": "Mushroom",
                            "additional_price": 0
                        }
                    ]
                },
                {
                    "addon_category_id": "extra_side_dish_a",
                    "addon_cateogry_name": "Extra Side Dish",
                    "addon_items": [
                        {
                            "_id": "addon_esda_a",
                            "name": "Cream Spinach",
                            "additional_price": 2
                        },
                        {
                            "_id": "addon_esda_b",
                            "name": "Chilly Con Carne",
                            "additional_price": 5
                        }
                    ]
                },
                {
                    "addon_category_id": "extra_side_dish_b",
                    "addon_cateogry_name": "Extra Side Dish",
                    "addon_items": [
                        {
                            "_id": "addon_esdb_a",
                            "name": "Cream Spinach",
                            "additional_price": 2
                        },
                        {
                            "_id": "addon_esdb_b",
                            "name": "Chilly Con Carne",
                            "additional_price": 5
                        }
                    ]
                }
            ]
        }

        """
    }
}
