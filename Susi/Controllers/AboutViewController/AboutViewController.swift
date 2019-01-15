//
//  AboutViewController.swift
//  Susi
//
//  Created by Syed on 24/12/18.
//  Copyright © 2018 FOSSAsia. All rights reserved.
//

import UIKit
import Material

class AboutViewController: UIViewController, UITextViewDelegate {
    
    @IBOutlet weak var susiDescriptionTextView: UITextView!
    @IBOutlet weak var contributorsTextView: UITextView!
    @IBOutlet weak var susiSkillTextView: UITextView!
    @IBOutlet weak var reportIssueTextView: UITextView!
    @IBOutlet weak var licenseDescriptionTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        susiDescriptionTextView.delegate = self
        contributorsTextView.delegate = self
        susiSkillTextView.delegate = self
        reportIssueTextView.delegate = self
        licenseDescriptionTextView.delegate = self
        susiDescription()
        contributorsDescription()
        susiSkillDescription()
        reportIssueDescription()
        licenseDescription()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {

        let backButton: UIBarButtonItem = UIBarButtonItem(image: Icon.cm.arrowBack, style: .plain, target: self, action: #selector(dismissView))
        self.navigationItem.leftBarButtonItem = backButton
        backButton.tintColor = UIColor.white

    }
    
    @objc func dismissView() {
        self.dismiss(animated: true, completion: nil)
        
    }
    
}
