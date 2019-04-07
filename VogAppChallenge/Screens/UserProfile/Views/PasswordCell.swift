//
//  PasswordCell.swift
//  VogAppChallenge
//
//  Created by Jason Ngo on 2019-04-06.
//  Copyright © 2019 Jason Ngo. All rights reserved.
//

import UIKit

class PasswordCell: UITableViewCell {
    // MARK: Subviews
    let textfield = PaddedTextField(padding: 16, height: 25)
    
    private let dividerView: UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.4)
        return view
    }()
    
    // MARK: - Initialization
    init(placeholder: String) {
        super.init(style: .default, reuseIdentifier: nil)
        
        textfield.placeholder = placeholder
        textfield.isSecureTextEntry = true
        setupSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    private func setupSubviews() {
        contentView.addSubview(textfield)
        textfield.fillSuperview()
    }
    
    func addDividerView() {
        contentView.addSubview(dividerView)
        dividerView.anchor(
            top: nil,
            leading: contentView.leadingAnchor,
            bottom: contentView.bottomAnchor,
            trailing: contentView.trailingAnchor,
            padding: .init(top: 0, left: 16, bottom: 0, right: 0),
            size: .init(width: 0, height: 0.5)
        )
    }
}
