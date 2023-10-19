//
//  HandbookVC.swift
//  HappyCats
//
//  Created by Яна Преображенская on 08.05.2020.
//  Copyright © 2020 Яна Преображенская. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

final class HandbookVC: UIViewController {

    private var model: HandbookVM!
    private let disposeBag = DisposeBag()
    private let selectedBreed = PublishRelay<Int>()
    private let selectedDisease = PublishRelay<Int>()

    @IBOutlet weak var breedsTable: UITableView!
    @IBOutlet weak var diseaseTable: UITableView!
    @IBOutlet weak var sectionSelection: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        buildUI()
        bindUI()
    }
    
    func setModel(model: HandbookVM) {
        self.model = model
    }
    
    private func buildUI() {
        buildSectionSelection()
        buildTable()
    }
    
    private func buildSectionSelection() {
        sectionSelection.selectedSegmentIndex = 0
        sectionSelection.setTitle(R.string.localizable.catsTitle(), forSegmentAt: 0)
        sectionSelection.setTitle(R.string.localizable.diseaseTitle(), forSegmentAt: 1)
        sectionSelection.setTitleTextAttributes([.font: Constants.UI.Main.mainFont ?? UIFont.systemFont(ofSize: 17),
                                                 .foregroundColor: Constants.UI.Main.alternativeFontColor], for: .normal)
        sectionSelection.setTitleTextAttributes([.foregroundColor: Constants.UI.Main.mainFontColor], for: .selected)
        sectionSelection.backgroundColor = Constants.UI.Main.mainColor
        if #available(iOS 13.0, *) {
            sectionSelection.selectedSegmentTintColor = .white
        } else {
            sectionSelection.tintColor = .white
        }
    }
    
    private func buildTable() {
        breedsTable.do {
            $0.register(cellType: HandbookTVC.self)
        }
        diseaseTable.do {
            $0.register(cellType: HandbookTVC.self)
        }
        showBreeds()
    }
    
    private func showBreeds() {
        self.breedsTable.isHidden = false
        self.diseaseTable.isHidden = true
    }
    
    private func showDisease() {
        self.breedsTable.isHidden = true
        self.diseaseTable.isHidden = false
    }
    
    private func bindUI() {
        let input = HandbookVM.Input(selectedBreed: selectedBreed.asObservable(), selectedDisease: selectedDisease.asObservable())
        
        let output = model.transform(input: input)
        
        output.breeds
            .drive(self.breedsTable.rx
                .items(cellIdentifier: HandbookTVC.reuseIdentifier,
                       cellType: HandbookTVC.self)) { _, breed, cell in
                        cell.configCatCell(cat: breed)
        }.disposed(by: self.disposeBag)
        
        output.disease
            .drive(self.diseaseTable.rx
                .items(cellIdentifier: HandbookTVC.reuseIdentifier,
                       cellType: HandbookTVC.self)) { _, disease, cell in
                        cell.configDiseaseCell(disease: disease)
        }.disposed(by: self.disposeBag)
        
        sectionSelection.rx.selectedSegmentIndex
            .subscribe(onNext: { index in
                switch index {
                case 0:
                    self.showBreeds()
                case 1:
                    self.showDisease()
                default:
                    break
                }
            }).disposed(by: disposeBag)
        
        breedsTable.rx.itemSelected
            .subscribe(onNext: { indexPath in
                self.selectedBreed.accept(indexPath.row)
            }).disposed(by: disposeBag)
        
        diseaseTable.rx.itemSelected
            .subscribe(onNext: { indexPath in
                self.selectedDisease.accept(indexPath.row)
            }).disposed(by: disposeBag)
    }
}
