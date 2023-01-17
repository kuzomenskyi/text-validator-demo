//
//  DropDownButton.swift
//  Liquor Sales
//
//  Created by vladimir.kuzomenskyi on 5/23/20.
//  Copyright © 2020 vladimir.kuzomenskyi. All rights reserved.
//

import UIKit

protocol IDropDownButton: UIButton {
    var dropDownMenuDelegate: DropDownMenuDelegate? { get set }
    var dropDownTableView: UITableView? { get }
    var isExpanded: Bool { get }
    var anchorView: UIView? { get set }
    
    func expandDropDownMenu()
    func shortenDropDownMenu()
}

protocol DropDownButtonDelegate: UIView {
    var delegate: DropDownViewDelegate? { get set }
    var tableView: UITableView { get }
    var expandedStateHeight: CGFloat { get }
    var dropDownMenuDelegate: DropDownMenuDelegate? { get set }
    var anchorViewTopSuperview: UIView? { get }
    var isReducesHeightToFitTheSuperviewFrame: Bool { get }
    var isTableViewContentFitsToMenu: Bool { get }
    var isPortrait: Bool { get }
}

final class DropDownButton: UIButton, IDropDownButton {
    enum ButtonAnimation {
        case flip, crossDissolve
    }
    
    // MARK: Constant
    let defaultDropDownMenuHeight: CGFloat = 150
    
    // MARK: Variable
    weak var dropDownMenuDelegate: DropDownMenuDelegate?
    weak var dropDownButtonDelegate: DropDownButtonDelegate?
    var screenEventsObserver = ScreenEventsObserver()
    var dropDownTableView: UITableView?
    var dataSource = [Any]() {
        didSet {
            dropDownButtonDelegate?.tableView.reloadData()
            dataSource.count > 3 ? self.setTableViewSctolling(enabled: true) : self.setTableViewSctolling(enabled: false)
        }
    }
    var anchorView: UIView? {
        didSet {
            configureDropDownView()
        }
    }
    
    var buttonAnimation: ButtonAnimation? = .crossDissolve
    
    lazy var dropDownView: DropDownButtonDelegate = {
        let dropDownView: DropDownButtonDelegate = DropDownView(frame: .zero)
        dropDownView.delegate = self
        return dropDownView
    }()
    
    lazy var animation = Animation(duration: 0.5, delay: 0, springWithDamping: 0.5, initialSpringVelocity: 0.1, options: [.curveEaseInOut], block: { [weak self] in
        self?.dropDownButtonDelegate?.layoutIfNeeded()
    })
    
    var bottomAnchorConstant: CGFloat = -15

    var isExpanded = false {
        didSet {
            if isRounded {
                updateAnchorViewLowerCornerRadius()
            }
            animateButtonIfNeeded()
        }
    }
    
    var isRounded: Bool { anchorView?.layer.cornerRadius != 0 }
    
    // MARK: Private Variable
    private var heightConstraint = NSLayoutConstraint()
    private var bottomAnchorConstraint = NSLayoutConstraint()
    private var heightToApply: CGFloat? {
        var output = isExpanded ? 0 : dropDownButtonDelegate?.expandedStateHeight
        
        // if table view content height is smaller, use it instead (if isReducesHeightToFitTheSuperviewFrame is true)
        if let dropDownButtonDelegate = dropDownButtonDelegate {
            let tableViewContentHeight = dropDownButtonDelegate.tableView.contentSize.height
            let tableViewRowHeight = dropDownButtonDelegate.tableView.estimatedRowHeight
            
            guard tableViewContentHeight < dropDownButtonDelegate.expandedStateHeight else { return output }
            
            if tableViewContentHeight >= tableViewRowHeight {
                output = dropDownButtonDelegate.tableView.contentSize.height * 1.15
            } else {
                output = dropDownButtonDelegate.tableView.estimatedRowHeight
            }
        }
        return output
    }

    // MARK: Init
    override init(frame: CGRect) {
        super.init(frame: frame)

    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // MARK: Action
    
    // MARK: Function
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        dropDownButtonDelegate = dropDownView
        dropDownTableView = dropDownButtonDelegate?.tableView
        subsctibeForScreenTransitionNotification()
    }
    
    // MARK: Private function
    private func subsctibeForScreenTransitionNotification() {
        screenEventsObserver.observeForScreenTransition { [weak self] in
            self?.screenTransitionEvent()
        }
    }
    
