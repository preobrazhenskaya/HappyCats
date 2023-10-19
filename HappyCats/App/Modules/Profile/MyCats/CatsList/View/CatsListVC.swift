//
//  CatsListVC.swift
//  HappyCats
//
//  Created by Яна Преображенская on 18.05.2020.
//  Copyright © 2020 Яна Преображенская. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class CatsListVC: UIViewController {
    
    private var model: CatsListVM!
    private let disposeBag = DisposeBag()
    private let selectedCat = PublishRelay<Int>()

    @IBOutlet weak var catsTable: UITableView!
    @IBOutlet weak var addCatButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        buildUI()
        bindUI()
    }
    
    func setModel(model: CatsListVM) {
        self.model = model
    }
    
    private func buildUI() {
        buildTable()
        buildAddButton()
    }
    
    private func buildTable() {
        catsTable.do {
            $0.register(cellType: MyCatTVC.self)
        }
    }
    
    private func buildAddButton() {
        addCatButton.backgroundColor = Constants.UI.Main.mainColor
        addCatButton.tintColor = Constants.UI.Main.alternativeFontColor
        addCatButton.setTitle(R.string.localizable.profileMyCatsAddButton(), for: .normal)
        addCatButton.layer.cornerRadius = Constants.UI.Button.AddCat.cornerRadius
        addCatButton.titleLabel?.font = Constants.UI.Main.titleFont
    }
    
    private func bindUI() {
        let addCatButtonTap = Observable<Void>.merge(addCatButton.rx.tap.asObservable())
        let input = CatsListVM.Input(selectedCat: selectedCat.asObservable(),
                                     addCatButton: addCatButtonTap)
            
        let output = model.transform(input: input)
        
        output.cats
            .drive(self.catsTable.rx
                .items(cellIdentifier: MyCatTVC.reuseIdentifier,
                       cellType: MyCatTVC.self)) { _, cat, cell in
                        cell.config(cat: cat)
        }.disposed(by: self.disposeBag)
        
        catsTable.rx
            .itemSelected
            .subscribe(onNext: { indexPath in
                self.selectedCat.accept(indexPath.row)
            }).disposed(by: disposeBag)
    }
}
