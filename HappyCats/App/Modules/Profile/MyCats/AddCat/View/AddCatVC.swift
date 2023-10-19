//
//  AddCatVC.swift
//  HappyCats
//
//  Created by Яна Преображенская on 19.05.2020.
//  Copyright © 2020 Яна Преображенская. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class AddCatVC: UIViewController {
    
    private var model: AddCatVM!
    private var disposeBag = DisposeBag()
    private var allBreeds = [Breed]()
    private let breedPicker = UIPickerView()
    private let datePicker = UIDatePicker()
    private let dateFormatter = DateFormatter()
    
    @IBOutlet weak var catPhoto: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var breedLabel: UILabel!
    @IBOutlet weak var birthdayLabel: UILabel!
    @IBOutlet weak var noteLabel: UILabel!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var breedField: UITextField!
    @IBOutlet weak var birthdayField: UITextField!
    @IBOutlet weak var noteField: UITextView!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var addPhotoButton: UIButton!
    
    override func viewDidLoad() {
        buildUI()
        bindUI()
    }
    
    func setModel(model: AddCatVM) {
        self.model = model
    }
    
    private func buildUI() {
        buildLabel(label: nameLabel, text: R.string.localizable.profileMyCatsName())
        buildLabel(label: breedLabel, text: R.string.localizable.profileMyCatsBreed())
        buildLabel(label: birthdayLabel, text: R.string.localizable.profileMyCatsBirthday())
        buildLabel(label: noteLabel, text: R.string.localizable.profileMyCatsNote())
        
        buildFields()
        buildPickers()
        buildButtons()
        buildImage()
    }
    
    private func buildLabel(label: UILabel, text: String) {
        label.text = text + ":"
        label.font = Constants.UI.Main.mainFont
    }
    
    private func buildFields() {
        nameField.font = Constants.UI.Main.mainFont
        breedField.font = Constants.UI.Main.mainFont
        birthdayField.font = Constants.UI.Main.mainFont
        noteField.font = Constants.UI.Main.mainFont
    }
    
    private func buildPickers() {
        buildBreedPicker()
        buildDatePicker()
    }
    
    private func buildBreedPicker() {
        breedField.inputView = breedPicker
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
        addPhotoButton.titleLabel?.font = Constants.UI.Main.smallFont
        addPhotoButton.tintColor = Constants.UI.Main.mainColor
        addPhotoButton.setTitle(R.string.localizable.buttonChangePhoto(), for: .normal)
    }
    
    private func buildImage() {
        catPhoto.image = R.image.emptyPhoto()
        catPhoto.layer.cornerRadius = catPhoto.frame.width / 2
    }
    
    private func bindUI() {
        let saveButtonTap = Observable<Void>.merge(saveButton.rx.tap.asObservable())
        let input = AddCatVM.Input(name: nameField.rx.text.asObservable(),
                                   breed: breedField.rx.text.asObservable(),
                                   birthday: birthdayField.rx.text.asObservable(),
                                   note: noteField.rx.text.asObservable(),
                                   catPhoto: catPhoto.rx.observe(UIImage.self, "image"),
                                   saveButton: saveButtonTap)
        let output = model.transform(input: input)
        
        output.allBreeds
        .drive(onNext: { breeds in
            self.allBreeds = breeds
        }).disposed(by: disposeBag)

        output.allBreeds
            .drive(breedPicker.rx.itemTitles) { (_, breed) in
                return breed.name
        }.disposed(by: disposeBag)
        
        breedPicker.rx
            .itemSelected
            .subscribe(onNext: { (row, value) in
                self.breedField.text = self.allBreeds[safe: value]?.name
            }).disposed(by: disposeBag)
        
        datePicker.rx
            .date
            .changed
            .subscribe(onNext: { date in
                self.birthdayField.text = self.dateFormatter.string(from: date)
            }).disposed(by: disposeBag)
        
        addPhotoButton.rx
            .tap
            .subscribe(onNext: { _ in
                self.buildImagePicker()
            }).disposed(by: disposeBag)
    }
}

extension AddCatVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    private func buildImagePicker() {
        guard UIImagePickerController.isSourceTypeAvailable(.photoLibrary) else { return }
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        catPhoto.image = info[.originalImage] as? UIImage
        dismiss(animated: true, completion: nil)
    }
}
