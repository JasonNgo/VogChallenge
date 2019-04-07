//
//  ActionCell.swift
//  VogAppChallenge
//
//  Created by Jason Ngo on 2019-04-06.
//  Copyright © 2019 Jason Ngo. All rights reserved.
//

import UIKit

protocol ActionCellDelegate: AnyObject {
    func actionCellPressed(_ cell: ActionCell)
}

class ActionCell: UITableViewCell {
    // MARK: - Subviews
    private lazy var actionButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("SAVE CHANGES", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.layer.borderWidth = 1.0
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.cornerRadius = 5.0
        button.widthAnchor.constraint(equalToConstant: 180).isActive = true
        button.heightAnchor.constraint(equalToConstant: 35).isActive = true
        button.addTarget(self, action: #selector(handleActionButtonPressed), for: .touchUpInside)
        return button
    }()
    
    // MARK: -
    weak var delegate: ActionCellDelegate?
    
    // MARK: - Initialization
    init() {
        super.init(style: .default, reuseIdentifier: nil)
        
        backgroundColor = #colorLiteral(red: 0.5592061877, green: 0.119877167, blue: 0.1227949187, alpha: 1)
        selectionStyle = .none
        contentView.addSubview(actionButton)
        actionButton.anchor(
            top: nil,
            leading: nil,
            bottom: contentView.bottomAnchor,
            trailing: nil
        )
        actionButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func handleActionButtonPressed() {
        delegate?.actionCellPressed(self)
    }
}
