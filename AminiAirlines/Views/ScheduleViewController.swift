//
//  ScheduleViewController.swift
//  AminiAirlines
//
//  Created by Rose Maina on 15/06/2019.
//  Copyright © 2019 rose maina. All rights reserved.
//

import UIKit

class ScheduleViewController: UIViewController {
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var departureTextField: UITextField!
    @IBOutlet weak var destinationTextField: UITextField!
    @IBOutlet weak var scheduleDateTextField: UITextField!
    @IBOutlet weak var searchFlightBottomConstraint: NSLayoutConstraint!
    
    var activeTextField: UITextField?
    var airPortResponse: AirportResponse? = nil
    
    let datePicker = UIDatePicker()
    let defaults = UserDefaults.standard
    let pickerView = UIPickerView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.isHidden = true
        
        showDatePicker()
        configureAirportPickerView()
        decodeJson()
    }
    
    func decodeJson() {
        let jsonDecoder = JSONDecoder()
        guard let path = Bundle.main.path(forResource: "Airports", ofType: "json") else {
            fatalError("Aiports file not found")
        }
        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: path))
            airPortResponse = try jsonDecoder.decode(AirportResponse.self, from: data)
        }catch{
            print("Could not load json object: \(error.localizedDescription)")
        }
    }
}

extension ScheduleViewController {
    @IBAction func searchFlight(_ sender: UIButton) {
//        activityIndicator.isHidden = false
//        activityIndicator.startAnimating()
        
        let header = [
            "Authorization": "Bearer \(String(describing: defaults.string(forKey: "token")))",
            "Accept": "application/json",
            "Content-Type": "application/json"
        ]
        
        let departureText = departureTextField.text?.split(separator: "_")[1]
        let destinationText = destinationTextField.text?.split(separator: "-")[1]
        let url = "/operations/schedules/\(String(describing: departureText))/\(String(describing: destinationText))/\(String(describing: scheduleDateTextField.text))"
        
        ClientService.standard.get(url: url,
                                   headers: header) { (status, data) -> (Void) in
                                    print("This is the data: \(String(describing: data))")
                                    do {
                                        let formattedData = try JSONSerialization.jsonObject(with: data!, options: [])
                                        print("formattedData: \(formattedData)")
                                    } catch let error {
                                        print("Error passing JSON: \(error)")
                                    }
        }
    }
    
    @objc func cancelPicker(){
        self.view.endEditing(true)
    }
    
    @objc func done(){
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        scheduleDateTextField.text = formatter.string(from: datePicker.date)
        self.view.endEditing(true)
    }
    
    func configureAirportPickerView() {
        departureTextField.inputView = pickerView
        destinationTextField.inputView = pickerView
        
        pickerView.delegate = self
        pickerView.dataSource = self
        pickerView.reloadAllComponents()
    }
    
    func showDatePicker() {
        datePicker.datePickerMode = .date
        
        // Setup ToolBar
        let toolbar = UIToolbar();
        toolbar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(done));
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelPicker));
        
        toolbar.setItems([doneButton,spaceButton,cancelButton], animated: false)
        
        scheduleDateTextField.inputAccessoryView = toolbar
        scheduleDateTextField.inputView = datePicker
    }
    
    func showAlert(with message: String) {
        let alert = UIAlertController(title: "Denied",
                                      message: message,
                                      preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}

extension ScheduleViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    // MARK:- UIPickerView Delegation
        func numberOfComponents(in pickerView: UIPickerView) -> Int {
            return 1
        }
        
        func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
            return airPortResponse?.airportResource.airports.airport.count ?? 1
        }
        
        func pickerView( _ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
            guard let value = airPortResponse?.airportResource.airports.airport[row]  else { return "no value" }
            return (value.timeZoneID + " - " + value.airportCode)
        }
        
        func pickerView( _ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
            guard let value = airPortResponse?.airportResource.airports.airport[row]  else { return }
            if departureTextField.isFirstResponder {
                departureTextField.text = (value.timeZoneID + " - " + value.airportCode)
                departureTextField.resignFirstResponder()
            } else if destinationTextField.isFirstResponder {
                destinationTextField.text = (value.timeZoneID + " - " + value.airportCode)
                destinationTextField.resignFirstResponder()
            }
        }
}

//client_id 76tmu6fu3gejspxk3942dt55
//client_secret W9YNySqjKs
//grant_type client_credentials
//access_token 7et8uuu2xu4cntag7hwey3ep
//token_type  bearer
