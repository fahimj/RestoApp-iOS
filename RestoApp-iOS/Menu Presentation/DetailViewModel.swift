//
//  DetailViewModel.swift
//  RestoApp-iOS
//
//  Created by Fahim Jatmiko on 27/03/22.
//

import Foundation
import RxCocoa
import RxSwift

struct VariantViewModel {
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
    let addons:BehaviorRelay<[AddonViewModel]>
    
    static func createModel(from addonCategory: AddonCategory) -> AddonCategoryViewModel {
        let name = addonCategory.name
        let addonsVM = addonCategory.addons.map{addon in
            return AddonViewModel(name: addon.name, price: addon.additionalPrice, displayedPrice: "SGD \(addon.additionalPrice)")
        }
        return AddonCategoryViewModel(name: name, addons: BehaviorRelay(value: addonsVM))
    }
}

struct AddonViewModel {
    let disposeBag = DisposeBag()
    let name:String
    let price:Double
    let displayedPrice:String
    let isSelected:BehaviorRelay<Bool> = BehaviorRelay(value: false)
    
//    init(name:String, price:Double, displayedPrice:String) {
//        self.name = name
//        self.price = price
//        self.displayedPrice = displayedPrice
//    }
//
//    deinit {
//        print("DEINIT")
//    }
}

struct NotesViewModel {
    private let disposeBag = DisposeBag()
    
    let noteText:BehaviorRelay<String> = BehaviorRelay(value: "")
    let charCountDisplay:BehaviorRelay<String> = BehaviorRelay(value: "")
    
    // TODO: Validation rule can be moved to domain model
    private let maxNotesCharCount = 200
    
    init() {
        noteText.map{"\($0.count) / 200"}
            .bind(to: charCountDisplay)
            .disposed(by: disposeBag)
    }
    
    func update(text: String) {
        let wordCount = text.count
        if wordCount > maxNotesCharCount {
            noteText.accept(String(text.prefix(maxNotesCharCount)))
        } else {
            noteText.accept(text)
        }
    }
}

class DetailViewModel {
    //MARK: Dependencies
    let disposeBag = DisposeBag()
    let itemDetailLoader:ItemDetailLoader
    
    //MARK: States
    let item:BehaviorRelay<ItemViewModel>
    let variant = VariantViewModel()
    let addonCategories = BehaviorRelay<[AddonCategoryViewModel]>(value: [])
    let notes = NotesViewModel()
    let isAddToChartEnabled = BehaviorRelay<Bool>(value: true)
    let displayedAddToChartText = BehaviorRelay<String>(value: "")
    let displayedQuantity = BehaviorRelay<String>(value: "1")
    
    //MARK: Private States
    private let itemDetailUpdatedEvent = PublishSubject<MenuItem>()
    private let totalPrice = BehaviorRelay<Double>(value: 0)
    private let quantity = BehaviorRelay<Int>(value: 1)
    
    init(itemDetailLoader:ItemDetailLoader, menuItem: ItemViewModel) {
        self.itemDetailLoader = itemDetailLoader
        self.item = BehaviorRelay(value: menuItem)
        setupItemDetailUpdatedEvent()
        setupAddonSelectionBinding()
    }
    
    private func setupAddonSelectionBinding() {
        addonCategories.subscribe(onNext:{[weak self] addonCategories in
//            addonCategories.compactMap{$0.addons}.flatMap{$0.value}.forEach{vm in
//                vm.isSelected.subscribe(onNext: {[weak self] isSelected in
//                    self?.calculateTotalPrice()
//                }).disposed(by: vm.disposeBag)
//            }
            addonCategories.forEach{addonCategory in
                addonCategory.addons.value.forEach{addonVM in
                    addonVM.isSelected.subscribe(onNext: {[weak self] isSelected in
                        self?.calculateTotalPrice()
                    }).disposed(by: addonVM.disposeBag)
                }
            }
        }).disposed(by: disposeBag)
        
        totalPrice.map{"Add to Cart - SGD \($0)"}
            .bind(to: displayedAddToChartText)
            .disposed(by: disposeBag)
    }
    
    private func calculateTotalPrice() {
        // quantity * (base price + selected addons)
        let selectedAddonsTotalPrice = addonCategories.value
            .compactMap{$0.addons}
            .flatMap{$0.value}
            .filter{$0.isSelected.value}
            .reduce(0, {$0 + $1.price})
        totalPrice.accept((item.value.price + selectedAddonsTotalPrice) * Double(quantity.value))
        
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
        
        itemDetailUpdatedEvent
            .map{$0.addOnCategories}
            .map{addonCategories in
                addonCategories.map{
                    let addonCategoryVM = AddonCategoryViewModel.createModel(from: $0)
                    return addonCategoryVM
                }
            }
            .bind(to: addonCategories)
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
