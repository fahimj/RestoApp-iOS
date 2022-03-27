//
//  MenuItemTableViewCell.swift
//  RestoApp-iOS
//
//  Created by Fahim Jatmiko on 26/03/22.
//

import UIKit
import RxSwift
import RxCocoa

class MenuItemTableViewCell: UITableViewCell {
    var disposeBag = DisposeBag()
    
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var itemImageView: UIImageView!
    @IBOutlet weak var displayedPriceLabel: UILabel!
    
    override func prepareForReuse() {
        disposeBag = DisposeBag()
        itemImageView.image = nil
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        cardView.layer.shadowOffset = CGSize(width: 10,
                                          height: 10)
        cardView.layer.shadowRadius = 10
        cardView.layer.shadowOpacity = 0.3
        cardView.layer.cornerRadius = 10
        cardView.layer.borderColor = UIColor.lightGray.cgColor
//        cardView.layer.borderWidth = 1
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func bindData(menuViewModel: ItemViewModel) {
        titleLabel.text = menuViewModel.name
        descriptionLabel.text = menuViewModel.description
        displayedPriceLabel.text = menuViewModel.displayedPrice
        
        let url = URL.init(string: menuViewModel.imageUrl)
        let request = URLRequest(url: url!)
        URLSession.shared.rx.response(request: request)
            .subscribe(on: ConcurrentDispatchQueueScheduler(qos: .background))
            .map{UIImage(data:$0.data)}
            .asDriver(onErrorJustReturn: nil)
            .drive(onNext: {[weak self] image in
                self?.itemImageView.setImageAnimated(image)
            })
            .disposed(by: disposeBag)
    }
    
}

extension UIImageView {
    func setImageAnimated(_ newImage: UIImage?) {
        image = newImage
        
        guard newImage != nil else { return }
        
        alpha = 0
        UIView.animate(withDuration: 0.25) {
            self.alpha = 1
        }
    }
}
