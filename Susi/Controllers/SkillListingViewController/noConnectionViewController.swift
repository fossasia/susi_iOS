//
//  noConnectionViewController.swift
//  Susi
//
//  Created by Shivansh Mishra on 19/02/18.
//  Copyright © 2018 FOSSAsia. All rights reserved.
//

import UIKit
import Reachability

class noConnectionViewController: UIViewController {
    var skillListingInstance: SkillListingViewController?
    let reachability = Reachability()!

    let shapelayer = CAShapeLayer()
    var blinkStatus = true

    var connectionStatus = false

    let pulsatingText: UILabel = {
        let label = UILabel()
        label.text = "Tap the screen"
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    let pulsatingText2: UILabel = {
        let label = UILabel()
        label.text = "to refresh"
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white

        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(handlingTheBackButton))

        let center = view.center
        let trackPath = CAShapeLayer()
        let circularPath = UIBezierPath(arcCenter: center, radius: 100, startAngle: CGFloat.pi * -1 / 2, endAngle: 2 * CGFloat.pi, clockwise: true)
        trackPath.path = circularPath.cgPath
        trackPath.strokeColor = UIColor.lightGray.cgColor
        trackPath.lineWidth = 10
        trackPath.lineCap = CAShapeLayerLineCap.round
        trackPath.fillColor = UIColor.clear.cgColor
        view.layer.addSublayer(trackPath)

        shapelayer.path = circularPath.cgPath
        shapelayer.strokeColor = UIColor.defaultColor().cgColor
        shapelayer.lineWidth = 10
        shapelayer.strokeEnd = 0
        shapelayer.lineCap = CAShapeLayerLineCap.round
        shapelayer.fillColor = UIColor.clear.cgColor
        view.layer.addSublayer(shapelayer)

        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tappingGestureRecogniser)))

        view.addSubview(pulsatingText)
        pulsatingText.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        pulsatingText.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -15).isActive = true
        pulsatingText.heightAnchor.constraint(equalToConstant: 180).isActive = true
        pulsatingText.widthAnchor.constraint(equalToConstant: 180).isActive = true

        view.addSubview(pulsatingText2)
        pulsatingText2.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        pulsatingText2.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 15).isActive = true
        pulsatingText2.heightAnchor.constraint(equalToConstant: 180).isActive = true
        pulsatingText2.widthAnchor.constraint(equalToConstant: 180).isActive = true

        var timer = Timer()
        timer = Timer.scheduledTimer(timeInterval: 0.4, target: self, selector: #selector(enableDisable), userInfo: nil, repeats: true)
        // Written this line just to remove warning - It should be removed after implementation of timer.
        _ = timer.timeInterval

        //        checkingForConnection()

    }

    @objc func enableDisable() {
        if blinkStatus {
            pulsatingText.isHidden = true
            pulsatingText2.isHidden = true
            blinkStatus = false
        } else {
            pulsatingText.isHidden = false
            pulsatingText2.isHidden = false
            blinkStatus = true
        }
    }

    @objc func tappingGestureRecogniser() {

        let basicAnimation = CABasicAnimation(keyPath: "strokeEnd")
        basicAnimation.toValue = 1
        basicAnimation.duration = 2
        basicAnimation.fillMode = CAMediaTimingFillMode.forwards
        basicAnimation.isRemovedOnCompletion = false
        shapelayer.add(basicAnimation, forKey: "howdie")
        checkingForConnection()
    }

    func checkingForConnection() {
        if connectionStatus {
            self.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
        }

    }

    @objc func handlingTheBackButton() {
        self.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
    }

}
