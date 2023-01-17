//
//  ContentTypesView.swift
//  text-validator-demo
//
//  Created by vladimir.kuzomenskyi on 17.01.2023.
//  Copyright © 2023 vladimir.kuzomenskyi. All rights reserved.
//

import UIKit
import SnapKit

final class ContentTypesView: UIView {
    // MARK: Constant
    
    // MARK: Private Constant
    
    // MARK: Variable
    
    // MARK: Private Variable
    private lazy var comingSoonLabel: UILabel = {
        let view: UILabel = .init()
        view.text = "More coming soon..."
        view.textAlignment = .center
        return view
    }()
    
    // MARK: Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Action
    
    // MARK: Private Action
    
    // MARK: Function
    
    // MARK: Private Function
    private func configureUI() {
        backgroundColor = .white
        setComingSoonLabel()
        
        // TODO: Configure
        // Edit name text field
        // Change image button
        // Rules:
        // min length and max length slider
        // areSpaceSymbolsConsidered switch
        // areSpaceSymbolsConsidered info button
        // banned symbols text field
        // banned symbols info button
        // white list symbols text field
        // white list symbols info button
        // requiresBothUppercaseAndLowercase switch
        // requiresBothUppercaseAndLowercase info button
        // requiresAtLeastOneNumberAndCharacter switch
        // requiresAtLeastOneNumberAndCharacter info button
        // exclusiveness picker view (letters, numbers)
        // exclusiveness info button
        // Save button
        // Ask for confirmation if leaving the screen with changes not saved
    }
    
    private func setComingSoonLabel() {
        addSubview(comingSoonLabel)
        comingSoonLabel.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview()
            $0.width.equalToSuperview().multipliedBy(0.8)
        }
    }
}
