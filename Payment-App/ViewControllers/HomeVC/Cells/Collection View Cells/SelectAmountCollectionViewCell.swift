//
//  SelectAmountCollectionViewCell.swift
//  Payment-App
//
//  Created by Mahipal on 13/04/23.
//

import UIKit

class SelectAmountCollectionViewCell: UICollectionViewCell {
    // outlets
    @IBOutlet weak var lblAmount: UILabel!
    @IBOutlet weak var viewBg: UIView!
   
    /// init method
    func initCell(with amount: Int, isSelected: Bool) {
        lblAmount.text = "Rs. \(amount)"
        viewBg.backgroundColor = isSelected ? .systemGreen : .systemOrange
        viewBg.layer.cornerRadius = viewBg.frame.height/2
        viewBg.layer.masksToBounds = true
    }
}
