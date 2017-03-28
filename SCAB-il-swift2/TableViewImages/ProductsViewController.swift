//
//  ProductsViewController.swift
//  SCAB Israel
//
//  Created by Niso Levy
//  Copyright © 2016 NisoLevy. All rights reserved.
//

import UIKit

class ProductsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var categoryName:String!;
    var titles:[String]!;
    var details:[[String]]!;
    
    var arrayOfProduct: [Product] = [Product]()
    
    override func viewDidLoad() {
        
        title = "\(categoryName)";
        
        // Cart Button
        let cartButton = UIBarButtonItem(image: UIImage(named: "cart30"), style: UIBarButtonItemStyle.Plain, target: self, action: "cartScreen");
        self.navigationItem.rightBarButtonItem = cartButton;
        
        setUpCategoryName()
        
        setUpProducts()
        
        // Sort product names by ABC...
        //titles.sortInPlace({$0 < $1})
        
    }
    
    // Move to shopping cart screen - Cart Button
    func cartScreen(){
        let shoppingCartScreen = storyboard?.instantiateViewControllerWithIdentifier("shopping cart view") as! ShoppingCartViewController;
        navigationController?.showViewController(shoppingCartScreen, sender: self);
    }
    
    // Pulling the data according to the correct category name
    func setUpCategoryName(){
        switch categoryName {
        case "פינות ארוח":
            titles = Array(data.acoAreas.keys);
            details = Array(data.acoAreas.values);
        case "ריהוט לגן":
            titles = Array(data.gardenFurniture.keys);
            details = Array(data.gardenFurniture.values);
        case "גרילים":
            titles = Array(data.grills.keys);
            details = Array(data.grills.values);
        case "נדנדות":
            titles = Array(data.swings.keys);
            details = Array(data.swings.values);
        case "כיסויים":
            titles = Array(data.covers.keys);
            details = Array(data.covers.values);
        default:
            print("default case");
        }
    }
    
    // Filling the array with data products
    func setUpProducts() {
        for(var i = 0; i < titles.count; i++){
            var productData = details[i]
            let product = Product(name: titles[i], price: productData[1], image: productData[0])
            arrayOfProduct.append(product)
        }
    }
    
    // MARK: - TableView display
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1;
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayOfProduct.count;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("product cell", forIndexPath: indexPath) as! ProductsViewCell;
        
        let product = arrayOfProduct[indexPath.row]
        
        cell.setCell(product.name, productPrice: product.price, productImage: product.image)
        
        return cell;
    }
    
    // Item selected from table 
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let productInfoScreen = storyboard?.instantiateViewControllerWithIdentifier("product info view") as! ProductInfoViewController;
        //print("Prodact Details \(details)");
        productInfoScreen.categoryName = categoryName;
        productInfoScreen.setTitle = titles[indexPath.row];
        navigationController?.showViewController(productInfoScreen, sender: self);
    }
    
}
