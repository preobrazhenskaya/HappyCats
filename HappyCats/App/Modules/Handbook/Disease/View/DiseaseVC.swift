//
//  DiseaseVC.swift
//  HappyCats
//
//  Created by Яна Преображенская on 17.05.2020.
//  Copyright © 2020 Яна Преображенская. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class DiseaseVC: UIViewController {
    
    private var model: DiseaseVM!
    private let disposeBag = DisposeBag()

    @IBOutlet weak var diseaseImage: UIImageView!
    @IBOutlet weak var diseaseTitle: UILabel!
    @IBOutlet weak var diseaseDescription: UILabel!
    @IBOutlet weak var titleLeftView: UIView!
    @IBOutlet weak var viewTopHeight: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        buildUI()
        bindUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        buildNavigation()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
        navigationController?.navigationBar.shadowImage = nil
    }
    
    func setModel(model: DiseaseVM) {
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
        diseaseDescription.font = Constants.UI.Main.mainFont
        diseaseTitle.font = Constants.UI.Main.titleFont
    }
    
    private func buildTitleView() {
        titleLeftView.backgroundColor = Constants.UI.Main.mainColor
        titleLeftView.layer.cornerRadius = 7.5
    }
    
    private func bindUI() {
        let input = DiseaseVM.Input()
        
        let output = model.transform(input: input)
        output.title.drive(diseaseTitle.rx.text).disposed(by: disposeBag)
        output.description.drive(diseaseDescription.rx.text).disposed(by: disposeBag)
        output.image.drive(diseaseImage.rx.image).disposed(by: disposeBag)
    }
}
