//
//  CreateGistViewController.swift
//  Gists
//
//  Created by 徐亦农 on 2019/1/12.
//  Copyright © 2019年 Atom. All rights reserved.
//

import UIKit
import XLForm

class CreateGistViewController: XLFormViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelPressed(_:)))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(savePressed(_:)))
    }
    
    @objc
    func cancelPressed(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc
    func savePressed(_ sender: UIBarButtonItem) {
        let validationError = self.formValidationErrors() as? [Error]
        guard validationError?.count == 0 else {
            self.showFormValidationError(validationError!.first)
            return
        }
        self.tableView.endEditing(true)
        
        let isPublic: Bool
        if let isPublicValue = form.formRow(withTag: "isPublic")?.value as? Bool {
            isPublic = isPublicValue
        } else {
            isPublic = false
        }
        
        guard let gistDiscription = form.formRow(withTag: "description")?.value as? String,
            let filename = form.formRow(withTag: "filename")?.value as? String,
            let fileContent = form.formRow(withTag: "fileContent")?.value as? String else {
                print("Could not get values from creation form")
                return
        }
        
        var files: [String: File] = [:]
        let file = File(url: nil, content: fileContent)
        files[filename] = file
        
        let gist = Gist(gistDescription: gistDiscription, files: files, isPublic: isPublic)
        GitHubAPIManager.shared.createNewGist(gist) { (result) in
            guard result.error == nil,
                let successValue = result.value, successValue == true else {
                print(result.error!)
                let alertController = UIAlertController(title: "Could not create gist", message: "Sorry, your gist couldn't be created. " + "Maybe GitHub is down or you don't have an internet connection", preferredStyle: .alert)
                    // add ok button
                    let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                    alertController.addAction(okAction)
                    self.present(alertController, animated: true, completion: nil)
                    return
            }
            let _ = self.navigationController?.popViewController(animated: true)
        }
    }

    required init?(coder aDecoder: NSCoder!) {
        super.init(coder: aDecoder)
        self.initializeForm()
    }
    
    override init(nibName nibNameOrNil: String!, bundle nibBundleOrNil: Bundle!) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.initializeForm()
    }
    
    private func initializeForm() {
        let form = XLFormDescriptor(title: "Gist")
        
        let section1 = XLFormSectionDescriptor.formSection() as XLFormSectionDescriptor
        form.addFormSection(section1)
        
        let descriptionRow = XLFormRowDescriptor(tag: "description", rowType: XLFormRowDescriptorTypeText, title: "Description")
        descriptionRow.isRequired = true
        section1.addFormRow(descriptionRow)
        
        let isPublicRow = XLFormRowDescriptor(tag: "isPublic", rowType: XLFormRowDescriptorTypeText, title: "Public?")
        isPublicRow.isRequired = false
        section1.addFormRow(isPublicRow)
        
        let section2 = XLFormSectionDescriptor.formSection(withTitle: "File1") as XLFormSectionDescriptor
        form.addFormSection(section2)
        
        let filenameRow = XLFormRowDescriptor(tag: "filename", rowType: XLFormRowDescriptorTypeText, title: "Filename")
        filenameRow.isRequired = true
        section2.addFormRow(filenameRow)
        
        let fileContent = XLFormRowDescriptor(tag: "fileContent", rowType: XLFormRowDescriptorTypeText, title: "FileContent")
        fileContent.isRequired = true
        section2.addFormRow(fileContent)
        
        self.form = form
    }

}
