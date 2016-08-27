//
//  CheckoutViewController.swift
//  SCAB Israel
//
//  Created by Niso Levy
//  Copyright © 2016 NisoLevy. All rights reserved.
//

import UIKit
import CoreData

class CheckoutViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    let moc = DataController().managedObjectContext;
    var listItems = [NSManagedObject]();
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var totalCartAmount: UILabel!
    @IBOutlet weak var switchButton: UISwitch!
    @IBOutlet weak var deliveryPriceNumber: UILabel!
    
    var allProductsTotal:Int!
    var deliveryPrice = 250
    
    override func viewDidLoad() {
        title = "אישור הזמנה"
        
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
        
        // MARK: - Buttons navigation
        // Home Button
        let cartButton = UIBarButtonItem(image: UIImage(named: "home30"), style: UIBarButtonItemStyle.Plain, target: self, action: "homeScreen");
        
        self.navigationItem.rightBarButtonItem = cartButton;
        
        totalCartAmount.text = "₪ \(String(allProductsTotal + deliveryPrice))"
    }
    
    // Go to Home screen
    func homeScreen(){
        let homeScreen = storyboard?.instantiateViewControllerWithIdentifier("categories view") as! TableViewController;
        navigationController?.showViewController(homeScreen, sender: self);
    }
    
    // Showing us the data that saved from the previous screen
    override func viewWillAppear(animated: Bool) {
        
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
        
        for(var i = 0; i < listItems.count; i++){
            print("ListItems\(i): \(listItems[i])")
        }
        
        totalCartAmount.text = "₪ \(String(allProductsTotal + deliveryPrice))"
    }

    // MARK: - TableView display
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listItems.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("CheckoutViewCell", forIndexPath: indexPath) as! CheckoutViewCell
        
        // Pull the data from the database and display it in the cell
        let item = listItems[indexPath.row] as! Item;
        
        cell.SetProductAttribute(item)
        
        return cell
    }
    
    // MARK: - Swich Button
    @IBAction func ShippingOption(sender: AnyObject) {
        // When it's on delivery fees will be added to the total price
        if switchButton.on{
            totalCartAmount.text = "₪ \(String(allProductsTotal + deliveryPrice))"
            deliveryPriceNumber.alpha = 1;
        }else{
            totalCartAmount.text = "₪ \(String(allProductsTotal))"
            deliveryPriceNumber.alpha = 0.2;
        }
        
    }
    
    
}
