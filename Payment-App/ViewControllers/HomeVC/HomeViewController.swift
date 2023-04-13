//
//  HomeViewController.swift
//  Payment-App
//
//  Created by Mahipal on 13/04/23.
//

import UIKit

class HomeViewController: UIViewController {

    // outlets
    @IBOutlet weak var collViewAmounts: UICollectionView!
    @IBOutlet weak var txtFldCustomAmount: UITextField!
    @IBOutlet weak var tblViewUsers: UITableView!
    
    // variables
    var users: [User] = [.init(id: 1, name: "Kiran", balance: 50),
                         .init(id: 2, name: "Pooja", balance: 60),
                         .init(id: 3, name: "Surekha", balance: 70),
                         .init(id: 4, name: "Roa", balance: 80)]
    
    let amounts = [5,10,15,20,25,30]
    
    var selectedAmountCell: IndexPath?
    var selectedUser: User?
    
    // vew life cycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       
    }
    
    // IB Actions
    @IBAction func proceedToPayAction(_ sender: UIButton) {
        let validationResult = doValidations()
        if validationResult.isValid {
            if let qrCodeVC = storyboard?.instantiateViewController(identifier: "QRScannerViewController") as? QRScannerViewController {
                qrCodeVC.delegate = self
                qrCodeVC.amount = validationResult.amount
                qrCodeVC.user = validationResult.user
                self.modalPresentationStyle = .fullScreen
                self.present(qrCodeVC, animated: true)
            }
        }
    }
}

// MARK: Init view mehtods
extension HomeViewController {
    func initViews() {
        self.registerTblViewCell()
        self.tblViewUsers.sectionHeaderTopPadding = 0
    }
    
    func registerTblViewCell() {
        let nib = UINib(nibName: "UserBalanceTableViewCell", bundle: nil)
        self.tblViewUsers.register(nib, forCellReuseIdentifier: "UserBalanceTableViewCell")
    }
    
    private func doValidations() -> (isValid: Bool, user: User?, amount: Int?) {
        if let selectedUser = selectedUser {
            if let selectedAmountCell = selectedAmountCell {
                
                if amounts[selectedAmountCell.item] > selectedUser.balance {
                    
                    ToastUtils.shared.show(with: "\(selectedUser.name) does not have enough balance to pay Rs.\(amounts[selectedAmountCell.item])")
                    return (false, nil, nil)
                } else {
                    return (true, selectedUser, amounts[selectedAmountCell.item])
                }
                
            } else if let amount = Int(txtFldCustomAmount.text ?? "") {
                if amount > selectedUser.balance {
                    ToastUtils.shared.show(with: "\(selectedUser.name) does not have enough balance to pay Rs.\(amount)")
                    return  (false, nil, nil)
                } else {
                    return (true, selectedUser, amount)
                }
                
            } else {
                ToastUtils.shared.show(with: "Please select or enter amount to pay")
                return (false, nil, nil)
            }
        } else {
            ToastUtils.shared.show(with: "Please select user to pay with")
            return (false, nil, nil)
        }
    }
}

// MARK: Table View Delegate and Datasource methods
extension HomeViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "UserBalanceTableViewCell") as? UserBalanceTableViewCell {
            cell.initCell(for: users[indexPath.row])
            return cell
        }
        return UITableViewCell()
    }
  
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = tableView.dequeueReusableCell(withIdentifier: "UserBalanceTableViewCell") as? UserBalanceTableViewCell
        headerView?.initCell(title: "Name", subTitle: "Amount")
        headerView?.contentView.backgroundColor = .cyan
        return headerView?.contentView
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedUser = users[indexPath.item]
    }
}

// MARK: Collection View Data Soruce methods
extension HomeViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return amounts.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SelectAmountCollectionViewCell", for: indexPath) as? SelectAmountCollectionViewCell {
            
            cell.initCell(with: amounts[indexPath.item],
                          isSelected: selectedAmountCell == indexPath)
            return cell
        }
        return UICollectionViewCell()
    }
}

// MARK: Collection View Delegate
extension HomeViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {
        self.selectedAmountCell = indexPath
        self.txtFldCustomAmount.text = ""
        collectionView.reloadData()
    }
}

// MARK: Collection View Flow layout delegate
extension HomeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 12
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 12
    }
}

// MARK: Text Field Delegate
extension HomeViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
    
        let allowedCharacters = CharacterSet.decimalDigits
        let characterSet = CharacterSet(charactersIn: string)
        self.selectedAmountCell = nil
        self.collViewAmounts.reloadData()
        return allowedCharacters.isSuperset(of: characterSet)
    }
}

// MARK: QR Code VC Delegate
extension HomeViewController: QRScannerVCDelegate {
    func paymentSuccessful(_ user: User?, amount: Int?) {
        guard let index = self.users.firstIndex(where: {$0.id == user?.id}) else { return }
        users[index].balance -= (amount ?? 0)
        ToastUtils.shared.show(with: "Payment Successful")
        clearSelections()
    }
    
    func paymentCancelled() {
    
        ToastUtils.shared.show(with: "Payment Cancelled by user")
        clearSelections()
    }
    
    func clearSelections() {
        self.selectedUser = nil
        self.selectedAmountCell = nil
        DispatchQueue.main.async {
            self.tblViewUsers.reloadData()
            self.collViewAmounts.reloadData()
            self.txtFldCustomAmount.text = ""
        }
    }
}
