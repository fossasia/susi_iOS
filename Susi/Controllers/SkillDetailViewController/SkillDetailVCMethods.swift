//
//  SkillDetailVCMethods.swift
//  Susi
//
//  Created by Chashmeet Singh on 2017-09-01.
//  Copyright © 2017 FOSSAsia. All rights reserved.
//

import UIKit
import Toast_Swift
import FTPopOverMenu_Swift

extension SkillDetailViewController {

    func addTapGesture() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        ratingsBackStackView.addGestureRecognizer(tap)
    }

    // force dismiss keyboard if open.
    @objc func dismissKeyboard() {
        if self.skillFeedbackTextField.isFirstResponder {
            self.skillFeedbackTextField.resignFirstResponder()
        }
    }

    func registerKeyboardNotifications() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow(notification:)),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide(notification:)),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }

    @objc func keyboardWillShow(notification: NSNotification) {
        let userInfo: NSDictionary = notification.userInfo! as NSDictionary
        if let keyboardInfo = userInfo[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue {
            let keyboardSize = keyboardInfo.cgRectValue.size
            let contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height, right: 0)
            scrollView.contentInset = contentInsets
            scrollView.scrollIndicatorInsets = contentInsets
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        scrollView.contentInset = .zero
        scrollView.scrollIndicatorInsets = .zero
    }

    func setupView() {
        if let skill = skill {
            skillLabel.text = skill.skillName
            if let url = URL(string: skill.imagePath) {
                skillImageView.kf.setImage(with: url)
            }
            skillAuthorLabel.text = "Author: \(skill.author)"
        }
        navigationItem.backButton.tintColor = .white

        examplesCollectionView.delegate = self
        examplesCollectionView.dataSource = self
    }

    func setupFiveStarData() {
        if let skill = skill {
            if skill.totalRatings == 0 {
                ratingsBackStackView.isHidden = true
                topAvgRatingStackView.isHidden = true
                notRatedLabel.isHidden = false
                ratingsBackViewHeightConstraint.constant = 0.0
                feedbackLabelToContraintToNoRated.priority = UILayoutPriority(rawValue: 750)
                feedbackLabelTopConstraintToRatings.priority = UILayoutPriority(rawValue: 250)
            } else {
                barChartView.data = [skill.fiveStar, skill.fourStar, skill.threeStar, skill.twoStar, skill.oneStar]
                fiveStarLabel.text = "\(skill.fiveStar) (\(skill.fiveStar.percentage(outOf: skill.totalRatings)))%"
                fourStarLabel.text = "\(skill.fourStar) (\(skill.fourStar.percentage(outOf: skill.totalRatings)))%"
                threeStarLabel.text = "\(skill.threeStar) (\(skill.threeStar.percentage(outOf: skill.totalRatings)))%"
                twoStarLabel.text = "\(skill.twoStar) (\(skill.twoStar.percentage(outOf: skill.totalRatings)))%"
                oneStarLabel.text = "\(skill.oneStar) (\(skill.oneStar.percentage(outOf: skill.totalRatings)))%"
                averageRatingLabel.text = "\(skill.averageRating.truncate(places: 1))"
                topAvgRatingLabel.text = "\(skill.averageRating.truncate(places: 1))"
                totalRatingsLabel.text = "\(skill.totalRatings)"
            }
        }
    }

    func setupTryItTarget() {
        tryItButton.addTarget(self, action: #selector(trySkillFromExample), for: .touchUpInside)
    }

    @objc func trySkillFromExample() {
        let query = selectedExample ?? self.skill?.examples.first
        weak var weakSelf = self
        navigationController?.dismiss(animated: true, completion: {
            weakSelf?.chatViewControllerDelegate?.searchWith(text: query)
        })
    }

    func addSkillDescription() {
        skillDescription.text = skill?.skillDescription
    }

    func addContentType() {
        view.addSubview(contentType)
        contentType.widthAnchor.constraint(equalToConstant: 140).isActive = true
        contentType.heightAnchor.constraint(equalToConstant: 35).isActive = true
        contentType.leftAnchor.constraint(equalTo: ratingBackView.leftAnchor).isActive = true
        contentType.topAnchor.constraint(equalTo: feedbackDisplayTableView.bottomAnchor, constant: 16).isActive = true

        view.addSubview(content)
        content.leftAnchor.constraint(equalTo: contentType.rightAnchor, constant: -6).isActive = true
        content.topAnchor.constraint(equalTo: contentType.topAnchor, constant: 8).isActive = true
        content.widthAnchor.constraint(equalToConstant: 140).isActive = true
        content.heightAnchor.constraint(equalToConstant: 22).isActive = true

        guard let contents = skill?.dynamic_content else { return }
        if contents {
            content.text = "Dynamic"
        } else {
            content.text = "Static"
        }

    }
    
    @objc func reportSkillAction() {
        let reportSkillAlert = UIAlertController(title: "Report Skill", message: "Flag as inappropriate", preferredStyle: .alert)
        reportSkillAlert.addTextField(configurationHandler: { (textfield: UITextField) in
            textfield.placeholder = "Feedback message"
            textfield.borderStyle = .roundedRect
        })
        let reportAction = UIAlertAction(title: "Report", style: .default, handler: { _ -> Void in
            let feedbackTextField = reportSkillAlert.textFields![0] as UITextField
            if let feedbackMessage = feedbackTextField.text {
                self.reportSkill(feedbackMessage: feedbackMessage)
            }
        })
        let cancleAction = UIAlertAction(title: "Cancel", style: .cancel, handler: { (_: UIAlertAction) -> Void in
        })
        reportSkillAlert.addAction(cancleAction)
        reportSkillAlert.addAction(reportAction)
        self.present(reportSkillAlert, animated: true, completion: nil)
        removeTextBorder(for: reportSkillAlert)
    }

    func reportSkill(feedbackMessage: String) {
        if let delegate = UIApplication.shared.delegate as? AppDelegate, let user = delegate.currentUser {

            let params = [
                Client.SkillListing.model: skill?.model as AnyObject,
                Client.SkillListing.group: skill?.group as AnyObject,
                Client.SkillListing.skill: skill?.skillKeyName as AnyObject,
                Client.SkillListing.language: Locale.current.languageCode as AnyObject,
                Client.SkillListing.accessToken: user.accessToken as AnyObject,
                Client.SkillListing.feedback: feedbackMessage as AnyObject
            ]

            Client.sharedInstance.reportSkill(params) { (success, error) in
                DispatchQueue.main.async {
                    if success {
                        self.view.makeToast("Skill reported successfully")
                    } else if let error = error {
                        self.view.makeToast(error)
                    }
                }
            }
        }
    }
    
    // Share Skill Action
    @objc func shareSkillAction() {
        let activityViewController : UIActivityViewController = UIActivityViewController(activityItems: [ControllerConstants.ShareSkill.message, URL(string: getSkillURL(Client.APIURLs.SkillURL,(skill?.group)!,(skill?.skillName)!,(skill?.language)!)) as Any], applicationActivities: nil)
        // For overcoming the crash in iPad
        activityViewController.popoverPresentationController?.sourceView = self.view
        activityViewController.excludedActivityTypes = [
            UIActivity.ActivityType.airDrop,
            UIActivity.ActivityType.saveToCameraRoll,
            UIActivity.ActivityType.openInIBooks,
            UIActivity.ActivityType.markupAsPDF]
        self.present(activityViewController, animated: true, completion: nil)
        
    }
    
    func skillOptionBarButton() {
        navigationItem.rightViews = [skillOptionButton]
    }
    
    func ftConfig() {
        let config = FTConfiguration.shared
        config.backgoundTintColor = .white
        config.borderColor = .lightGray
        config.menuWidth = 150
        config.menuSeparatorColor = .lightGray
        config.menuRowHeight = 44
        config.cornerRadius = 10
        
    }
    
    @objc func barButtonAction(_ sender: UIBarButtonItem, event: UIEvent) {
        let user = UserDefaults.standard.dictionary(forKey: ControllerConstants.UserDefaultsKeys.user)
        if user != nil {
            ftConfig()
            let cellConfis = Array(repeating: cellConfiguration, count: menuOptionsAfterLogin.count)
            FTPopOverMenu.showForEvent(event: event, with: menuOptionsAfterLogin, menuImageArray: nil, cellConfigurationArray: cellConfis, done: { (selectedIndex) in
                if selectedIndex == 0 {
                    self.shareSkillAction()
                } else {
                    self.reportSkillAction()
                }
            })
        } else {
            ftConfig()
            let cellConfis = Array(repeating: cellConfiguration, count: menuOptionsBeforeLogin.count)
            FTPopOverMenu.showForEvent(event: event, with: menuOptionsBeforeLogin, menuImageArray: nil, cellConfigurationArray: cellConfis,  done: { (selectedIndex) in
                if selectedIndex == 0 {
                    self.shareSkillAction()
                }
            })
        }
    }

    func setupFeedbackTextField() {
        skillFeedbackTextField.placeholderActiveColor = UIColor.skillFeedbackColor()
        skillFeedbackTextField.dividerActiveColor = UIColor.skillFeedbackColor()
    }

    func getRatingByUser() {

        if let delegate = UIApplication.shared.delegate as? AppDelegate, let user = delegate.currentUser {
            getRatingParam = [
                Client.SkillListing.model: skill?.model as AnyObject,
                Client.SkillListing.group: skill?.group as AnyObject,
                Client.SkillListing.language: Locale.current.languageCode as AnyObject,
                Client.SkillListing.skill: skill?.skillKeyName as AnyObject,
                Client.FiveStarRating.AccessToken: user.accessToken as AnyObject
            ]

            Client.sharedInstance.getRatingByUser(getRatingParam) { (userRating, success, _) in
                DispatchQueue.main.async {
                    if success {
                        guard let userRating = userRating else {
                            return
                        }
                        self.ratingView.rating = Double(userRating)
                    }
                }
            }
        }
    }

    // Setup Bar Chart
    func setupBarChart() {
        barChartView.barColors = barChartColors
        barChartView.transform = CGAffineTransform(rotationAngle: .pi/2.0)
        barChartView.barSpacing = 3
        barChartView.backgroundColor = UIColor.barBackgroundColor()
    }

    func removeTextBorder(for alterController: UIAlertController) {
        for textfield: UIView in alterController.textFields! {
            let container: UIView? = textfield.superview
            let effectView = container?.superview?.subviews[0]
            if effectView != nil {
                container?.backgroundColor = UIColor.clear
                effectView?.removeFromSuperview()
            }
        }
    }

}

extension SkillDetailViewController: FloatRatingViewDelegate {

    func floatRatingView(_ ratingView: RatingView, didUpdate rating: Double) {

        submitRatingParams = [
            Client.SkillListing.model: skill?.model as AnyObject,
            Client.SkillListing.group: skill?.group as AnyObject,
            Client.SkillListing.language: Locale.current.languageCode as AnyObject,
            Client.SkillListing.skill: skill?.skillKeyName as AnyObject,
            Client.FiveStarRating.stars: Int(rating) as AnyObject
        ]

        if let delegate = UIApplication.shared.delegate as? AppDelegate, let user = delegate.currentUser {
            submitRatingParams[Client.FiveStarRating.AccessToken] = user.accessToken as AnyObject
        }

        Client.sharedInstance.submitRating(submitRatingParams) { (ratings, success, responseMessage) in
            DispatchQueue.main.async {
                if success {
                    guard let ratings = ratings else {
                        return
                    }
                    if self.ratingsBackViewHeightConstraint.constant == 0 {
                        self.ratingsBackViewHeightConstraint.constant = 128.0
                        self.view.layoutIfNeeded()
                        self.ratingsBackStackView.isHidden = false
                        self.topAvgRatingStackView.isHidden = false
                        self.notRatedLabel.isHidden = true
                        self.feedbackLabelTopConstraintToRatings.priority = UILayoutPriority(rawValue: 750)
                        self.feedbackLabelToContraintToNoRated.priority = UILayoutPriority(rawValue: 250)
                    }
                    self.updateFiveStarData(with: ratings)
                    self.setupBarChart()
                    self.view.makeToast(responseMessage)
                    self.updateSkill(with: ratings)
                } else {
                    self.view.makeToast(responseMessage)
                }
            }
        }
    }

    func updateFiveStarData(with ratings: Ratings) {
        self.barChartView.data = [ratings.fiveStar, ratings.fourStar, ratings.threeStar, ratings.twoStar, ratings.oneStar]
        self.fiveStarLabel.text = "\(ratings.fiveStar) (\(ratings.fiveStar.percentage(outOf: ratings.totalStar)))%"
        self.fourStarLabel.text = "\(ratings.fourStar) (\(ratings.fourStar.percentage(outOf: ratings.totalStar)))%"
        self.threeStarLabel.text = "\(ratings.threeStar) (\(ratings.threeStar.percentage(outOf: ratings.totalStar)))%"
        self.twoStarLabel.text = "\(ratings.twoStar) (\(ratings.twoStar.percentage(outOf: ratings.totalStar)))%"
        self.oneStarLabel.text = "\(ratings.oneStar) (\(ratings.oneStar.percentage(outOf: ratings.totalStar)))%"
        self.averageRatingLabel.text = "\(ratings.average.truncate(places: 1))"
        self.topAvgRatingLabel.text = "\(ratings.average.truncate(places: 1))"
        self.totalRatingsLabel.text = "\(ratings.totalStar)"
    }

    func updateSkill(with ratings: Ratings) {
        skill?.fiveStar = ratings.fiveStar
        skill?.fourStar = ratings.fourStar
        skill?.threeStar = ratings.threeStar
        skill?.twoStar = ratings.twoStar
        skill?.oneStar = ratings.oneStar
        skill?.totalRatings = ratings.totalStar
        skill?.averageRating = ratings.average
    }

}

extension SkillDetailViewController: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    func setupPostButton() {
        postButton.addTarget(self, action: #selector(didPostFeedback), for: .touchUpInside)
    }

    @objc func didPostFeedback() {

        if let delegate = UIApplication.shared.delegate as? AppDelegate, let user = delegate.currentUser {
            if let feedbackText = skillFeedbackTextField.text, feedbackText.count > 0 {
                self.submitSkillFeedback(for: user.accessToken)
            }
        } else {
            let loginAlertController = UIAlertController(title: "You are not logged-in", message: "Please login to post skill feedback", preferredStyle: .alert)
            let loginAction = UIAlertAction(title: "Login", style: .default, handler: { _ in
                self.presentLoginScreen()
            })
            let cancleAction = UIAlertAction(title: "Cancle", style: .cancel, handler: nil)
            loginAlertController.addAction(cancleAction)
            loginAlertController.addAction(loginAction)
            self.present(loginAlertController, animated: true, completion: {
                self.skillFeedbackTextField.text = ""
                self.skillFeedbackTextField.resignFirstResponder()
            })
        }
    }

    func submitSkillFeedback(for accessToken: String) {
        postFeedbackParam = [
            Client.SkillListing.model: skill?.model as AnyObject,
            Client.SkillListing.group: skill?.group as AnyObject,
            Client.SkillListing.skill: skill?.skillKeyName as AnyObject,
            Client.FeedbackKeys.feedback: skillFeedbackTextField.text! as AnyObject,
            Client.FiveStarRating.AccessToken: accessToken as AnyObject
        ]

        Client.sharedInstance.postSkillFeedback(postFeedbackParam) { (_, success, responseMessage) in
            DispatchQueue.main.async {
                if success {
                    self.skillFeedbackTextField.text = ""
                    self.skillFeedbackTextField.resignFirstResponder()
                    self.view.makeToast(responseMessage)
                } else {
                    self.view.makeToast(responseMessage)
                }
            }
        }
    }

    func presentLoginScreen() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let loginVC = storyboard.instantiateViewController(withIdentifier: "LoginController")
        present(loginVC, animated: true, completion: nil)
    }

}

