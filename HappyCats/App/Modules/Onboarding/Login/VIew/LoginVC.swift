//
//  LoginVC.swift
//  HappyCats
//
//  Created by Яна Преображенская on 11.05.2020.
//  Copyright © 2020 Яна Преображенская. All rights reserved.
//

import UIKit
import RxSwift

final class LoginVC: UIViewController {
    
    private var model: LoginVM!
    private var disposeBag = DisposeBag()

    @IBOutlet private weak var loginView: UIView!
    @IBOutlet private weak var viewTitle: UILabel!
    @IBOutlet private weak var loginLabel: UILabel!
    @IBOutlet private weak var passwordLabel: UILabel!
    @IBOutlet private weak var loginField: UITextField!
    @IBOutlet private weak var passwordField: UITextField!
    @IBOutlet private weak var loginButton: UIButton!
    @IBOutlet private weak var registrationButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        buildUI()
        bindUI()
    }
    
    func setModel(model: LoginVM) {
        self.model = model
    }
    
    private func buildUI() {
        navigationController?.navigationBar.isHidden = true
        
        loginView.layer.cornerRadius = Constants.UI.View.cornerRadius
        
        buildTitleLabel()
        buildLabel(label: loginLabel, withText: R.string.localizable.authUserLogin())
        buildLabel(label: passwordLabel, withText: R.string.localizable.authUserPassword())

        buildFields()
        buildLoginButton()
        buildRegistrationButton()
    }
    
    private func buildTitleLabel() {
        viewTitle.text = R.string.localizable.authLoginTitle()
        viewTitle.font = Constants.UI.Main.titleFont
    }
    
    private func buildLabel(label: UILabel, withText text: String) {
        label.font = Constants.UI.Main.mainFont
        label.text = text
    }
    
    private func buildFields() {
        loginField.font = Constants.UI.Main.mainFont
        passwordField.font = Constants.UI.Main.mainFont
    }
    
    private func buildLoginButton() {
        loginButton.setTitle(R.string.localizable.authLoginReadyButton(), for: .normal)
        loginButton.titleLabel?.font = Constants.UI.Main.mainFont
        loginButton.layer.cornerRadius = Constants.UI.Button.cornerRadius
        loginButton.backgroundColor = Constants.UI.Main.mainColor
        loginButton.tintColor = Constants.UI.Main.alternativeFontColor
    }
    
    private func buildRegistrationButton() {
        registrationButton.setTitle(R.string.localizable.authLoginRegistrationButton(), for: .normal)
        registrationButton.titleLabel?.font = Constants.UI.Main.smallFont
        registrationButton.tintColor = Constants.UI.Main.mainColor
    }
    
    private func bindUI() {
        let loginButtonClick = Observable<Void>.merge(loginButton.rx.tap.asObservable())
        let registrationButtonClick = Observable<Void>.merge(registrationButton.rx.tap.asObservable())
        let input = LoginVM.Input(loginField: loginField.rx.text.asObservable(),
                                  passwordField: passwordField.rx.text.asObservable(),
                                  loginButtonClick: loginButtonClick,
                                  registrationButtonClick: registrationButtonClick)
        let output = model.transform(input: input)
    }
}
