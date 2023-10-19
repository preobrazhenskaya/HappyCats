//
//  NewsDetailVC.swift
//  HappyCats
//
//  Created by Яна Преображенская on 08.05.2020.
//  Copyright © 2020 Яна Преображенская. All rights reserved.
//

import UIKit
import RxSwift

final class NewsDetailVC: UIViewController {
    
    private var model: NewsDetailVM!
    private let disposeBag = DisposeBag()

    @IBOutlet weak var newsImage: UIImageView!
    @IBOutlet weak var newsTitle: UILabel!
    @IBOutlet weak var newsDescription: UILabel!
    @IBOutlet weak var titleLeftView: UIView!
    @IBOutlet weak var viewTopHeight: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        buildUI()
        bindUI()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
        navigationController?.navigationBar.shadowImage = nil
    }
    
    func setModel(model: NewsDetailVM) {
        self.model = model
    }
    
    private func buildUI() {
        viewTopHeight.constant = -((navigationController?.navigationBar.frame.height ?? 0) + UIApplication.shared.statusBarFrame.height)
        buildNavigation()
        buildLabels()
        buildTitleView()
    }
    
    private func buildNavigation() {
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.hidesBarsOnSwipe = true
    }
    
    private func buildLabels() {
        newsDescription.font = Constants.UI.Main.mainFont
        newsTitle.font = Constants.UI.Main.titleFont
    }
    
    private func buildTitleView() {
        titleLeftView.backgroundColor = Constants.UI.Main.mainColor
        titleLeftView.layer.cornerRadius = 7.5
    }
    
    private func bindUI() {
        let input = NewsDetailVM.Input()
        
        let output = model.transform(input: input)
        output.title.drive(newsTitle.rx.text).disposed(by: disposeBag)
        output.description.drive(newsDescription.rx.text).disposed(by: disposeBag)
        output.image.drive(newsImage.rx.image).disposed(by: disposeBag)
    }
}
