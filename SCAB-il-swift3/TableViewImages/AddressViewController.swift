//
//  AddressViewController.swift
//  SCAB Israel
//
//  Created by Niso Levy
//  Copyright © 2016 NisoLevy. All rights reserved.
//

import UIKit

class AddressViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate {

    @IBOutlet weak var ScrollView: UIScrollView!
    @IBOutlet weak var CommentsTextView: UITextView!
    @IBOutlet weak var ContentView: UIView!
    @IBOutlet weak var FirstNameTextField: UITextField!
    @IBOutlet weak var LastNameTextField: UITextField!
    @IBOutlet weak var PhoneTextField: UITextField!
    @IBOutlet weak var MailTextField: UITextField!
    @IBOutlet weak var BillingAddressTextField: UITextField!
    @IBOutlet weak var ShippingAddressTextField: UITextField!
    @IBOutlet weak var CityTextField: UITextField!
    @IBOutlet weak var ZipCodetextField: UITextField!
    
    override func viewDidLoad() {
        title = "פרטי המזמין"
        addToolBarToView(CommentsTextView)
    }
    
    // MARK: - Tool Bar for TextField
    func addToolBarToField(_ textField: UITextField) {
        
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        //toolBar.tintColor = UIColor(red: 76/255, green: 217/255, blue: 100/255, alpha: 1)
        
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.done, target: self, action: #selector(AddressViewController.donePressed))
        let previousButton = UIBarButtonItem(image: UIImage(named: "previous"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(AddressViewController.previousPressed))
        let nextButton = UIBarButtonItem(image: UIImage(named: "next"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(AddressViewController.nextPressed))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        
        nextButton.width = 50
        
        toolBar.setItems([previousButton, nextButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        toolBar.sizeToFit()
        
        //textField.delegate = self
        textField.inputAccessoryView = toolBar
    }
    
    // MARK: - Tool Bar for TextView
    func addToolBarToView(_ textView: UITextView) {
        
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        //toolBar.tintColor = UIColor(red: 76/255, green: 217/255, blue: 100/255, alpha: 1)
        
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.done, target: self, action: #selector(AddressViewController.donePressed))
        let previousButton = UIBarButtonItem(image: UIImage(named: "previous"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(AddressViewController.previousPressed))
        let nextButton = UIBarButtonItem(image: UIImage(named: "next"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(AddressViewController.nextPressed))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        
        nextButton.width = 50

        toolBar.setItems([previousButton, nextButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        toolBar.sizeToFit()
        
        //textField.delegate = self
        textView.inputAccessoryView = toolBar
    }

    // MARK: - ToolBar Buttons
    // Done Button on the ToolBar
    func donePressed(){
        view.endEditing(true)
    }
    
    // Left Arrow Button on the ToolBar
    func nextPressed() {
        if (FirstNameTextField.isFirstResponder){
            LastNameTextField.becomeFirstResponder()
        } else if (LastNameTextField.isFirstResponder){
            PhoneTextField.becomeFirstResponder()
        } else if (PhoneTextField.isFirstResponder){
            MailTextField.becomeFirstResponder()
        } else if (MailTextField.isFirstResponder){
            BillingAddressTextField.becomeFirstResponder()
        } else if (BillingAddressTextField.isFirstResponder){
            ShippingAddressTextField.becomeFirstResponder()
        } else if (ShippingAddressTextField.isFirstResponder){
            CityTextField.becomeFirstResponder()
        } else if (CityTextField.isFirstResponder){
            ZipCodetextField.becomeFirstResponder()
        } else if (ZipCodetextField.isFirstResponder){
            CommentsTextView.becomeFirstResponder()
        }
    }
    
    // Right Arrow Button on the ToolBar
    func previousPressed() {
        if (CommentsTextView.isFirstResponder){
            ZipCodetextField.becomeFirstResponder()
        } else if (ZipCodetextField.isFirstResponder){
            CityTextField.becomeFirstResponder()
        } else if (CityTextField.isFirstResponder){
            ShippingAddressTextField.becomeFirstResponder()
        } else if (ShippingAddressTextField.isFirstResponder){
            BillingAddressTextField.becomeFirstResponder()
        } else if (BillingAddressTextField.isFirstResponder){
            MailTextField.becomeFirstResponder()
        } else if (MailTextField.isFirstResponder){
            PhoneTextField.becomeFirstResponder()
        } else if (PhoneTextField.isFirstResponder){
            LastNameTextField.becomeFirstResponder()
        } else if (LastNameTextField.isFirstResponder){
            FirstNameTextField.becomeFirstResponder()
        }
    }
    
    // MARK: - Comment Box - Move up when KeyBoard appers
    func textViewDidBeginEditing(_ textView: UITextView) {
        if (textView == CommentsTextView){
            ScrollView.setContentOffset(CGPoint(x: 0, y: 300), animated: true)
        }
        
    }
    // Comment Box - Move down when KeyBoard close
    func textViewDidEndEditing(_ textView: UITextView) {
        ScrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
    }
    
    // MARK: - Return button on KeyBoard - close KeyBoard
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // MARK: - TextField - Move up when KeyBoard appers
    func textFieldDidBeginEditing(_ textField: UITextField) {

        addToolBarToField(textField)
        
        switch textField {
        case PhoneTextField:
            ScrollView.setContentOffset(CGPoint(x: 0, y: 20), animated: true);
        case MailTextField:
            ScrollView.setContentOffset(CGPoint(x: 0, y: 60), animated: true);
        case BillingAddressTextField:
            ScrollView.setContentOffset(CGPoint(x: 0, y: 100), animated: true);
        case ShippingAddressTextField:
            ScrollView.setContentOffset(CGPoint(x: 0, y: 140), animated: true);
        case CityTextField:
            ScrollView.setContentOffset(CGPoint(x: 0, y: 180), animated: true);
        case ZipCodetextField:
            ScrollView.setContentOffset(CGPoint(x: 0, y: 220), animated: true);
        default:
            print("default case");
        }
    }
    
    // TextField - Move down when KeyBoard close
    func textFieldDidEndEditing(_ textField: UITextField) {
        ScrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
    }
    
}
