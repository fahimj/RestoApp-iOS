//
//  AddonCategoryViewModel+AnimatableSectionModelType.swift
//  RestoApp-iOS
//
//  Created by Fahim Jatmiko on 27/03/22.
//

import Foundation
import UIKit
import RxDataSources

extension AddonCategoryViewModel : AnimatableSectionModelType {
    var items: [AddonViewModel] {
        return self.addons.value
    }
    
    
    static func == (lhs: AddonCategoryViewModel, rhs: AddonCategoryViewModel) -> Bool {
        lhs.name == rhs.name
    }
    
    typealias Identity = String
    
    var identity : Identity {
        return self.name
    }
    
    init(original: AddonCategoryViewModel, items: [AddonViewModel]) {
        self = original
    }
    
    typealias Item = AddonViewModel
}

extension AddonViewModel : IdentifiableType, Equatable {
    static func == (lhs: AddonViewModel, rhs: AddonViewModel) -> Bool {
        lhs.name == rhs.name
    }
    
    var identity: String {
        return self.name
    }
    
    typealias Identity = String
}
