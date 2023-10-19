//
//  BreedVC.swift
//  HappyCats
//
//  Created by Яна Преображенская on 17.05.2020.
//  Copyright © 2020 Яна Преображенская. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class BreedVC: UIViewController {
    
    private var model: BreedVM!
    private let disposeBag = DisposeBag()
    private let selectedDisease = PublishRelay<Int>()
    private let diseaseCount = PublishRelay<Int>()

    @IBOutlet weak var breedImage: UIImageView!
    @IBOutlet weak var breedTitle: UILabel!
    @IBOutlet weak var breedDescription: UILabel!
    @IBOutlet weak var titleLeftView: UIView!
    @IBOutlet weak var viewTopHeight: NSLayoutConstraint!
    @IBOutlet weak var diseaseLabel: UILabel!
    @IBOutlet weak var diseaseTable: UITableView!
    @IBOutlet weak var diseaseTableHeight: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        buildUI()
        bindUI()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
        navigationController?.navigationBar.shadowImage = nil
        navigationController?.navigationBar.titleTextAttributes?[.foregroundColor] = Constants.UI.Main.alternativeFontColor
    }
    
    override func viewWillAppear(_ animated: Bool) {
        buildNavigation()
    }
    
    func setModel(model: BreedVM) {
        self.model = model
    }
    
    private func buildUI() {
        viewTopHeight.constant = -((navigationController?.navigationBar.frame.height ?? 0) + UIApplication.shared.statusBarFrame.height)
        buildNavigation()
        buildLabels()
        buildTitleView()
        buildTable()
    }
    
    private func buildNavigation() {
        navigationController?.navigationBar.titleTextAttributes?[.foregroundColor] = UIColor.clear
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.hidesBarsOnSwipe = true
    }
    
    private func buildLabels() {
        breedDescription.font = Constants.UI.Main.mainFont
        breedTitle.font = Constants.UI.Main.titleFont
        diseaseLabel.font = Constants.UI.Main.sectionFont
        diseaseLabel.text = R.string.localizable.handbookBreedsDisease()
    }
    
    private func buildTitleView() {
        titleLeftView.backgroundColor = Constants.UI.Main.mainColor
        titleLeftView.layer.cornerRadius = 7.5
    }
    
    private func buildTable() {
        diseaseTable.do {
            $0.register(cellType: BreedDiseaseTVC.self)
        }
    }
    
    private func bindUI() {
        diseaseTable.rx.itemSelected
            .subscribe(onNext: { indexPath in
                self.selectedDisease.accept(indexPath.row)
            }).disposed(by: disposeBag)
        
        let input = BreedVM.Input(selectedDisease: selectedDisease.asObservable())
        
        let output = model.transform(input: input)
        output.title.drive(breedTitle.rx.text).disposed(by: disposeBag)
        output.description.drive(breedDescription.rx.text).disposed(by: disposeBag)
        output.image.drive(breedImage.rx.image).disposed(by: disposeBag)
        
        output.title
            .drive(onNext: { text in
                self.title = text
            }).disposed(by: disposeBag)
        
        output.diseaseCount
            .drive(onNext: { count in
                self.diseaseTableHeight.constant = Constants.Cells.CellInHandbookDetail.height * CGFloat(count)
            }).disposed(by: disposeBag)
        
        output.disease
            .drive(self.diseaseTable.rx
                .items(cellIdentifier: BreedDiseaseTVC.reuseIdentifier,
                       cellType: BreedDiseaseTVC.self)) { _, disease, cell in
                        cell.config(disease: disease)
        }.disposed(by: self.disposeBag)
    }
}