    private func configureDropDownView() {
        assert(anchorView != nil, "DropDownButton's anchor is nil!")
        guard let anchorView = anchorView else { return }
        guard let anchorViewTopSuperview = dropDownButtonDelegate?.anchorViewTopSuperview, let delegate = dropDownButtonDelegate else { return }
        delegate.dropDownMenuDelegate = dropDownMenuDelegate
        anchorViewTopSuperview.addSubview(delegate)
        delegate.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            delegate.topAnchor.constraint(equalTo: bottomAnchor),
            delegate.centerXAnchor.constraint(equalTo: anchorView.centerXAnchor),
            delegate.widthAnchor.constraint(equalTo: anchorView.widthAnchor)
        ])
        
        bottomAnchorConstraint = delegate.bottomAnchor.constraint(equalToSystemSpacingBelow: anchorViewTopSuperview.bottomAnchor, multiplier: 1)
        heightConstraint = delegate.heightAnchor.constraint(equalToConstant: 0)
    }
    
    private func updateAnchorViewLowerCornerRadius() {
        guard let anchorView = anchorView else { return }
        let corners: CACornerMask = isExpanded ? [.layerMaxXMinYCorner, .layerMinXMinYCorner] : [.layerMaxXMaxYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMinXMinYCorner]
        let initialFrame = anchorView.frame
        let maxHeight = anchorView.frame.height + 5
        let minHeight = anchorView.frame.height - 5
        
        UIView.animate(withDuration: 0.5, delay: 0.5, animations: {
            anchorView.layer.maskedCorners = corners
        }, completion: { _ in
            UIView.animate(withDuration: 0.25, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: [.curveEaseOut], animations: {
                anchorView.frame.size = CGSize(width: anchorView.frame.width, height: maxHeight)
                anchorView.frame.size = CGSize(width: anchorView.frame.width, height: minHeight)
            }, completion: { _ in
                UIView.animate(withDuration: 0.25, delay: 0, options: [.transitionCurlUp], animations: {
                    anchorView.frame = initialFrame
                })
            })
        })
    }
    
    // MARK: - Private Function
    private func screenTransitionEvent() {
        if isExpanded {
            animation.block = { [weak self] in
                guard let self = self, let delegate = self.dropDownButtonDelegate else { return }
                delegate.frame.size = CGSize(width: delegate.frame.width, height: self.heightToApply ?? self.defaultDropDownMenuHeight )
                delegate.layoutIfNeeded()
            }
            
            NSLayoutConstraint.deactivate([bottomAnchorConstraint, heightConstraint])
            bottomAnchorConstraint.constant = bottomAnchorConstant
            self.heightConstraint.constant = heightToApply ?? 0
            
            if let delegate = dropDownButtonDelegate, delegate.isReducesHeightToFitTheSuperviewFrame {
                if heightConstraint.constant == 0 {
                    heightConstraint.constant = defaultDropDownMenuHeight
                }
                NSLayoutConstraint.activate([heightConstraint])
                #warning("May be handle here separate isTableViewContentFitsToMenu cases")
            }
        }
    }
    
    private func updateDropDownViewPosition() {
        NSLayoutConstraint.deactivate([bottomAnchorConstraint, heightConstraint])
        bottomAnchorConstraint.constant = bottomAnchorConstant
        heightConstraint.constant = heightToApply ?? 0
        if !self.isExpanded {
            if let delegate = dropDownButtonDelegate, delegate.isReducesHeightToFitTheSuperviewFrame {
                if delegate.isTableViewContentFitsToMenu {
                    // activates at first time and drop down menu's height is bigger that table view's content height
                    // height to apply calculation is wrong for the first time expanding menu
                    NSLayoutConstraint.activate([heightConstraint])
                } else {
                    if heightToApply != 0 {
                        NSLayoutConstraint.activate([heightConstraint])
                    } else {
                        NSLayoutConstraint.activate([bottomAnchorConstraint])
                    }
                }
            } else {
                NSLayoutConstraint.activate([heightConstraint])
            }
        }

        updateTableViewPosition()
        isExpanded = !isExpanded
    }
    
    private func updateTableViewPosition() {
        let animate = { [weak self] in
            guard let self = self else { return }
            // swiftlint:disable line_length
            UIView.animate(withDuration: self.animation.duration ?? 0, delay: self.animation.delay ?? 0, usingSpringWithDamping: self.animation.springWithDamping ?? 0, initialSpringVelocity: self.animation.initialSpringVelocity ?? 0, options: self.animation.options ?? [], animations: self.animation.block, completion: self.animation.completion)
        }
        animate()
    }
    
    private func setTableViewSctolling(enabled: Bool) {
        dropDownButtonDelegate?.tableView.isScrollEnabled = enabled
    }
    
    private func animateButtonIfNeeded() {
        guard let buttonAnimation = buttonAnimation else { return }
        
        let angle: CGFloat = isExpanded ? (180.0 * .pi) / 180.0 : 0
        var duration: TimeInterval = 0.25
        let transform = CGAffineTransform(rotationAngle: angle)
        var options = AnimationOptions()
        var block: () -> Void = { [weak self] in
            self?.imageView?.transform = transform
        }
        
        if buttonAnimation == .crossDissolve {
            options = [.transitionCrossDissolve]
            block = { [weak self] in
                self?.imageView?.alpha = 0
                self?.imageView?.alpha = 1
            }
            imageView?.transform = transform
        }
        
        UIView.animate(withDuration: duration, delay: 0, options: options, animations: block)
    }
}

// MARK: - DropDownViewDelegate
extension DropDownButton: DropDownViewDelegate {
    func expandDropDownMenu() {
        animation.block = { [weak self] in
            guard let self = self, let delegate = self.dropDownButtonDelegate else { return }
            delegate.frame.size = CGSize(width: delegate.frame.width, height: self.heightToApply ?? self.defaultDropDownMenuHeight )
            delegate.layoutIfNeeded()
        }
        DispatchQueue.main.async { [weak self] in
            self?.updateDropDownViewPosition()
        }
    }
    
    func shortenDropDownMenu() {
        let dropDownViewHeight = dropDownButtonDelegate?.frame.height ?? defaultDropDownMenuHeight
        animation.block = { [weak self] in
            guard let self = self, let delegate = self.dropDownButtonDelegate else { return }
            delegate.layoutIfNeeded()
            delegate.center.y -= dropDownViewHeight / 2
        }
        DispatchQueue.main.async { [weak self] in
            self?.updateDropDownViewPosition()
        }
    }
}
