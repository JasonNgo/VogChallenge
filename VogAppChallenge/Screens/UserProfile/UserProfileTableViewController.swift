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
    private let sectionTitles = [
        "BASIC INFORMATION",
        "PASSWORD"
    ]
    
    private let informationTitles = [
        "Username",
        "First Name",
        "Last Name"
    ]
    
    private let passwordTitles = [
        "New Password",
        "Re-enter Password"
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
        tableView.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    // MARK: - API Calls
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
    
    // MARK: - Helpers
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

// MARK: - ActionCellDelegate
extension UserProfileTableViewController: ActionCellDelegate {
    func actionCellPressed(_ cell: ActionCell) {
        view.endEditing(true)
        
        if cell.tag == 1000 {
            guard
                let firstNameCell = tableView.cellForRow(at: IndexPath(row: 1, section: 0)) as? InformationCell,
                let lastNameCell = tableView.cellForRow(at: IndexPath(row: 2, section: 0)) as? InformationCell,
                let firstName = firstNameCell.textfield.text,
                let lastName = lastNameCell.textfield.text else {
                return
            }
            
            updateProfileInformation(firstName: firstName, lastName: lastName)
        } else if cell.tag == 2000 {
            guard
                let passwordCell = tableView.cellForRow(at: IndexPath(row: 0, section: 1)) as? PasswordCell,
                let verifiedPwdCell = tableView.cellForRow(at: IndexPath(row: 1, section: 1)) as? PasswordCell,
                let password = passwordCell.textfield.text,
                let verified = verifiedPwdCell.textfield.text else {
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
            return informationTitles.count + 1
        case 1:
            return passwordTitles.count + 1
        default:
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return fetchCell(for: indexPath)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 1 && indexPath.row == 2 || indexPath.section == 0 && indexPath.row == 3 {
            return heightForActionCell
        }
        
        return heightForCell
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return sectionTitles.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionTitles[section]
    }
    
    private func fetchCell(for indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            if indexPath.row == 0 {
                let cell = InformationCell(text: informationTitles[indexPath.row])
                cell.addDividerView()
                cell.textfield.text = user?.userName
                return cell
            } else if indexPath.row == 1 {
                let cell = InformationCell(text: informationTitles[indexPath.row])
                cell.addDividerView()
                cell.textfield.text = user?.firstName
                return cell
            } else if indexPath.row == 2 {
                let cell = InformationCell(text: informationTitles[indexPath.row])
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
                let cell = PasswordCell(placeholder: passwordTitles[indexPath.row])
                cell.addDividerView()
                return cell
            } else if indexPath.row == 1 {
                let cell = PasswordCell(placeholder: passwordTitles[indexPath.row])
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
