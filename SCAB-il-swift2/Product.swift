//
//  Product.swift
//  SCAB Israel
//
//  Created by Niso Levy
//  Copyright © 2016 NisoLevy. All rights reserved.
//

import Foundation

class Product {
    var name:String!
    var price:String!
    var image:String!


    init(name: String, price: String, image: String)
    {
        self.name = name
        self.price = price
        self.image = image
    }
    
}