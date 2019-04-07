//
//  UserProfileTableViewController.swift
//  VogAppChallenge
//
//  Created by Jason Ngo on 2019-04-06.
//  Copyright © 2019 Jason Ngo. All rights reserved.
//

import UIKit

class UserProfileTableViewController: UITableViewController, Deinitcallable {
    // MARK: - Models
    private let titles = [
        "BASIC INFORMATION",
        "PASSWORD"
    ]
    
    private var user: User?
    
    // MARK: - Styling Constants
    private let heightForActionCell: CGFloat = 55
    private let heightForCell: CGFloat = 45
    private let heightForSection: CGFloat = 30
    
    // MARK: - Deinitialization
    var onDeinit: (() -> Void)?
    deinit {
        onDeinit?()
    }
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        fetchProfileInformation()
    }
    
    // MARK: - Setup
    private func setupTableView() {
        tableView.tableFooterView = UIView(frame: .zero)
        tableView.separatorColor = .clear
        tableView.backgroundColor = #colorLiteral(red: 0.5592061877, green: 0.119877167, blue: 0.1227949187, alpha: 1)
        tableView.contentInset = UIEdgeInsets(top: 25, left: 0, bottom: 0, right: 0)
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    // MARK: -
    private func fetchProfileInformation() {
        APIService.shared.mockRequest(.fetchProfileInformation) { [unowned self] result in
            switch result {
            case .success(let data):
                self.updateUser(with: data)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func updateProfileInformation(firstName: String, lastName: String) {
        print("firstName: \(firstName), lastName: \(lastName)")
        APIService.shared.mockRequest(.updateProfileInformation(firstName: firstName, lastName: lastName)) { result in
            switch result {
            case .success(let data):
                self.updateUser(with: data)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func updateUser(with data: Data) {
        struct DataResult: Decodable {
            let message: String
            let data: [String: String]
        }
        
        do {
            let decodedData = try JSONDecoder().decode(DataResult.self, from: data)
            let user = User(dictionary: decodedData.data)
            self.user = user
            tableView.reloadData()
        } catch {}
    }
    
    private func updatePassword(password: String, verified: String) {
        print("password: \(password), verified: \(verified)")
        APIService.shared.mockRequest(.updatePasswordInformation(currentPwd: verified, newPwd: password, pwdConfirmation: true)) { (result) in
            switch result {
            case .success(let data):
                self.handlePasswordResult(data: data)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func handlePasswordResult(data: Data) {
        struct PasswordUpdateResult: Decodable {
            let data: [String: String]
            let code: String
            let message: String
            let exceptionName: String?
        }
        
        do {
            let pwdUpdateResult = try JSONDecoder().decode(PasswordUpdateResult.self, from: data)
            print(pwdUpdateResult)
        } catch {}
    }
}

extension UserProfileTableViewController: ActionCellDelegate {
    func actionCellPressed(_ cell: ActionCell) {
        view.endEditing(true)
        
        if cell.tag == 1000 {
            let firstNameCell = tableView.cellForRow(at: IndexPath(row: 1, section: 0)) as! InformationCell
            let lastNameCell = tableView.cellForRow(at: IndexPath(row: 2, section: 0)) as! InformationCell
            
            guard let firstName = firstNameCell.textfield.text, let lastName = lastNameCell.textfield.text else {
                return
            }
            
            updateProfileInformation(firstName: firstName, lastName: lastName)
        } else if cell.tag == 2000 {
            
            let passwordCell = tableView.cellForRow(at: IndexPath(row: 0, section: 1)) as! PasswordCell
            let verifiedPwdCell = tableView.cellForRow(at: IndexPath(row: 1, section: 1)) as! PasswordCell
            
            guard let password = passwordCell.textfield.text, let verified = verifiedPwdCell.textfield.text else {
                return
            }
            
            updatePassword(password: password, verified: verified)
        }
    }
}

// MARK: - UITableViewDataSource
extension UserProfileTableViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 4
        case 1:
            return 3
        default:
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            if indexPath.row == 0 {
                let cell = InformationCell(text: "Username")
                cell.addDividerView()
                cell.textfield.text = user?.userName
                return cell
            } else if indexPath.row == 1 {
                let cell = InformationCell(text: "First Name")
                cell.addDividerView()
                cell.textfield.text = user?.firstName
                return cell
            } else if indexPath.row == 2 {
                let cell = InformationCell(text: "Last Name")
                cell.textfield.text = user?.lastName
                return cell
            } else if indexPath.row == 3 {
                let cell = ActionCell()
                cell.delegate = self
                cell.tag = 1000
                return cell
            } else {
                return UITableViewCell()
            }
        case 1:
            if indexPath.row == 0 {
                let cell = PasswordCell(placeholder: "New Password")
                cell.addDividerView()
                return cell
            } else if indexPath.row == 1 {
                let cell = PasswordCell(placeholder: "Re-enter Password")
                return cell
            } else if indexPath.row == 2 {
                let cell = ActionCell()
                cell.delegate = self
                cell.tag = 2000
                return cell
            } else {
                fallthrough
            }
        default:
            return UITableViewCell()
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 1 && indexPath.row == 2 ||
            indexPath.section == 0 && indexPath.row == 3 {
            return heightForActionCell
        }
        
        return heightForCell
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return titles.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return titles[section]
    }
}

// MARK: - UITableViewDelegate
extension UserProfileTableViewController {
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let headerView = view as! UITableViewHeaderFooterView
        headerView.backgroundView?.backgroundColor = #colorLiteral(red: 0.9370916486, green: 0.9369438291, blue: 0.9575446248, alpha: 1)
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return heightForSection
    }
}
