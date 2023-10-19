//
//  RegistrationVC.swift
//  HappyCats
//
//  Created by Яна Преображенская on 12.05.2020.
//  Copyright © 2020 Яна Преображенская. All rights reserved.
//

import UIKit
import RxSwift

final class RegistrationVC: UIViewController {
    
    private var model: RegistrationVM!

    @IBOutlet private weak var registrationView: UIView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var nameField: UITextField!
    @IBOutlet private weak var emailLabel: UILabel!
    @IBOutlet private weak var emailField: UITextField!
    @IBOutlet private weak var loginLabel: UILabel!
    @IBOutlet private weak var loginField: UITextField!
    @IBOutlet private weak var passwordLabel: UILabel!
    @IBOutlet private weak var passwordField: UITextField!
    @IBOutlet private weak var registrationButton: UIButton!
    @IBOutlet private weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        buildUI()
        bindUI()
    }
    
    func setModel(model: RegistrationVM) {
        self.model = model
    }
    
    private func buildUI() {
        navigationController?.navigationBar.isHidden = true
        
        registrationView.layer.cornerRadius = Constants.UI.View.cornerRadius
        
        buildTitleLabel()
        buildLabel(label: nameLabel, withText: R.string.localizable.authUserName())
        buildLabel(label: emailLabel, withText: R.string.localizable.authUserEmail())
        buildLabel(label: loginLabel, withText: R.string.localizable.authUserLogin())
        buildLabel(label: passwordLabel, withText: R.string.localizable.authUserPassword())

        buildFields()
        buildLoginButton()
        buildRegistrationButton()
    }
    
    private func buildTitleLabel() {
        titleLabel.text = R.string.localizable.authRegistrationTitle()
        titleLabel.font = Constants.UI.Main.titleFont
    }
    
    private func buildLabel(label: UILabel, withText text: String) {
        label.font = Constants.UI.Main.mainFont
        label.text = text
    }
    
    private func buildFields() {
        nameField.font = Constants.UI.Main.mainFont
        emailField.font = Constants.UI.Main.mainFont
        loginField.font = Constants.UI.Main.mainFont
        passwordField.font = Constants.UI.Main.mainFont
    }
    
    private func buildRegistrationButton() {
        registrationButton.setTitle(R.string.localizable.authRegistrationReadyButton(), for: .normal)
        registrationButton.titleLabel?.font = Constants.UI.Main.mainFont
        registrationButton.layer.cornerRadius = Constants.UI.Button.cornerRadius
        registrationButton.backgroundColor = Constants.UI.Main.mainColor
        registrationButton.tintColor = Constants.UI.Main.alternativeFontColor
    }
    
    private func buildLoginButton() {
        loginButton.setTitle(R.string.localizable.authRegistrationLoginButton(), for: .normal)
        loginButton.titleLabel?.font = Constants.UI.Main.smallFont
        loginButton.tintColor = Constants.UI.Main.mainColor
    }
    
    private func bindUI() {
        let registrationButtonClick = Observable<Void>.merge(registrationButton.rx.tap.asObservable())
        let loginButtonClick = Observable<Void>.merge(loginButton.rx.tap.asObservable())
        let input = RegistrationVM.Input(nameField: nameField.rx.text.asObservable(),
                                         emailField: emailField.rx.text.asObservable(),
                                         loginField: loginField.rx.text.asObservable(),
                                         passwordField: passwordField.rx.text.asObservable(),
                                         registrationButtonClick: registrationButtonClick,
                                         loginButtonClick: loginButtonClick)
        let output = model.transform(input: input)
    }
}
