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
    
    static func map(from category:Category) -> CategoryViewModel {
        let itemVMs = category.items.map{ItemViewModel.map(from: $0)}
        return CategoryViewModel(name: category.name, items: itemVMs)
    }
}

struct ItemViewModel {
    let id:String
    let name:String
    let imageUrl:String
    let description:String
    let tags:[String]
    let displayedPrice:String
    let price:Double
    
    static func map(from menu:MenuItem) -> ItemViewModel {
        return ItemViewModel(id:menu.id, name: menu.name, imageUrl: menu.imageUrl, description: menu.descriptionField, tags: menu.tags, displayedPrice: "SGD \(menu.price)", price:menu.price)
    }
}

class HomeViewModel {
    let categoryViewModels = BehaviorRelay<[CategoryViewModel]>(value: [])
    let categoryHeaderViewModels = BehaviorRelay<[CategoryHeaderViewModel]>(value: [])
    
    let menuLoader: MenuLoader
    let disposeBag = DisposeBag()
    
    init(menuLoader: MenuLoader) {
        self.menuLoader = menuLoader
        setupHeaderBinding()
    }
    
    private func setupHeaderBinding() {
        categoryViewModels
            .map{categoryVMs in
                categoryVMs.map{CategoryHeaderViewModel(name: $0.name)}
            }
            .bind(to: categoryHeaderViewModels)
            .disposed(by: disposeBag)
    }
    
    public func load() {
        menuLoader.getMenu()
            .map{categories in
                categories.map{CategoryViewModel.map(from: $0)}
            }
            .bind(to: categoryViewModels)
            .disposed(by: disposeBag)
    }
}
