//
//  MyProfileVC.swift
//  HappyCats
//
//  Created by Яна Преображенская on 14.05.2020.
//  Copyright © 2020 Яна Преображенская. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class MyProfileVC: UIViewController {
    
    @IBOutlet private weak var userImage: UIImageView!
    @IBOutlet private weak var changePhotoButton: UIButton!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var loginLabel: UILabel!
    @IBOutlet private weak var emailLabel: UILabel!
    @IBOutlet private weak var phoneLabel: UILabel!
    @IBOutlet private weak var birthdayLabel: UILabel!
    @IBOutlet private weak var noteLabel: UILabel!
    @IBOutlet private weak var nameField: UITextField!
    @IBOutlet private weak var loginField: UITextField!
    @IBOutlet private weak var emailField: UITextField!
    @IBOutlet private weak var phoneField: UITextField!
    @IBOutlet private weak var birthdayField: UITextField!
    @IBOutlet private weak var noteField: UITextView!
    @IBOutlet private weak var saveButton: UIButton!
    
    private var model: MyProfileVM!
    private var disposeBag = DisposeBag()
    private let datePicker = UIDatePicker()
    private let dateFormatter = DateFormatter()

    override func viewDidLoad() {
        super.viewDidLoad()
        buildUI()
        bindUI()
    }
    
    func setModel(model: MyProfileVM) {
        self.model = model
    }
    
    private func buildUI() {
        buildLabel(label: nameLabel, text: R.string.localizable.profileMyProfileName())
        buildLabel(label: loginLabel, text: R.string.localizable.profileMyProfileLogin())
        buildLabel(label: emailLabel, text: R.string.localizable.profileMyProfileEmail())
        buildLabel(label: phoneLabel, text: R.string.localizable.profileMyProfilePhone())
        buildLabel(label: birthdayLabel, text: R.string.localizable.profileMyProfileBirthday())
        buildLabel(label: noteLabel, text: R.string.localizable.profileMyProfileNote())
        
        buildFields()
        buildDatePicker()
        buildButtons()
        buildImage()
    }
    
    private func buildLabel(label: UILabel, text: String) {
        label.text = text + ":"
        label.font = Constants.UI.Main.mainFont
    }
    
    private func buildFields() {
        nameField.font = Constants.UI.Main.mainFont
        loginField.font = Constants.UI.Main.mainFont
        emailField.font = Constants.UI.Main.mainFont
        phoneField.font = Constants.UI.Main.mainFont
        birthdayField.font = Constants.UI.Main.mainFont
        noteField.font = Constants.UI.Main.mainFont
    }
    
    private func buildDatePicker() {
        datePicker.datePickerMode = .date
        dateFormatter.dateFormat = "dd/MM/yyyy"
        birthdayField.inputView = datePicker
    }
    
    private func buildButtons() {
        buildSaveButton()
        buildPhotoButton()
    }
    
    private func buildSaveButton() {
        saveButton.layer.cornerRadius = Constants.UI.Button.cornerRadius
        saveButton.backgroundColor = Constants.UI.Main.mainColor
        saveButton.tintColor = Constants.UI.Main.alternativeFontColor
        saveButton.titleLabel?.font = Constants.UI.Main.mainFont
        saveButton.setTitle(R.string.localizable.buttonSave(), for: .normal)
    }
    
    private func buildPhotoButton() {
        changePhotoButton.titleLabel?.font = Constants.UI.Main.smallFont
        changePhotoButton.tintColor = Constants.UI.Main.mainColor
        changePhotoButton.setTitle(R.string.localizable.buttonChangePhoto(), for: .normal)
    }
    
    private func buildImage() {
        userImage.image = R.image.emptyPhoto()
        userImage.layer.cornerRadius = userImage.frame.width / 2
    }
    
    private func bindUI() {
        let saveButtonTap = Observable<Void>.merge(saveButton.rx.tap.asObservable())
        let input = MyProfileVM.Input(name: nameField.rx.text.asObservable(),
                                      login: loginField.rx.text.asObservable(),
                                      email: emailField.rx.text.asObservable(),
                                      phone: phoneField.rx.text.asObservable(),
                                      birthday: birthdayField.rx.text.asObservable(),
                                      note: noteField.rx.text.asObservable(),
                                      userPhoto: userImage.rx.observe(UIImage.self, "image"),
                                      saveButton: saveButtonTap)
        let output = model.transform(input: input)
        output.name.drive(nameField.rx.text).disposed(by: disposeBag)
        output.login.drive(loginField.rx.text).disposed(by: disposeBag)
        output.email.drive(emailField.rx.text).disposed(by: disposeBag)
        output.phone.drive(phoneField.rx.text).disposed(by: disposeBag)
        output.birthday.drive(birthdayField.rx.text).disposed(by: disposeBag)
        output.note.drive(noteField.rx.text).disposed(by: disposeBag)
        output.userImage.drive(userImage.rx.image).disposed(by: disposeBag)
        
        output.birthday
            .drive(onNext: { text in
                self.datePicker.date = self.dateFormatter.date(from: text) ?? Date()
            }).disposed(by: disposeBag)
        
        datePicker.rx
            .date
            .changed
            .subscribe(onNext: { date in
                self.birthdayField.text = self.dateFormatter.string(from: date)
            }).disposed(by: disposeBag)
        
        changePhotoButton.rx
            .tap
            .subscribe(onNext: { _ in
                self.buildImagePicker()
            }).disposed(by: disposeBag)
    }
}

extension MyProfileVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    private func buildImagePicker() {
        guard UIImagePickerController.isSourceTypeAvailable(.photoLibrary) else { return }
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        userImage.image = info[.originalImage] as? UIImage
        dismiss(animated: true, completion: nil)
    }
}
