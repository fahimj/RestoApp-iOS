//
//  CategoryViewModel+Animatable.swift
//  RestoApp-iOS
//
//  Created by Fahim Jatmiko on 26/03/22.
//

import Foundation
import UIKit
import RxDataSources

extension CategoryViewModel : AnimatableSectionModelType {
    static func == (lhs: CategoryViewModel, rhs: CategoryViewModel) -> Bool {
        lhs.name == rhs.name
    }
    
    typealias Identity = String
    
    var identity : Identity {
        return self.name
    }
    
    init(original: CategoryViewModel, items: [ItemViewModel]) {
        self = original
    }
    
    typealias Item = ItemViewModel
}

extension ItemViewModel : IdentifiableType, Equatable {
    static func == (lhs: ItemViewModel, rhs: ItemViewModel) -> Bool {
        lhs.name == rhs.name
    }
    
    var identity: String {
        return self.name
    }
    
    typealias Identity = String
}
