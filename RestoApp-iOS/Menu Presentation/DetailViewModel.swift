//
//  DetailViewModel.swift
//  RestoApp-iOS
//
//  Created by Fahim Jatmiko on 27/03/22.
//

import Foundation
import RxCocoa
import RxSwift

//struct ItemDetailViewModel {
//
//}

struct VariantViewModel {
    let disposeBag = DisposeBag()
    let variants:BehaviorRelay<[Variant]> = BehaviorRelay(value: [])
    let selectedVariant:BehaviorRelay<Variant?> = BehaviorRelay(value: nil)
    let displayedVariant:BehaviorRelay<String> = BehaviorRelay(value: "")
    
    func updateModel(from item: MenuItem) {
        variants.accept(item.variants)
    }
    
    init() {
        selectedVariant.map{$0?.name ?? ""}
            .bind(to: displayedVariant)
            .disposed(by: disposeBag)
    }
}

struct AddonCategoryViewModel {
    let name:String
    let addons:BehaviorRelay<[AddonViewModel]> = BehaviorRelay(value: [])
    
//    func updateModel(from item: MenuItem) {
//        item.a
//    }
}

struct AddonViewModel {
    let name:String
    let price:String
    let isSelected:BehaviorRelay<Bool> = BehaviorRelay(value: false)
}

struct NotesViewModel {
    let notes:BehaviorRelay<String> = BehaviorRelay(value: "")
    let wordCountDisplay:BehaviorRelay<String> = BehaviorRelay(value: "")
}

class DetailViewModel {
    //MARK: Dependencies
    let disposeBag = DisposeBag()
    let itemDetailLoader:ItemDetailLoader
    
    //MARK: States
    let item:BehaviorRelay<ItemViewModel>
    let variant = VariantViewModel()
    let addonCategories = BehaviorRelay<[AddonCategory]>(value: [])
    let notes = NotesViewModel()
    
    init(itemDetailLoader:ItemDetailLoader, menuItem: ItemViewModel) {
        self.itemDetailLoader = itemDetailLoader
        self.item = BehaviorRelay(value: menuItem)
    }
    
    func load() {
        let itemDetailStream = itemDetailLoader.getItemDetail().share()
        
        itemDetailStream
            .map{itemDetail in
                ItemViewModel.map(from: itemDetail)
            }
            .bind(to: item)
            .disposed(by: disposeBag)
        
        itemDetailStream
            .subscribe(onNext:{[weak self] itemDetail in
                self?.variant.updateModel(from: itemDetail)
            })
            .disposed(by: disposeBag)
    }
}
