//
//  ProductInfoViewController.swift
//  SCAB Israel
//
//  Created by Niso Levy
//  Copyright © 2016 NisoLevy. All rights reserved.
//

import UIKit
import CoreData

class ProductInfoViewController: UIViewController {
    
    // Managed Object Context - reference to Core Data / access to Core Data
    let moc = DataController().managedObjectContext;

    @IBOutlet weak var prodactImage: UIImageView!
    @IBOutlet weak var prodactPrice: UILabel!
    @IBOutlet weak var prodactName: UILabel!
    @IBOutlet weak var prodactDescription: UILabel!
    @IBOutlet weak var orderNowButton: UIButton!
    @IBOutlet weak var addToBasketButton: UIButton!
    @IBOutlet weak var alertBox: UIView!
    
    var setTitle:String!;
    var prodactData:[String]!;
    var categoryName:String!;
    var listItems = [NSManagedObject]();
    
    override func viewDidLoad() {
        
        title = "\(setTitle)";
        
        //Buttons attributes
        addToBasketButton.layer.borderWidth = 1;
        addToBasketButton.layer.borderColor = UIColor(red: 2.05, green: 0.35, blue: 0.39, alpha: 1.0).CGColor;
        
        // Cart Button
        let cartButton = UIBarButtonItem(image: UIImage(named: "cart30"), style: UIBarButtonItemStyle.Plain, target: self, action: "cartScreen");
        
        self.navigationItem.rightBarButtonItem = cartButton;
        
        // Retrieve the data from Core Data
        let fetchRequest = NSFetchRequest(entityName: "Item");
        
        do{
            let results = try moc.executeFetchRequest(fetchRequest);
            listItems = results as! [NSManagedObject];
        }
        catch{
            print("Data didn not Retrieve");
        }

        // Pulling the prodact data according to the category name
        switch categoryName {
        case "פינות ארוח":
            prodactData = data.acoAreas[setTitle];
        case "ריהוט לגן":
            prodactData = data.gardenFurniture[setTitle];
        case "גרילים":
            prodactData = data.grills[setTitle];
        case "נדנדות":
            prodactData = data.swings[setTitle];
        case "כיסויים":
            prodactData = data.covers[setTitle];
        default:
            print("default case");
        }

        // Prodact data
        prodactName.text = setTitle;
        prodactImage.image = UIImage(named: prodactData[0]);
        prodactPrice.text = prodactData[1];
        prodactDescription.text = prodactData[3];
    }
    
    // Move to shopping cart screen
    func cartScreen(){
        let shoppingCartScreen = storyboard?.instantiateViewControllerWithIdentifier("shopping cart view") as! ShoppingCartViewController;
        
        navigationController?.showViewController(shoppingCartScreen, sender: self);
    }
    
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

    }
    
    // Order Now Button - add product to shopping cart and move to shopping cart screen
    @IBAction func orderNowButton(sender: UIButton) {
        var productFound = ""
        var indexPath = 0
        
        // Check if product exists
        for (var i = 0; i < listItems.count; i++) {
            if setTitle == listItems[i].valueForKey("name") as! String {
                productFound = setTitle
                indexPath = i
                //print("Product Exists \n\(productFound)")
            }
        }
        
        // If product Not exists create new one, Else exceed the quantity of the product in one
        if productFound.isEmpty {
            //print("EMPTY")
        
            // Add/Save the product info to Core Data attributes
            let entityDescription = NSEntityDescription.entityForName("Item", inManagedObjectContext: moc);
            let item = Item(entity: entityDescription!, insertIntoManagedObjectContext: moc);
            item.name = prodactName.text;
            item.image = UIImagePNGRepresentation(prodactImage.image!);
            item.displayPrice = prodactPrice.text;
            let roundPrice = prodactData[2]
            item.roundPrice = Int(roundPrice)
            item.qty = 1;
        
            //print("Items saved: \(item)");
            do {
                try moc.save();
                listItems.append(item);
            }catch {
                print("Didn't Save");
            }
            
        } else {
            
            let itemUpdate = listItems[indexPath] as! Item;
            itemUpdate.qty = Int(itemUpdate.qty!) + 1
            
            do{
                try moc.save();
            }catch {
                print("Failed to save");
                return;
            }
        }
        
        // Move to shopping cart screen
        let shoppingCartScreen = storyboard?.instantiateViewControllerWithIdentifier("shopping cart view") as! ShoppingCartViewController;
        navigationController?.showViewController(shoppingCartScreen, sender: self);
        
    }
    
    // Add To Basket Button - add product to shopping cart
    @IBAction func addToBasketButton(sender: UIButton) {
        var productFound = ""
        var indexPath = 0
    
        // Check if product exists
        for (var i = 0; i < listItems.count; i++) {
            if setTitle == listItems[i].valueForKey("name") as! String {
                productFound = setTitle
                indexPath = i
                //print("Product Exists \n\(productFound)")
            }
        }

        if productFound.isEmpty {
            //print("EMPTY")
            // Add/Save the product info to Core Data attributes
            let entityDescription = NSEntityDescription.entityForName("Item", inManagedObjectContext: moc);
            let item = Item(entity: entityDescription!, insertIntoManagedObjectContext: moc);
            item.name = prodactName.text;
            item.image = UIImagePNGRepresentation(prodactImage.image!);
            item.displayPrice = prodactPrice.text;
            let roundPrice = prodactData[2]
            item.roundPrice = Int(roundPrice)
            item.qty = 1;
            //print("Items saved: \(item)");
            do {
                try moc.save();
                listItems.append(item);
            }catch {
                print("Didn't Save");
            }
        
            // Alert Box - Main
            if alertBox.hidden==true {
                showAlert()
            } else {
                resetVariables()
                //print("Variables are reset: \(alertBox.hidden)")
                showAlert()
            }
            //print("Alert show: \(alertBox.hidden)")
        } else {
            
            let itemUpdate = listItems[indexPath] as! Item;
            itemUpdate.qty = Int(itemUpdate.qty!) + 1
            
            do{
                try moc.save();
            }catch {
                print("Failed to save");
                return;
            }
            
            // Alert Box - Main
            if alertBox.hidden==true {
                showAlert()
            } else {
                resetVariables()
                showAlert()
            }
        }
        
    }
    
    // Alert Box - Show the alert with animation
    func showAlert(){
        alertBox.hidden=false
        UIView.animateWithDuration(6, animations: {
            self.alertBox.alpha=0;//slow fade out
        });
    }
    // Alert Box - Reset the variables
    func resetVariables(){
        alertBox.hidden=true
        self.alertBox.alpha=1;
    }


}
