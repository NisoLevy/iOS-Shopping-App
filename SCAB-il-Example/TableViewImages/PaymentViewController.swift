//
//  PaymentViewController.swift
//  SCAB Israel
//
//  Created by Niso Levy
//  Copyright © 2016 NisoLevy. All rights reserved.
//

import UIKit

class PaymentViewController: UIViewController, UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate {

    @IBOutlet weak var cardNumberTextField: UITextField!
    @IBOutlet weak var expiresInTextField: UITextField!
    @IBOutlet weak var cvvTextField: UITextField!
    
    
    var cellId:String?
    
    //var delegate:TextEntryTableViewCellDelegate?
    
    private var selectedMonth:String?
    private var selectedYear:String?
    private let datePicker = UIPickerView()
    private var monthsArray = Array<Int>()
    private var yearsArray = Array<String>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "תשלום"
        //print(leftView.frame)
        //print(scrollView.frame.size.width)
        //print(view.frame.width)
        
        datePicker.delegate = self
        datePicker.dataSource = self
        //datePicker.backgroundColor = UIColor.lightGrayColor()
        datePicker.opaque = true
        
        // Populate months
        for i in 1...12 {
            monthsArray.append(i)
        }
        
        // Populate years
        let components = NSCalendar.currentCalendar().components(NSCalendarUnit.Year, fromDate: NSDate())
        let currentYear = components.year
        let currentShortYear = (NSString(format: "%d", currentYear).substringFromIndex(2) as NSString)
        selectedYear = String(format: "%d", currentYear)
        
        let shortYearNumber = currentShortYear.intValue
        let maxYear = shortYearNumber + 5
        for i in shortYearNumber...maxYear {
            let shortYear = NSString(format: "%d", i)
            yearsArray.append(shortYear as String)
        }
        
    }

    
    // MARK: - Tool Bar for TextField
    func addToolBarToField(textField: UITextField) {
        
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.Default
        toolBar.translucent = true
        
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.Done, target: self, action: "donePressed")
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil)
        
        toolBar.setItems([spaceButton, doneButton], animated: false)
        toolBar.userInteractionEnabled = true
        toolBar.sizeToFit()
        
        textField.inputAccessoryView = toolBar
    }
    
    // MARK: - ToolBar Buttons
    // Done Button on the ToolBar
    func donePressed(){
        view.endEditing(true)
    }
    
    
    // Return button on KeyBoard - close KeyBoard
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // textField - Move up when KeyBoard appers
    func textFieldDidBeginEditing(textField: UITextField) {
        addToolBarToField(textField)
        expiresInTextField?.inputView = datePicker
            }
    
    // textField - Move down when KeyBoard close
    func textFieldDidEndEditing(textField: UITextField) {
        
        if (selectedYear != nil) && (selectedMonth != nil) {
            let shortYearNumber = (selectedYear! as NSString).intValue
            let shortYear = (NSString(format: "%d", shortYearNumber).substringFromIndex(2) as NSString)
            let formattedDate = String(format: "%@/%@", selectedMonth!, shortYear)
            expiresInTextField?.text = formattedDate
        }

    }
    
    
    // MARK: - Expires In pickerView
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        if component == 0 {
            return monthsArray.count
            
        } else {
            return yearsArray.count
            
        }
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        if component == 0 {
            return String(format: "%d", monthsArray[row])
            
        } else {
            return yearsArray[row]
            
        }
        
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if component == 0 {
            // Month selected
            selectedMonth = String(format: "%d", monthsArray[row])
            
        } else {
            // Year selected
            // WARNING: The following code won't work past year 2100.
            selectedYear = "20" + yearsArray[row]
        }
                
    }

}
