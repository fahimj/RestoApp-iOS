//
//  HomeViewModel.swift
//  RestoApp-iOS
//
//  Created by Fahim Jatmiko on 26/03/22.
//

import Foundation
import RxRelay
import RxSwift

struct CategoryHeaderViewModel {
    let name:String
    let isSelected = BehaviorRelay<Bool>(value: false)
}

struct CategoryViewModel {
    let name:String
    let items:[ItemViewModel]
}

struct ItemViewModel {
    let name:String
    let imageUrl:String
    let tags:[String]
    let price:String
}

class HomeViewModel {
    let disposeBag = DisposeBag()
    let categoryViewModels = BehaviorRelay<[CategoryViewModel]>(value: [])
    let categoryHeaderViewModels = BehaviorRelay<[CategoryHeaderViewModel]>(value: [])
}
