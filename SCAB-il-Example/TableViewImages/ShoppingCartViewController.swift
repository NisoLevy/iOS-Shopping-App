//
//  ShoppingCartViewController.swift
//  SCAB Israel
//
//  Created by Niso Levy
//  Copyright © 2016 NisoLevy. All rights reserved.
//

import UIKit
import CoreData

class ShoppingCartViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, ShoppingCartViewCellDelegate {
    
    let moc = DataController().managedObjectContext;
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var ScrollView: UIScrollView!
    @IBOutlet weak var totalCash: UILabel!
    @IBOutlet weak var totalItems: UILabel!
    @IBOutlet weak var orderButton: UIButton!
    
    var listItems = [NSManagedObject]();
    var totalQuantity = 0
    var totalAmount = 0
    
    override func viewDidLoad() {
        title = "עגלת המוצרים"
        
        // Retrieve the data from Core Data
        let fetchRequest = NSFetchRequest(entityName: "Item");
        
        do{
            let results = try moc.executeFetchRequest(fetchRequest);
            listItems = results as! [NSManagedObject];
        }
        catch{
            print("Data did not Retrieve");
        }
        // Refresh tableView
        self.tableView.reloadData();
        
        // Show the total quantity from Core Data when the view did Load
        var itemsQuantity = 0
        for (Qty) in listItems {
            let itemQty = Qty.valueForKey("qty") as! Int
            itemsQuantity = itemsQuantity + itemQty
        }
        
        totalQuantity = itemsQuantity
        totalItems.text = String("סה\"כ מוצרים: \(totalQuantity)");
        
        // Show the total amount when the view did Load
        var totalPrice = 0
        var itemAmount = 0
        for (mony) in listItems {
            let itemPrice = mony.valueForKey("roundPrice") as! Int
            let itemQty = mony.valueForKey("qty") as! Int
            itemAmount = itemPrice * itemQty
            totalPrice = totalPrice + itemAmount
        }
        totalAmount = totalPrice
        totalCash.text = String("סכום כולל: \(totalAmount) ₪");

        // MARK: - Buttons navigation
        // Home Button
        let cartButton = UIBarButtonItem(image: UIImage(named: "home30"), style: UIBarButtonItemStyle.Plain, target: self, action: "homeScreen");
        self.navigationItem.rightBarButtonItem = cartButton;
        
        // Back Button
        let backButton = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.Plain, target: self, action: "goBack")
        self.navigationItem.leftBarButtonItem = backButton;
        // Disable back button 
        self.navigationItem.leftBarButtonItem?.enabled = false
            
    }
    
    // Go to Home screen
    func homeScreen(){
        let homeScreen = storyboard?.instantiateViewControllerWithIdentifier("categories view") as! TableViewController;
        navigationController?.showViewController(homeScreen, sender: self);
    }
    
    // Go Back
    func goBack(){
        let backScreen = storyboard?.instantiateViewControllerWithIdentifier("product info view") as! ProductInfoViewController;
        navigationController?.showViewController(backScreen, sender: self);
    }

    // Showing us the data as soon as we walk directly from the home screen at first load
    override func viewDidAppear(animated: Bool) {
    
        // Retrieve the data from Core Data
        let fetchRequest = NSFetchRequest(entityName: "Item");
        
        do{
            let results = try moc.executeFetchRequest(fetchRequest);
            listItems = results as! [NSManagedObject];
        }
        catch{
            print("Data didn not Retrieve");
        }
        
        // Refresh tableView
        self.tableView.reloadData();
        
        // Print into Debug The products we have in the cart
        for(var i = 0; i < listItems.count; i++){
            print("ListItems\(i): \(listItems[i])")
        }
        
        // Counting the total amount of products we have in the cart
        var itemsQuantity = 0
        for (Qty) in listItems {
            let itemQty = Qty.valueForKey("qty") as! Int
            itemsQuantity = itemsQuantity + itemQty
        }
        
        // If there's 0 product in the cart, disable the checkout button
        self.orderButton?.enabled = (itemsQuantity != 0 && self.listItems.count > 0)
    
    }
    
    // MARK: - TableView display
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1;
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listItems.count;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ShoppingCartViewCell", forIndexPath: indexPath) as! ShoppingCartViewCell;
        
        // Pull the data from the database and display it in the cell
        let item = listItems[indexPath.row] as! Item;
        //print("Full/All Data : \n\(item)")
        
        cell.setItemAttribute(item)
        
        cell.delegate = self
        
        return cell;
        
    }
    
    // MARK: - Quantity Update
    // The cell's quantity's been updated by the stepper control and refresh the cart too.
    func ShoppingCartViewCellSetQuantity(cell: ShoppingCartViewCell, quantity: Int, itemUpdate: Item) {
        
        // Update item quantity 
        itemUpdate.qty = quantity
        
        // Save the new changes
        do{
            try moc.save();
        }catch {
            return;
        }
        
        // MARK: Total Quantity
        // Calculate the items Quantity in the cart
        var itemsQuantity = 0
        for (Qty) in listItems {
            let itemQty = Qty.valueForKey("qty") as! Int
            itemsQuantity = itemsQuantity + itemQty
        }
        
        // If there's < 1 product in the cart, disable the checkout button
        self.orderButton?.enabled = (itemsQuantity != 0)
        
        // totalQuantity equel to items Quantity in the cart
        totalQuantity = itemsQuantity
        totalItems.text = String("סה\"כ מוצרים: \(totalQuantity)");
        
        // MARK: Total Amount
        var totalPrice = 0
        var itemAmount = 0
        for (mony) in listItems {
            let itemPrice = mony.valueForKey("roundPrice") as! Int
            let itemQty = mony.valueForKey("qty") as! Int
            itemAmount = itemPrice * itemQty
            totalPrice = totalPrice + itemAmount
        }
        
        totalAmount = totalPrice
        totalCash.text = String("סכום כולל: \(totalAmount) ₪");

    }
    
    // MARK: - Delete row
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if editingStyle == .Delete {
            
            // Calculate the total quantity of products in the cart after product deleted
            let item = listItems[indexPath.row] as! Item;
            let itemqty = Int(item.qty!)
            totalQuantity = totalQuantity - itemqty
            totalItems.text = String("סה\"כ מוצרים: \(totalQuantity)")
            
            // Calculate the total Amount of products in the cart after product deleted
            let itemAmount = Int(item.roundPrice!) * itemqty
            totalAmount = totalAmount - itemAmount
            totalCash.text = String("סכום כולל: \(totalAmount) ₪")
            
            // Delete product from listItems
            moc.deleteObject(listItems[indexPath.row]);
            self.listItems.removeAtIndex(indexPath.row);
            
            // If there's 0 product in the cart, disable the checkout button
            self.orderButton?.enabled = (self.listItems.count > 0)
            
        }
            // Refresh tableView
            self.tableView.reloadData();
        do{
            try moc.save()
        }catch {
            print("Failed to save");
            return;
        }
    }
    
    // MARK: - Order Button
    @IBAction func performOrderBtn(sender: AnyObject) {
        // If product quantity equal to 0 delete from listItems
        var indexPath = 0
        for (var i = 0; i < listItems.count; i++) {
            if listItems[i].valueForKey("qty") as! Int == 0 {
                indexPath = i
                // Delete product from listItems
                moc.deleteObject(listItems[indexPath]);
                self.listItems.removeAtIndex(indexPath);
            }
        }
        
        do{
            try moc.save()
        }catch {
            print("Failed to save");
            return;
        }

    }
    
    // Pass the total Amount to checkout screen
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "perform order"{
            let checkoutScreen: CheckoutViewController = segue.destinationViewController as! CheckoutViewController
            checkoutScreen.allProductsTotal = totalAmount
        }
        
    }
    
    
}
