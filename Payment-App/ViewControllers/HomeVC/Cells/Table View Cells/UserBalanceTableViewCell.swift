//
//  UserBalanceTableViewCell.swift
//  Payment-App
//
//  Created by Mahipal on 13/04/23.
//

import UIKit

class UserBalanceTableViewCell: UITableViewCell {

    @IBOutlet weak var lblAmount: UILabel!
    @IBOutlet weak var lblName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func initCell(for user: User) {
        lblName.text = user.name
        lblAmount.text = "Rs. \(user.balance)"
    }
    
    func initCell(title: String, subTitle: String) {
        self.lblName.text = title
        self.lblAmount.text = subTitle
    }
}
