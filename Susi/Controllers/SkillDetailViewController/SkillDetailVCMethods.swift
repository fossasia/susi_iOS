//
//  SkillDetailVCMethods.swift
//  Susi
//
//  Created by Chashmeet Singh on 2017-09-01.
//  Copyright © 2017 FOSSAsia. All rights reserved.
//

import UIKit
import Toast_Swift

extension SkillDetailViewController {

    func addTapGesture() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
    }

    // force dismiss keyboard if open.
    @objc func dismissKeyboard() {
        self.skillFeedbackTextField.resignFirstResponder()
    }

    func registerKeyboardNotifications() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow(notification:)),
                                               name: NSNotification.Name.UIKeyboardWillShow,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide(notification:)),
                                               name: NSNotification.Name.UIKeyboardWillHide,
                                               object: nil)
    }

    @objc func keyboardWillShow(notification: NSNotification) {
        let userInfo: NSDictionary = notification.userInfo! as NSDictionary
        if let keyboardInfo = userInfo[UIKeyboardFrameBeginUserInfoKey] as? NSValue {
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
        navigationController?.dismiss(animated: true, completion: {
            self.chatViewController?.inputTextField.text = query
            self.chatViewController?.handleSend()
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
        contentType.topAnchor.constraint(equalTo: skillFeedbackTextField.bottomAnchor, constant: 16).isActive = true

        view.addSubview(content)
        content.leftAnchor.constraint(equalTo: contentType.rightAnchor, constant: -6).isActive = true
        content.topAnchor.constraint(equalTo: contentType.topAnchor, constant: 8).isActive = true
        content.widthAnchor.constraint(equalToConstant: 140).isActive = true
        content.heightAnchor.constraint(equalToConstant: 22).isActive = true

        guard let contents = skill?.dynamic_content else { return }
        if contents {
            content.text = "Dynamic"
        } else {
            content.text = "Non-Dynamic"
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
            let loginAction = UIAlertAction(title: "Login", style: .default, handler: { action in
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

        Client.sharedInstance.postSkillFeedback(postFeedbackParam) { (feedback, success, responseMessage) in
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
