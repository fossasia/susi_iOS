//
//  MainViewController.swift
//  Susi
//
//  Created by Chashmeet Singh on 2017-03-13.
//  Copyright © 2017 FOSSAsia. All rights reserved.
//

import UIKit
import Material
import Popover
import ALTextInputBar

class MainViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout, ALTextInputBarDelegate {
    
    let cellId: String = "cellId"
    var messages: [Message] = []
    
    fileprivate var popover: Popover!
    private var popoverOptions: [PopoverOption] = [
        .type(.down),
        .blackOverlayColor(UIColor(white: 0.0, alpha: 0.6)),
        .arrowSize(CGSize(width: 12.0, height: 10.0))
    ]
    
    let popoverText = ["Settings", "Wallpaper", "Share", "Logout"]
    
    // Search Button Configure
    let searchButton: IconButton = {
        let ib = IconButton()
        ib.image = Icon.cm.search
        ib.tintColor = .white
        return ib
    }()
    
    // Settings Button Configure
    lazy var settingsButton: IconButton = {
        let image = Icon.cm.moreVertical
        let ib = IconButton()
        ib.image = image
        ib.addTarget(self, action: #selector(showSettingsView), for: .touchUpInside)
        ib.tintColor = .white
        return ib
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTitle()
        setupView()
        setupCollectionView()
        setupInputComponents()
        
        // Dismiss keyboard when touched anywhere in CV
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.resignResponders)))
        
        subscribeToKeyboardNotifications()
    }
    
    func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotification), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotification), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func handleKeyboardNotification(notification: NSNotification) {
        
        if let userInfo = notification.userInfo {
            
            let keyboardFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as AnyObject).cgRectValue
            let isKeyboardShowing = notification.name == NSNotification.Name.UIKeyboardWillShow
            
            bottomConstraint?.constant = isKeyboardShowing ? -keyboardFrame!.height : 0
            
            UIView.animate(withDuration: 0, delay: 0, options: UIViewAnimationOptions.curveEaseOut, animations: {
                
                self.view.layoutIfNeeded()
                
            }, completion: { (completed) in
                
                if isKeyboardShowing {
                    self.scrollToLast()
                }
                
            })
        }
    }
    
    // Resign responders
    func resignResponders() {
        self.view.endEditing(true)
    }
    
    // Setup Navigation Bar
    func setupTitle() {
        navigationItem.title = "    Susi"
        navigationItem.titleLabel.textAlignment = .left
        navigationItem.titleLabel.textColor = .white
        
        navigationItem.rightViews = [searchButton, settingsButton]
    }
    
    // Setup View
    func setupView() {
        self.view.backgroundColor = UIColor.rgb(red: 236, green: 229, blue: 221)
    }
    
    // Setup Settings View
    func showSettingsView() {
        let tableView = UITableView(frame: CGRect(x: 0, y: 0, width: Int(self.view.frame.width / 2), height: (popoverText.count * 44)))
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isScrollEnabled = false
        self.popover = Popover(options: self.popoverOptions)
        self.popover.show(tableView, fromView: settingsButton)
    }
    
    // Setup Collection View
    func setupCollectionView() {
        collectionView?.backgroundColor = .clear
        collectionView?.delegate = self
        
        collectionView?.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height - 50)
        
        collectionView?.register(ChatMessageCell.self, forCellWithReuseIdentifier: cellId)
    }
    
    // Number of items
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    // Configure Cell
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! ChatMessageCell
        let message = messages[indexPath.row]
        
        cell.messageTextView.text = message.body
        
        if let messageText = message.body {
            
            // Incoming message
            let size = CGSize(width: 250, height: 1000)
            let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
            let estimatedFrame = NSString(string: messageText).boundingRect(with: size, options: options, attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 18)], context: nil)
            
            if message.isBot {
                cell.messageTextView.frame = CGRect(x: 16, y: 0, width: estimatedFrame.width + 16, height: estimatedFrame.height + 30)
                
                cell.textBubbleView.frame = CGRect(x: 4, y: -4, width: estimatedFrame.width + 16 + 8 + 16, height: estimatedFrame.height + 20 + 6)
                
                cell.bubbleImageView.image = ChatMessageCell.grayBubbleImage
                cell.bubbleImageView.tintColor = .white
                cell.messageTextView.textColor = UIColor.black
                
            } else {
                
                //outgoing message
                cell.messageTextView.frame = CGRect(x: view.frame.width - estimatedFrame.width - 16 - 16, y: 0, width: estimatedFrame.width + 16, height: estimatedFrame.height + 20)
                
                cell.textBubbleView.frame = CGRect(x:view.frame.width - estimatedFrame.width - 16 - 8 - 16, y: -4, width: estimatedFrame.width + 16 + 8 + 10, height: estimatedFrame.height + 20 + 6)
                
                cell.bubbleImageView.image = ChatMessageCell.blueBubbleImage
                cell.bubbleImageView.tintColor = UIColor.rgb(red: 220, green: 248, blue: 198)
                cell.messageTextView.textColor = .black
            }
        }
        
        return cell
    }
    
    // Calculate Bubble Height
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let message = messages[indexPath.row]
        
        if let messageText = message.body {
            let size = CGSize(width: 250, height: 1000)
            let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
            let estimatedFrame = NSString(string: messageText).boundingRect(with: size, options: options, attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 18)], context: nil)
            
            return CGSize(width: view.frame.width, height: estimatedFrame.height + 20)
        }
        
        return CGSize(width: view.frame.width, height: 100)
    }
    
    // Set Edge Insets
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(8, 0, 0, 0)
    }
    
    // Setup Message Container
    let messageInputContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        return view
    }()
    
    // Setup Input Text Field
    lazy var inputTextField: ALTextInputBar = {
        let textField = ALTextInputBar()
        textField.textView.placeholder = "Ask Susi Something..."
        textField.textView.font = UIFont.systemFont(ofSize: 17)
        textField.backgroundColor = .clear
        textField.delegate = self
        return textField
    }()
    
    // Setup Send Button
    lazy var sendButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Send", for: .normal)
        let titleColor = UIColor(red: 0, green: 137/255, blue: 249/255, alpha: 1)
        button.setTitleColor(titleColor, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.addTarget(self, action: #selector(handleSend), for: .touchUpInside)
        return button
    }()
    
    // Send Button Action
    func handleSend() {
        
        let params = [
            Client.ChatKeys.Query: inputTextField.text!,
            Client.ChatKeys.TimeZoneOffset: "-530"
        ]
        saveMessage()
        
        Client.sharedInstance.queryResponse(params) { (results, success, message) in
            DispatchQueue.main.async {
                if success {
                    self.messages.append(results!)
                }
                self.collectionView?.reloadData()
                self.scrollToLast()
            }
        }
        
    }
    
    var bottomConstraint: NSLayoutConstraint?
    
    // Setup Input Components
    private func setupInputComponents() {
        
        view.addSubview(messageInputContainerView)
        view.addConstraintsWithFormat(format: "H:|[v0]|", views: messageInputContainerView)
        view.addConstraintsWithFormat(format: "V:[v0(48)]", views: messageInputContainerView)
        
        bottomConstraint = NSLayoutConstraint(item: messageInputContainerView, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: 0)
        view.addConstraint(bottomConstraint!)
        
        let topBorderView = UIView()
        topBorderView.backgroundColor = UIColor(white: 0.5, alpha: 0.5)
        
        messageInputContainerView.addSubview(inputTextField)
        messageInputContainerView.addSubview(sendButton)
        messageInputContainerView.addSubview(topBorderView)
        
        messageInputContainerView.addConstraintsWithFormat(format: "H:|-8-[v0][v1(60)]|", views: inputTextField, sendButton)
        
        messageInputContainerView.addConstraintsWithFormat(format: "V:|[v0]|", views: inputTextField)
        messageInputContainerView.addConstraintsWithFormat(format: "V:|[v0]|", views: sendButton)
        
        messageInputContainerView.addConstraintsWithFormat(format: "H:|[v0]|", views: topBorderView)
        messageInputContainerView.addConstraintsWithFormat(format: "V:|[v0(0.5)]", views: topBorderView)
    }
    
    // Temporarily save message to object
    func saveMessage() {
        let message = Message(inputTextField.text!)
        messages.append(message)
        collectionView?.reloadData()
        self.scrollToLast()
        
        inputTextField.text = ""
    }
    
    // Scroll to last message
    func scrollToLast() {
        if messages.count > 0 {
            let lastItem = self.messages.count - 1
            let indexPath = IndexPath(item: lastItem, section: 0)
            self.collectionView?.scrollToItem(at: indexPath, at: .top, animated: true)
        }
    }
    
    // Check if chat field empty
    func textViewDidChange(textView: ALTextView) {
        if let message = inputTextField.text, message.isEmpty {
            sendButton.isUserInteractionEnabled = false
        } else {
            sendButton.isUserInteractionEnabled = true
        }
    }
    
}

extension MainViewController: UITableViewDelegate {
    
    // Handles item click
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.popover.dismiss()
        
        let index = indexPath.row
        
        if index == 0 {
            let settingsController = SettingsViewController(collectionViewLayout: UICollectionViewFlowLayout())
            self.navigationController?.pushViewController(settingsController, animated: true)
        } else if index == 3 {
            logoutUser()
        }
        
    }
    
    func logoutUser() {
        Client.sharedInstance.logoutUser { (success, _) in
            if success {
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
}

extension MainViewController: UITableViewDataSource {
    
    // Number of options in popover
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return popoverText.count
    }
    
    // Configure setting cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
        
        let item = self.popoverText[indexPath.row]
        cell.textLabel?.text = item
        cell.imageView?.image = UIImage(named: item.lowercased())
        return cell
    }
    
}
