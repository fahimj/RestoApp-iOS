//
//  DetailViewController.swift
//  RestoApp-iOS
//
//  Created by Fahim Jatmiko on 27/03/22.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

class DetailViewController: UIViewController {

    @IBOutlet weak var itemImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var originalPriceLabel: UILabel!
    @IBOutlet weak var displayedPriceLabel: UILabel!
    @IBOutlet weak var variantTextField: UITextField!
    @IBOutlet weak var addonTableView: UITableView!
    @IBOutlet weak var notesTextView: UITextView!
    @IBOutlet weak var charCountLabel: UILabel!
    @IBOutlet weak var decreaseQuantityButton: UIButton!
    @IBOutlet weak var quantityLabel: UITextField!
    @IBOutlet weak var increaseQuantityButton: UIButton!
    @IBOutlet weak var addToCartButton: UIButton!
    @IBOutlet weak var quantityStackView: UIStackView!
    
    let disposeBag = DisposeBag()
    let viewModel:DetailViewModel
    
    init(detailViewModel:DetailViewModel) {
        self.viewModel = detailViewModel
        
        super.init(nibName: "DetailViewController", bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupQuantityViewShadow()
        setupButtonViewShadow()
        setupItemBindings()
        setupNotesBinding()
        setupQuantityBinding()
        setupVariantBinding()
        setupAddonBinding()
        setupTagsBinding()
        
        viewModel.load()
    }
    
    private func setupItemBindings() {
        viewModel.item
            .map{$0.displayedPrice}
            .bind(to: displayedPriceLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.item
            .map{$0.name}
            .bind(to: titleLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.item
            .map{$0.description}
            .bind(to: descriptionLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.item
            .map{$0.description}
            .bind(to: descriptionLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.item
            .map{$0.originalDisplayedPrice}
            .map{price in
                let attributedString = NSMutableAttributedString(string: price)
                attributedString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSMakeRange(0, attributedString.length))
                return attributedString
            }
            .bind(to: originalPriceLabel.rx.attributedText)
            .disposed(by: disposeBag)
        
        viewModel.item
            .map{$0.imageUrl}
            .flatMap{urlString -> Observable<(response: HTTPURLResponse, data: Data)> in
                let url = URL.init(string: urlString)
                let request = URLRequest(url: url!)
                return URLSession.shared.rx.response(request: request)
            }
            .subscribe(on: ConcurrentDispatchQueueScheduler(qos: .background))
            .map{UIImage(data:$0.data)}
            .asDriver(onErrorJustReturn: nil)
            .drive(onNext: {[weak self] image in
                self?.itemImageView.setImageAnimated(image)
            })
            .disposed(by: disposeBag)
        
        
    }
    
    private func setupQuantityBinding() {
        viewModel.isAddToChartEnabled.asDriver().drive(onNext: {[weak self] isEnabled in
            self?.addToCartButton.isEnabled = isEnabled
            let blueColor = UIColor.init(hex: 0x0075E3)
            self?.addToCartButton.backgroundColor = isEnabled ? blueColor : .gray
        }).disposed(by: disposeBag)
        
        viewModel.displayedAddToChartText
            .bind(to: addToCartButton.rx.title(for: .normal))
            .disposed(by: disposeBag)
        
        viewModel.displayedQuantity
            .bind(to: quantityLabel.rx.text)
            .disposed(by: disposeBag)
        
        increaseQuantityButton.rx.tap
            .debounce(.milliseconds(200), scheduler: MainScheduler.asyncInstance)
            .subscribe(onNext: {[weak self] _ in
                self?.viewModel.incrementQuantity()
            })
            .disposed(by: disposeBag)
        
        decreaseQuantityButton.rx.tap
            .debounce(.milliseconds(200), scheduler: MainScheduler.asyncInstance)
            .subscribe(onNext: {[weak self] _ in
                self?.viewModel.decrementQuantity()
            })
            .disposed(by: disposeBag)
    }
    
    private func setupNotesBinding() {
        notesTextView.rx.text.orEmpty.subscribe(onNext: {[weak self] text in
            self?.viewModel.notes.update(text: text)
        }).disposed(by: disposeBag)
        
        viewModel.notes.noteText
            .bind(to: notesTextView.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.notes.charCountDisplay
            .bind(to: charCountLabel.rx.text)
            .disposed(by: disposeBag)
    }
    
    private func setupVariantBinding() {
        let picker = UIPickerView()
        viewModel.variant.variants
            .bind(to: picker.rx.itemTitles) { (row, element) in
                return element.name
            }
            .disposed(by: disposeBag)
        
        picker.rx.modelSelected(Variant.self)
            .map{$0.first}
            .bind(to: viewModel.variant.selectedVariant)
            .disposed(by: disposeBag)
        
        viewModel.variant.selectedVariant
            .map{$0?.name ?? "Select a variant..."}
            .bind(to: variantTextField.rx.text)
            .disposed(by: disposeBag)
        
        variantTextField.inputView = picker
    }
    
    var dataSource: RxTableViewSectionedAnimatedDataSource<AddonCategoryViewModel>!
    private func setupAddonBinding() {
        addonTableView.register(AddonTableViewCell.nib, forCellReuseIdentifier: AddonTableViewCell.identifier)
        addonTableView.separatorStyle = .none
        dataSource = RxTableViewSectionedAnimatedDataSource<AddonCategoryViewModel> { (_, tableView, indexPath, item) in
            
            let cell: AddonTableViewCell = tableView.dequeueReusableCell(withIdentifier: AddonTableViewCell.identifier, for: indexPath) as! AddonTableViewCell
            cell.bindData(model: item)
            return cell
        }
        
        dataSource.titleForHeaderInSection = { dataSource, index in
            return dataSource.sectionModels[index].name
        }
        
        viewModel.addonCategories
            .asDriver(onErrorJustReturn: [])
            .drive(addonTableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
    }
    
    private func setupTagsBinding() {
        //TODO: implementation
    }
    
    private func setupQuantityViewShadow() {
        quantityStackView.layer.shadowOffset = CGSize(width: 10,height: 10)
        quantityStackView.layer.shadowRadius = 10
        quantityStackView.layer.shadowOpacity = 0.3
        quantityStackView.layer.cornerRadius = 10
        quantityStackView.layer.borderColor = UIColor.lightGray.cgColor
    }
    
    private func setupButtonViewShadow() {
        addToCartButton.layer.shadowOffset = CGSize(width: 10,height: 10)
        addToCartButton.layer.shadowRadius = 10
        addToCartButton.layer.shadowOpacity = 0.3
        addToCartButton.layer.cornerRadius = 10
        addToCartButton.layer.borderColor = UIColor.lightGray.cgColor
    }
}
