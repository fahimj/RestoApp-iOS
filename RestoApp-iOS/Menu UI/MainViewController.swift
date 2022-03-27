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
    let menuSelection: (ItemViewModel) -> Void
    
    init(viewModel:HomeViewModel, menuSelection: @escaping (ItemViewModel) -> Void = {_ in }) {
        self.viewModel = viewModel
        self.menuSelection = menuSelection
        super.init(nibName: "MainViewController", bundle: nil)
    }
   
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDataSource()
        viewModel.load()
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    //MARK: Table View Configuration
    
    var dataSource: RxTableViewSectionedAnimatedDataSource<CategoryViewModel>!
    
    private func setupDataSource() {
        tableView.dataSource = nil
        
        tableView.register(MenuItemTableViewCell.nib, forCellReuseIdentifier: MenuItemTableViewCell.identifier)
        tableView.separatorStyle = .none
        dataSource = RxTableViewSectionedAnimatedDataSource<CategoryViewModel> { (_, tableView, indexPath, item) in
            
            let cell: MenuItemTableViewCell = tableView.dequeueReusableCell(withIdentifier: MenuItemTableViewCell.identifier, for: indexPath) as! MenuItemTableViewCell
            cell.bindData(menuViewModel: item)
            
            return cell
        }
        
        dataSource.titleForHeaderInSection = { dataSource, index in
            return dataSource.sectionModels[index].name
        }
        
        viewModel.categoryViewModels
            .skip(1)
            .asDriver(onErrorJustReturn: [])
            .drive(tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
    
        tableView.rx.modelSelected(ItemViewModel.self).subscribe(onNext: {[weak self] item in
            self?.menuSelection(item)
        }).disposed(by: disposeBag)
        
        tableView.rx.itemSelected.subscribe(onNext: {[weak self] indexPath in
            self?.tableView.deselectRow(at: indexPath, animated: true)
        }).disposed(by: disposeBag)
    }
}
