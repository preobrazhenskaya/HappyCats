//
//  MainProfileVC.swift
//  HappyCats
//
//  Created by Яна Преображенская on 14.05.2020.
//  Copyright © 2020 Яна Преображенская. All rights reserved.
//

import UIKit
import RxSwift

final class MainProfileVC: UIViewController {
    
    private var model: MainProfileVM!
    private var disposeBag = DisposeBag()
    
    @IBOutlet private weak var userImage: UIImageView!
    @IBOutlet private weak var profileTable: UITableView!
    @IBOutlet private weak var profileTableHeight: NSLayoutConstraint!
    @IBOutlet private weak var exitButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configProfileTable()
        buildUI()
        bindUI()
    }
    
    func setModel(model: MainProfileVM) {
        self.model = model
    }
    
    private func buildUI() {
        profileTableHeight.constant = Constants.Cells.CellOfProfileTable.height * CGFloat(profileTable.numberOfRows(inSection: 0))
        buildImage()
        buildButton()
    }
    
    private func buildImage() {
        userImage.image = R.image.emptyPhoto()
        userImage.layer.cornerRadius = userImage.frame.width / 2
    }
    
    private func buildButton() {
        exitButton.layer.cornerRadius = Constants.UI.Button.cornerRadius
        exitButton.backgroundColor = Constants.UI.Main.mainColor
        exitButton.tintColor = Constants.UI.Main.alternativeFontColor
        exitButton.titleLabel?.font = Constants.UI.Main.mainFont
        exitButton.setTitle(R.string.localizable.profileMainProfileExitButton(), for: .normal)
    }
    
    private func bindUI() {
        let exitButtonTap = Observable<Void>.merge(exitButton.rx.tap.asObservable())
        let input = MainProfileVM.Input(exitButton: exitButtonTap.asObservable())
        let output = model.transform(input: input)
        output.userImage.drive(userImage.rx.image).disposed(by: disposeBag)
    }
}

extension MainProfileVC: UITableViewDelegate, UITableViewDataSource {
    func configProfileTable() {
        profileTable.delegate = self
        profileTable.dataSource = self
        
        profileTable.register(UINib(nibName: Constants.Cells.mainProfile, bundle: nil),
                              forCellReuseIdentifier: Constants.Cells.mainProfile)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let defaultCell = UITableViewCell()
        guard let profileCell = profileTable.dequeueReusableCell(withIdentifier: Constants.Cells.mainProfile, for: indexPath) as? MainProfileTVC else { return defaultCell }
        switch indexPath.row {
        case 0:
            profileCell.config(type: .myProfile)
        case 1:
            profileCell.config(type: .myCats)
        default:
            return defaultCell
        }
        return profileCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            model.goToMyProfile()
        case 1:
            model.goToMyCats()
        default:
            return
        }
    }
}
