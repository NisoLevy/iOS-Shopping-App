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
    
    fileprivate var selectedMonth:String?
    fileprivate var selectedYear:String?
    fileprivate let datePicker = UIPickerView()
    fileprivate var monthsArray = Array<Int>()
    fileprivate var yearsArray = Array<String>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "תשלום"
        //print(leftView.frame)
        //print(scrollView.frame.size.width)
        //print(view.frame.width)
        
        datePicker.delegate = self
        datePicker.dataSource = self
        //datePicker.backgroundColor = UIColor.lightGrayColor()
        datePicker.isOpaque = true
        
        // Populate months
        for i in 1...12 {
            monthsArray.append(i)
        }
        
        // Populate years
        let components = (Calendar.current as NSCalendar).components(NSCalendar.Unit.year, from: Date())
        let currentYear = components.year
        let currentShortYear = (NSString(format: "%d", currentYear!).substring(from: 2) as NSString)
        selectedYear = String(format: "%d", currentYear!)
        
        let shortYearNumber = currentShortYear.intValue
        let maxYear = shortYearNumber + 5
        for i in shortYearNumber...maxYear {
            let shortYear = NSString(format: "%d", i)
            yearsArray.append(shortYear as String)
        }
        
    }

    
    // MARK: - Tool Bar for TextField
    func addToolBarToField(_ textField: UITextField) {
        
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.done, target: self, action: #selector(PaymentViewController.donePressed))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        
        toolBar.setItems([spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        toolBar.sizeToFit()
        
        textField.inputAccessoryView = toolBar
    }
    
    // MARK: - ToolBar Buttons
    // Done Button on the ToolBar
    func donePressed(){
        view.endEditing(true)
    }
    
    
    // Return button on KeyBoard - close KeyBoard
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // textField - Move up when KeyBoard appers
    func textFieldDidBeginEditing(_ textField: UITextField) {
        addToolBarToField(textField)
        expiresInTextField?.inputView = datePicker
            }
    
    // textField - Move down when KeyBoard close
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if (selectedYear != nil) && (selectedMonth != nil) {
            let shortYearNumber = (selectedYear! as NSString).intValue
            let shortYear = (NSString(format: "%d", shortYearNumber).substring(from: 2) as NSString)
            let formattedDate = String(format: "%@/%@", selectedMonth!, shortYear)
            expiresInTextField?.text = formattedDate
        }

    }
    
    
    // MARK: - Expires In pickerView
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        if component == 0 {
            return monthsArray.count
            
        } else {
            return yearsArray.count
            
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        if component == 0 {
            return String(format: "%d", monthsArray[row])
            
        } else {
            return yearsArray[row]
            
        }
        
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
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
