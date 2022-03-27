//
//  DetailViewController.swift
//  RestoApp-iOS
//
//  Created by Fahim Jatmiko on 27/03/22.
//

import UIKit

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
    
    init() {
        super.init(nibName: "DetailViewController", bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupQuantityViewShadow()
        setupButtonViewShadow()
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
