//
//  NewsListVC.swift
//  HappyCats
//
//  Created by Яна Преображенская on 07.05.2020.
//  Copyright © 2020 Яна Преображенская. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Reusable

final class NewsListVC: UIViewController {
    
    private var model: NewsListVM!
    private let disposeBag = DisposeBag()
    private let selectedNews = PublishRelay<Int>()

    @IBOutlet private weak var newsTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        buildUI()
        bindUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        buildUI()
    }
    
    func setModel(model: NewsListVM) {
        self.model = model
    }
    
    private func buildUI() {
        buildTable()
    }
    
    private func buildTable() {
        newsTable.do {
            $0.register(cellType: NewsTVC.self)
        }
    }
    
    private func bindUI() {
        newsTable.rx.itemSelected.subscribe(onNext: { indexPath in
            self.selectedNews.accept(indexPath.row)
        }).disposed(by: disposeBag)
        
        let input = NewsListVM.Input(selectedNews: selectedNews.asObservable())
        
        let output = model.transform(input: input)
        output.news
            .drive(newsTable.rx
                .items(cellIdentifier: NewsTVC.reuseIdentifier, cellType: NewsTVC.self)) { _, news, cell in
                    cell.config(data: news)
        }.disposed(by: disposeBag)
    }
}
