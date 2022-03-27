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

class VariantViewModel {
    let disposeBag = DisposeBag()
    let variants:BehaviorRelay<[Variant]> = BehaviorRelay(value: [])
    let selectedVariant:BehaviorRelay<Variant?> = BehaviorRelay(value: nil)
    let displayedVariant:BehaviorRelay<String> = BehaviorRelay(value: "")
    
    func updateModel(from item: MenuItem) {
        variants.accept(item.variants)
    }
    
    func selectVariant(id:String) {
        let selectedVariant = variants.value.first(where: {$0.id == id})
        self.selectedVariant.accept(selectedVariant)
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
    
    //MARK: Private States
    private let itemDetailUpdatedEvent = PublishSubject<MenuItem>()
    
    init(itemDetailLoader:ItemDetailLoader, menuItem: ItemViewModel) {
        self.itemDetailLoader = itemDetailLoader
        self.item = BehaviorRelay(value: menuItem)
        setupItemDetailUpdatedEvent()
    }
    
    private func setupItemDetailUpdatedEvent() {
        itemDetailUpdatedEvent
            .map{itemDetail in
                ItemViewModel.map(from: itemDetail)
            }
            .bind(to: item)
            .disposed(by: disposeBag)
        
        itemDetailUpdatedEvent
            .subscribe(onNext:{[weak self] itemDetail in
                self?.variant.updateModel(from: itemDetail)
            })
            .disposed(by: disposeBag)
    }
    
    func load() {
        itemDetailLoader.getItemDetail()
            .bind(to: itemDetailUpdatedEvent)
            .disposed(by: disposeBag)
    }
    
    func selectVariant(id:String) {
        variant.selectVariant(id: id)
    }
}
