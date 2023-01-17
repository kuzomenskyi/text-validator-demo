//
//  DropDownView.swift
//  Liquor Sales
//
//  Created by vladimir.kuzomenskyi on 5/23/20.
//  Copyright © 2020 vladimir.kuzomenskyi. All rights reserved.
//

import UIKit

#warning("Refactor that in separate DropDownMenu class")

protocol DropDownViewDelegate: AnyObject {
    var dropDownMenuDelegate: DropDownMenuDelegate? { get }
    var anchorView: UIView? { get }
    var dataSource: [Any] { get set }
    var defaultDropDownMenuHeight: CGFloat { get }
    var isRounded: Bool { get }
    
    func expandDropDownMenu()
    func shortenDropDownMenu()
}

@objc protocol DropDownMenuDelegate: AnyObject {
    var dropDownMenuTableViewDelegate: UITableViewDelegate? { get }
    var dropDownMenuTableViewDataSource: UITableViewDataSource? { get }
    
    @objc optional var isReducesHeightToFitTheSuperviewFrame: Bool { get set }
    @objc optional var expandedStateHeight: CGFloat { get set }
    
    @objc optional func configureDropDownView()
}

final class DropDownView: UIView {
    // MARK: Constant
    
    // MARK: Variable
    weak var delegate: DropDownViewDelegate?
    weak var dropDownMenuDelegate: DropDownMenuDelegate? {
        didSet {
            configureTableView()
            roundMenuLowerCornersIfNeeded()
            dropDownMenuDelegate?.configureDropDownView?()
        }
    }
    var anchorView: UIView? { delegate?.anchorView }
    var anchorViewTopSuperview: UIView? {
        var topMostSuperView = delegate?.anchorView?.superview
        while topMostSuperView?.superview != nil {
            topMostSuperView = topMostSuperView?.superview
        }
        return topMostSuperView
    }
    var tableView = UITableView()

    // MARK: Private Variable
    private var futureDropDownView: UIView { UIView(frame: CGRect(x: frame.origin.x, y: frame.origin.y, width: tableView.contentSize.width, height: tableView.contentSize.height)) }
    internal var isPortrait = UIDevice.current.orientation == .portrait
    
    // MARK: Init
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Action
    
    // MARK: Function
    func configureTableView() {
        tableView.dataSource = dropDownMenuDelegate?.dropDownMenuTableViewDataSource
        tableView.delegate = dropDownMenuDelegate?.dropDownMenuTableViewDelegate
        
        addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.widthAnchor.constraint(equalTo: widthAnchor),
            tableView.heightAnchor.constraint(equalTo: heightAnchor),
            tableView.centerXAnchor.constraint(equalTo: centerXAnchor),
            tableView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    // MARK: Private Function
    private func roundMenuLowerCornersIfNeeded() {
        guard let delegate = delegate else { return }
        clipsToBounds = true
        layer.cornerRadius = delegate.isRounded ? delegate.anchorView?.layer.cornerRadius ?? 0 : 0
        layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
    }
    
    private func getExpandedStateHeight() -> CGFloat {
        let screenBounds = UIScreen.main.bounds
        let tableViewContentHeight = tableView.contentSize.height
        var output = tableViewContentHeight * 1.1

        if tableViewContentHeight == 0 {
            output = screenBounds.height * 0.2
        }
        
        guard let anchorViewTopSuperview = anchorViewTopSuperview else { return output }
        let superviewFrame = anchorViewTopSuperview.frame
        if isReducesHeightToFitTheSuperviewFrame {
            if isView(futureDropDownView, outOfViewFrame: superviewFrame) {
                output = shrinkHeightTillFindThatFits(viewToShrink: futureDropDownView, superviewFrame: superviewFrame)
            }
        }
        
        return output
    }
    
    private func shrinkHeightTillFindThatFits(viewToShrink: UIView, superviewFrame: CGRect) -> CGFloat {
        var heightToFind = viewToShrink.frame.height
        repeat {
            viewToShrink.frame.size = CGSize(width: viewToShrink.frame.width, height: heightToFind)
            heightToFind -= 50
            if heightToFind < 0 {
                return delegate?.defaultDropDownMenuHeight ?? 150
            }
        } while isView(viewToShrink, outOfViewFrame: superviewFrame)
        return heightToFind
    }
    
    private func isView(_ innerView: UIView, outOfViewFrame outerViewFrame: CGRect) -> Bool {
        let intersectedFrame = outerViewFrame.intersection(innerView.frame)
        let isInBounds =
            abs(intersectedFrame.origin.y - innerView.frame.origin.y) < 1 &&
            abs(intersectedFrame.size.height - innerView.frame.size.height) < 1
        return !isInBounds
    }
}

// MARK: - DropDownButtonDelegate
extension DropDownView: DropDownButtonDelegate {
    var expandedStateHeight: CGFloat {
        dropDownMenuDelegate?.expandedStateHeight ?? getExpandedStateHeight()
    }
    var isReducesHeightToFitTheSuperviewFrame: Bool { dropDownMenuDelegate?.isReducesHeightToFitTheSuperviewFrame ?? true }
    
    var isTableViewContentFitsToMenu: Bool {
        guard let superviewFrame = anchorViewTopSuperview?.frame else { return false }
        let futureDropDownView = UIView(frame: CGRect(x: frame.origin.x, y: frame.origin.y, width: tableView.contentSize.width, height: tableView.contentSize.height))
        return !isView(futureDropDownView, outOfViewFrame: superviewFrame)
    }
}
