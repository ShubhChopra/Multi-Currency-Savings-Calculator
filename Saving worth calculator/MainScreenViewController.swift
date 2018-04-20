//
//  SavingsUIViewController.swift
//  exchange rate
//
//  Created by Shubh Chopra on 08/17/17.
//  Copyright © 2017 Shubh Chopra. All rights reserved.
//

import UIKit
var base:String!
var selectedCurrency:[String]!
var allCurrencyRates:[String]!
var allCurrencyNames:[String]!
class MainScreenViewController: UIViewController, UIPickerViewDelegate, UITextViewDelegate{
    @IBOutlet weak var selectedCurrencyCode: UILabel!
    @IBOutlet weak var selectedExchangeRatePicker: UIPickerView!
    var rotationAngle: CGFloat!
    var selectedExchangeRatePickerYComponent:CGFloat = 0
    var selectedExchangeRatePickerXComponent:CGFloat = 0
    @IBOutlet weak var selectedCurrencyRatePicker: UIPickerView!
    @IBOutlet weak var inputTextVal: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        allCurrencyRates = [String]()
        allCurrencyNames = [String]()
        selectedCurrencyRatePicker.delegate = self
        selectedExchangeRatePicker.delegate = self
        selectedExchangeRatePicker.dataSource = self as? UIPickerViewDataSource
        selectedCurrencyRatePicker.dataSource = self as? UIPickerViewDataSource
        self.inputTextVal.delegate = self as? UITextViewDelegate
        let apiEndPoint = intializeConstants()
        //init toolbar
        let toolbar:UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0,  width: self.view.frame.size.width, height: 30))
        //create left side empty space so that done button set on right side
        let flexSpace = UIBarButtonItem(barButtonSystemItem:    .flexibleSpace, target: nil, action: nil)
        let doneBtn: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: Selector("doneButtonAction"))
        toolbar.setItems([flexSpace, doneBtn], animated: false)
        toolbar.sizeToFit()
        //setting toolbar as inputAccessoryView
        self.inputTextVal.inputAccessoryView = toolbar
        
        guard let url = URL(string: apiEndPoint) else { return }
        
        let task = URLSession.shared.dataTask(with: url) { (data: Data?, response: URLResponse?, error: Error?) in
            
            guard error == nil else { return }
            
            if let httpResponse = response as? HTTPURLResponse {
                
                guard httpResponse.statusCode == 200 else { return }
                
                print("Everything is ok")
            }
            
            guard let data = data else { return }
            
            do {
                
                guard let dict = try JSONSerialization.jsonObject(with: data, options: []) as? [String: AnyObject] else { return }
                
                print(dict.description)
                
                guard let rates = dict["rates"] as? [String: Double], let base = dict["base"] as? String, let date = dict["date"] as? String else { return }
                
                let currencies = rates.keys.sorted()
                allCurrencyNames.append(base)
                if(UserDefaults.standard.value(forKey: "TotalSaving") != nil && UserDefaults.standard.value(forKey: "TotalSaving") as! Float > 1)
                {
                    let totalSavings = UserDefaults.standard.value(forKey: "TotalSaving") as! Float
                    for currency in currencies {
                        
                        if let rate = rates[currency] {
                            
                            allCurrencyRates.append("1 \(base) = \(Float(Float(Int(rate * 100))/100) * totalSavings) \(currency)")
                            allCurrencyNames.append(currency)
                        }

                    }
                }
                else {
                for currency in currencies {
                    
                        if let rate = rates[currency] {
                        
                            allCurrencyRates.append("1 \(base) = \(Float(Float(Int(rate * 100))/100)) \(currency)")
                            allCurrencyNames.append(currency)
                        }
                    }
                }
                self.selectedCurrencyRatePicker.reloadAllComponents()
                self.selectedExchangeRatePicker.reloadAllComponents()
                var index = 0
                for currency in allCurrencyNames
                {
                    if(currency == base)
                    {
                        self.selectedCurrencyRatePicker.selectRow(index, inComponent: 0, animated: true)
                    }
                    index = index + 1
                }
                if(UserDefaults.standard.value(forKey: "ExchangeRate") != nil){
                self.selectedExchangeRatePicker.selectRow(UserDefaults.standard.value(forKey: "ExchangeRate") as! Int, inComponent: 0, animated: true)
                }
                else{
                    self.selectedExchangeRatePicker.selectRow(0, inComponent: 0, animated: true)
                }
                self.selectedExchangeRatePickerYComponent = self.selectedExchangeRatePicker.frame.origin.y
                self.selectedExchangeRatePickerXComponent = self.selectedExchangeRatePicker.frame.origin.x
                self.rotationAngle = (-90 * (.pi / 180) ) as CGFloat
                self.selectedExchangeRatePicker.transform = CGAffineTransform(rotationAngle: self.rotationAngle  )
                self.selectedExchangeRatePicker.frame = CGRect.init(x: self.selectedExchangeRatePickerXComponent - 25, y: self.selectedExchangeRatePickerYComponent, width: self.selectedExchangeRatePicker.frame.height + 50, height:self.selectedExchangeRatePicker.frame.width)
                self.selectedExchangeRatePicker.showsSelectionIndicator = false
                self.selectedExchangeRatePicker.subviews[1].isHidden = true
                self.selectedExchangeRatePicker.subviews[2].isHidden = true
                self.selectedCurrencyRatePicker.subviews[1].isHidden = true
                self.selectedCurrencyRatePicker.subviews[2].isHidden = true
                self.selectedCurrencyCode.isHidden = false
                if(UserDefaults.standard.value(forKey: "TotalSaving") != nil && UserDefaults.standard.value(forKey: "TotalSaving") as! Float > 1){
                    self.selectedCurrencyCode.text = String(UserDefaults.standard.value(forKey: "TotalSaving") as! Float)
                }
            }
            catch {
                
                print("Some error")
            }
            
        }
        task.resume()

        
    }
    func doneButtonAction() {
        self.view.endEditing(true)
        self.selectedCurrencyRatePicker.reloadAllComponents()
        self.selectedExchangeRatePicker.reloadAllComponents()
        loadDataFromInternet()
        self.rotationAngle = (-90 * (.pi / 180) ) as CGFloat
        self.selectedExchangeRatePicker.transform = CGAffineTransform(rotationAngle: self.rotationAngle  )
        self.selectedExchangeRatePicker.frame = CGRect.init(x: self.selectedExchangeRatePickerXComponent - 25, y: self.selectedExchangeRatePickerYComponent, width: self.selectedExchangeRatePicker.frame.height + 50, height:self.selectedExchangeRatePicker.frame.width)
        
    }
    func textViewDidChange(_ inputTextVal: UITextView) {
        selectedCurrencyCode.text = inputTextVal.text
        
    }
    func loadDataFromInternet()
    {
        let apiEndPoint = intializeConstants()
        
        guard let url = URL(string: apiEndPoint) else { return }
        
        let task = URLSession.shared.dataTask(with: url) { (data: Data?, response: URLResponse?, error: Error?) in
            
            guard error == nil else { return }
            
            if let httpResponse = response as? HTTPURLResponse {
                
                guard httpResponse.statusCode == 200 else { return }
                
                print("Everything is ok")
            }
            
            guard let data = data else { return }
            
            do {
                
                guard let dict = try JSONSerialization.jsonObject(with: data, options: []) as? [String: AnyObject] else { return }
                
                print(dict.description)
                
                guard let rates = dict["rates"] as? [String: Double], let base = dict["base"] as? String, let date = dict["date"] as? String else { return }
                
                let currencies = rates.keys.sorted()
                allCurrencyRates.removeAll()
                if(self.selectedCurrencyCode.text != "1.0")
                {
                    for currency in currencies {
                        
                        if let rate = rates[currency] {
                            
                            allCurrencyRates.append("1 \(base) = \(Float(Float(Int(rate * 100))/100) * (self.selectedCurrencyCode.text as! NSString).floatValue) \(currency)")
                            allCurrencyNames.append(currency)
                        }
                        
                    }
                }
                if(UserDefaults.standard.value(forKey: "TotalSaving") != nil && UserDefaults.standard.value(forKey: "TotalSaving") as! Float > 1)
                {
                    let totalSavings = UserDefaults.standard.value(forKey: "TotalSaving") as! Float
                    for currency in currencies {
                        
                        if let rate = rates[currency] {
                            
                            allCurrencyRates.append("1 \(base) = \(Float(Float(Int(rate * 100))/100) * totalSavings) \(currency)")
                            allCurrencyNames.append(currency)
                        }
                        
                    }
                }
                else {
                    for currency in currencies {
                        
                        if let rate = rates[currency] {
                            
                            allCurrencyRates.append("1 \(base) = \(Float(Float(Int(rate * 100))/100)) \(currency)")
                            allCurrencyNames.append(currency)
                        }
                    }
                }
                self.selectedExchangeRatePicker.reloadAllComponents()
            }
            catch {
                
                print("Some error")
            }

        }
        task.resume()
    }
    func intializeConstants() -> String{
        var symbols:String = ""
        if(UserDefaults.standard.value(forKey: "Currency") != nil){
            base = UserDefaults.standard.value(forKey: "Currency") as! String
        }
        if (base == nil || base == "")
        {
                base = "USD";
        }
        if(selectedCurrency != nil)
        {
            if(selectedCurrency.count > 0)
            {
                
                for curr in selectedCurrency {
                    symbols = symbols + "," + curr;
                }
                return "https://api.fixer.io/latest?base=" + base + "&symbols="+symbols;
            }
        }
        else {
            return "https://api.fixer.io/latest?base=" + base;
        }
        selectedCurrencyRatePicker.delegate = self
        selectedExchangeRatePicker.delegate = self
        return ""
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if(pickerView == selectedExchangeRatePicker){
            return allCurrencyRates[row]
        }
        else {
            return allCurrencyNames[row]
        }
    }
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        if(pickerView == selectedExchangeRatePicker)
        {
            let view = UIView.init(frame: CGRect.init(x: 5, y: 0, width: 200, height: 60))
            let label = UILabel.init(frame: CGRect.init(x: 0, y: 0, width: 200  , height: 60))
            label.textAlignment = NSTextAlignment.center
            let startIndex = allCurrencyRates[row].index(allCurrencyRates[row].startIndex, offsetBy: 8)
            let truncated = allCurrencyRates[row].substring(from: startIndex)
            label.text = truncated
            label.textColor = UIColor.white
            label.font = label.font.withSize(30)
            label.adjustsFontSizeToFitWidth = true
            view.addSubview(label)
            view.transform = CGAffineTransform(rotationAngle: (90 * (.pi/180)))
            return view
        }
        else{
            let view = UIView.init(frame: CGRect.init(x: 0, y: 0, width: 50, height: 50))
            let label = UILabel.init(frame: CGRect.init(x: 0, y: 0, width: 50, height: 50))
            label.font = label.font.withSize(30)
            label.adjustsFontSizeToFitWidth = true
            label.textAlignment = NSTextAlignment.center
            label.textColor = UIColor.white
            label.text = getSymbolForCurrencyCode(code: allCurrencyNames[row])
            view.addSubview(label)
            return view

        }

    }
    func getSymbolForCurrencyCode(code: String) -> String? {
        let locale = NSLocale(localeIdentifier: code)
        return locale.displayName(forKey: NSLocale.Key.currencySymbol, value: code)
    }
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        if(pickerView == selectedExchangeRatePicker) {
            return 200
        }
        else{
            return 150
        }
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if(pickerView == selectedCurrencyRatePicker)
        {
            base = allCurrencyNames[selectedCurrencyRatePicker.selectedRow(inComponent: 0)]
           // selectedCurrencyCode.font = selectedCurrencyCode.font.withSize(30)
            UserDefaults.standard.setValue(base, forKey: "Currency")
            loadDataFromInternet()
        }
        if(pickerView == selectedExchangeRatePicker)
        {
            UserDefaults.standard.setValue(row, forKey: "ExchangeRate")
        }
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if(pickerView == selectedExchangeRatePicker){
            return allCurrencyRates.count
        }
        else {
            return allCurrencyNames.count
        }
    }
}

