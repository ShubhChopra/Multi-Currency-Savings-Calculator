//
//  AddSavingsViewController.swift
//  Saving worth calculator
//
//  Created by Shubh Chopra on 8/16/17.
//  Copyright © 2017 Shubh Chopra. All rights reserved.
//

import UIKit

var data = [Savings]();

var filePath: String{
    let manager = FileManager.default;
    let url = manager.urls(for: .documentDirectory, in: .userDomainMask).first
    return url!.appendingPathComponent("Data").path;
}

class AddSavingsViewController: UIViewController, UIPickerViewDelegate {

    @IBOutlet weak var principleSavingsTextField: UITextField!
    @IBOutlet weak var intrestTextField: UITextField!
    @IBOutlet weak var memoSavingsTextField: UITextField!
    @IBOutlet weak var savingIssueDatePicker: UIDatePicker!
    @IBOutlet weak var currencyPicker: UIPickerView!
    @IBOutlet weak var saveButton: UIButton!
    
   

    override func viewDidLoad() {
        super.viewDidLoad()
        currencyPicker.delegate = self;
        self.savingIssueDatePicker.maximumDate = Date()
        // Do any additional setup after loading the view.
    }

    private func saveData(savings: Savings) {
        data.append(savings)
        NSKeyedArchiver.archiveRootObject(data, toFile: filePath)
    }
    @IBAction func SaveAction(_ sender: Any) {
        let newSavings = Savings(Memo: memoSavingsTextField.text!, Principle: Float(principleSavingsTextField.text!)!, Intrest: Float(intrestTextField.text!)!,Date:savingIssueDatePicker.date as NSDate,Currency: allCurrencyNames[currencyPicker.selectedRow(inComponent: 0)] )
        self.saveData(savings: newSavings)
        _ = navigationController?.popViewController(animated: true)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return allCurrencyNames[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return allCurrencyNames.count
    }

    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
