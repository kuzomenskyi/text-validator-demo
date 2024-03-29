//
//  MessageView.swift
//  text-validator-demo
//
//  Created by vladimir.kuzomenskyi on 6/24/20.
//  Copyright © 2020 vladimir.kuzomenskyi. All rights reserved.
//

import UIKit

final class MessageView: UIView {

    // MARK: Constant
    
    // MARK: Variable
    
    // MARK: Private Variable
    private var message: Message?
    
    private lazy var messageLabel: UILabel = {
        let label = UILabel()
        label.textColor = message?.color
        label.font = UIFont.fontWithProperties(name: UIFont.Name.avenir, style: .medium, size: 17)
        return label
    }()
    
    private lazy var messageImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    // MARK: Init
    convenience init(withMessage message: Message) {
        self.init(frame: .zero)
        self.message = message
        configureUI()
    }
    
    // MARK: Function
    
    // MARK: Private Function
    private func configureUI() {
        configureMessageImageView(withImage: message?.image ?? UIImage())
        if let message = message {
            configureMessageLabel(withMessage: message)
        }
    }
    
    private func configureMessageImageView(withImage image: UIImage) {
        messageImageView.image = image
        messageImageView.tintColor = message?.color ?? .green
        
        addSubview(messageImageView)
        messageImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            messageImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            messageImageView.heightAnchor.constraint(equalTo: heightAnchor),
            messageImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            messageImageView.widthAnchor.constraint(equalTo: messageImageView.heightAnchor)
        ])
    }
    
    private func configureMessageLabel(withMessage message: Message) {
        messageLabel.text = message.message
        
        addSubview(messageLabel)
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            messageLabel.leadingAnchor.constraint(equalTo: messageImageView.trailingAnchor, constant: frame.width * 1),
            messageLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            messageLabel.heightAnchor.constraint(equalTo: heightAnchor),
            messageLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])
    }
}
