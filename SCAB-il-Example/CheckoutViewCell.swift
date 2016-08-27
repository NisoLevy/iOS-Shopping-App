//
//  CheckoutViewCell.swift
//  SCAB Israel
//
//  Created by Niso Levy
//  Copyright © 2016 NisoLevy. All rights reserved.
//

import UIKit

class CheckoutViewCell: UITableViewCell {

    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var productPrice: UILabel!
    @IBOutlet weak var productQuantity: UILabel!
    
    var productTotalAmount:Int!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func SetProductAttribute(item:Item){
        
        productName.text = item.name
        
        let itemPrice = item.roundPrice as! Int
        let itemQty = item.qty as! Int
        productTotalAmount = itemPrice * itemQty
        productPrice.text = "₪ \(String(productTotalAmount))"
        
        productQuantity.text = String(item.qty!)
    }

}