extension SkillDetailViewController: UITableViewDelegate, UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let feedbacks = feedbacks, feedbacks.count > 0 else {
            feedbackTableHeighConstraint.constant = 0.0
            return 0
        }
        if feedbacks.count < 4 {
            feedbackTableHeighConstraint.constant = CGFloat(75 * feedbacks.count)
            return feedbacks.count
        } else {
            feedbackTableHeighConstraint.constant = 269.0
            return 4
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 3 {
            return 44.0
        } else {
            return 75.0
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let feedbacks = feedbacks, feedbacks.count > 0 else {
            feedbackTableHeighConstraint.constant = 0.0
            return UITableViewCell()
        }
        if feedbacks.count < 4 {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "feedbackDisplayCell", for: indexPath) as? FeedbackDisplayCell {
                cell.feedback = feedbacks[indexPath.row - Int(indexPath.row/2)]
                return cell
            }
        } else if feedbacks.count > 3 {
            if indexPath.row == 3 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "allFeedbackCell", for: indexPath)
                return cell
            } else {
                if let cell = tableView.dequeueReusableCell(withIdentifier: "feedbackDisplayCell", for: indexPath) as? FeedbackDisplayCell {
                    cell.feedback = feedbacks[indexPath.row]
                    return cell
                }
            }
        }
        return UITableViewCell()
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 3, let feedbacks = feedbacks, feedbacks.count > 3 {
            self.seeAllReviews()
        }
    }

    func seeAllReviews() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let allFeedbackVC = storyboard.instantiateViewController(withIdentifier: "AllFeedbackController") as? AllFeedbackViewController {
            allFeedbackVC.feedbacks = self.feedbacks
            let nvc = AppNavigationController(rootViewController: allFeedbackVC)
            self.present(nvc, animated: true, completion: nil)
        }
    }

    func getAllFeedback() {

        getFeedbackParam = [
            Client.SkillListing.model: skill?.model as AnyObject,
            Client.SkillListing.group: skill?.group as AnyObject,
            Client.SkillListing.language: Locale.current.languageCode as AnyObject,
            Client.SkillListing.skill: skill?.skillKeyName as AnyObject
        ]

        Client.sharedInstance.getFeedbackData(getFeedbackParam) { (feedbacks, success, _) in
            DispatchQueue.main.async {
                if success {
                    self.feedbacks = feedbacks
                } else {
                }
                self.feedbackDisplayTableView.reloadData()
            }
        }
    }

}
