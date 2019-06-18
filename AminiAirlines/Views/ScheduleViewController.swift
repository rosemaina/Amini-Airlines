//
//  ScheduleViewController.swift
//  AminiAirlines
//
//  Created by Rose Maina on 15/06/2019.
//  Copyright © 2019 rose maina. All rights reserved.
//

import UIKit

class ScheduleViewController: UIViewController {
    
    @IBOutlet weak var departureTextField: UITextField!
    @IBOutlet weak var destinationTextField: UITextField!
    @IBOutlet weak var scheduleDateTextField: UITextField!
    @IBOutlet weak var searchFlightBottomConstraint: NSLayoutConstraint!
    
    let datePicker = UIDatePicker()
    let airports = Airports.getPlaces()
    let pickerView = UIPickerView()
    var activeTextField: UITextField?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showDatePicker()
        configureAirportPickerView()
    }
}

extension ScheduleViewController {
    @IBAction func searchFlight(_ sender: UIButton) {
        
    }
    
    @objc func done(){
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        scheduleDateTextField.text = formatter.string(from: datePicker.date)
        self.view.endEditing(true)
    }
    
    @objc func cancelPicker(){
        self.view.endEditing(true)
    }
    
    func showDatePicker() {
        datePicker.datePickerMode = .date
        
        //ToolBar
        let toolbar = UIToolbar();
        toolbar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(done));
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelPicker));
        
        toolbar.setItems([doneButton,spaceButton,cancelButton], animated: false)
        
        scheduleDateTextField.inputAccessoryView = toolbar
        scheduleDateTextField.inputView = datePicker
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        activeTextField = textField
    }
}

extension ScheduleViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    // MARK:- UIPickerView Delegation
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return airports.count
    }
    
    func pickerView( _ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return airports[row].title
    }

    private func pickerView( pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if let activeTextField = activeTextField {
            activeTextField.text = airports[row].title
            activeTextField.resignFirstResponder()
            self.activeTextField = nil
        }
    }
    
    func configureAirportPickerView() {
        departureTextField.inputView = pickerView
        destinationTextField.inputView = pickerView
        
        pickerView.delegate = self
        pickerView.dataSource = self
        pickerView.reloadAllComponents()
    }
}
//client_id 76tmu6fu3gejspxk3942dt55
//client_secret W9YNySqjKs
//grant_type client_credentials
//access_token 7et8uuu2xu4cntag7hwey3ep
//token_type  bearer
