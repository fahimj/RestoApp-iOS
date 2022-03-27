//
//  AddonTableViewCell.swift
//  RestoApp-iOS
//
//  Created by Fahim Jatmiko on 27/03/22.
//

import UIKit
import RxCocoa
import RxSwift

class AddonTableViewCell: UITableViewCell {
    var disposeBag = DisposeBag()
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var selectButton: UIButton!
    
    override func prepareForReuse() {
        disposeBag = DisposeBag()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func bindData(model:AddonViewModel) {
        priceLabel.text = model.displayedPrice
        nameLabel.text = model.name
        
        model.isSelected
            .subscribe(onNext: {[weak self] isSelected in
                let image = isSelected ? UIImage(systemName: "checkmark.square.fill") : UIImage(systemName: "square")
                self?.selectButton.setImage(image, for: .normal)
            }).disposed(by: disposeBag)
        
        selectButton.rx.tap
            .debounce(.milliseconds(200), scheduler: MainScheduler.asyncInstance)
            .withLatestFrom(model.isSelected)
            .map{!$0}
            .bind(to: model.isSelected)
            .disposed(by: disposeBag)
    }
    
}
