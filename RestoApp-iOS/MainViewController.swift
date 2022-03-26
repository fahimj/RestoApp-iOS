//
//  MainViewController.swift
//  RestoApp-iOS
//
//  Created by Fahim Jatmiko on 18/03/22.
//

import UIKit
import RxDataSources
import RxSwift
import RxCocoa

class MainViewController: UITableViewController {
    let disposeBag = DisposeBag()
    let viewModel:HomeViewModel
    
    init(viewModel:HomeViewModel) {
        self.viewModel = viewModel
        super.init(nibName: "MainViewController", bundle: nil)
    }
   
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDataSource()
    }
    
//    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        return 300
//    }
//
//    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
//        return 50
//    }

    // MARK: - Table view data source
//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        var cell : UITableViewCell!
//        cell = tableView.dequeueReusableCell(withIdentifier: "TEST")
//        if cell == nil {
//            cell = UITableViewCell(style: .default, reuseIdentifier: "TEST")
//        }
//
//        cell.textLabel?.text = "TEST"
//        return cell
//    }
//
    //MARK: Table View Configuration
    
//    typealias CategorySectionModel = AnimatableSectionModel<String, CategoryViewModel>
    var dataSource: RxTableViewSectionedAnimatedDataSource<CategoryViewModel>!
    
    private func setupDataSource() {
        tableView.delegate = nil
        tableView.dataSource = nil
        
//        tableView.rx.setDelegate(self).disposed(by: disposeBag)
        tableView.register(MenuItemTableViewCell.nib, forCellReuseIdentifier: MenuItemTableViewCell.identifier)
        tableView.separatorStyle = .none
        dataSource = RxTableViewSectionedAnimatedDataSource<CategoryViewModel> { (_, tableView, indexPath, item) in
            
            let cell: MenuItemTableViewCell = tableView.dequeueReusableCell(withIdentifier: MenuItemTableViewCell.identifier, for: indexPath) as! MenuItemTableViewCell
            
            return cell
        }
        
        viewModel.categoryViewModels
//            .distinctUntilChanged()
            .asDriver(onErrorJustReturn: [])
            .drive(tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
//        tableView.rx.itemSelected.subscribe(onNext: {[weak self] indexPath in
//            guard let categoryVM = self?.viewModel.displayedItems.value[indexPath.row] else {return}
//            categoryVM.toggleCollapseStateChildren()
//            self?.viewModel.chooseCategory(categoryViewModel: categoryVM)
//        }).disposed(by: disposeBag)
    }
}
