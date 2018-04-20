//
//  SavingTableViewController.swift
//  Saving worth calculator
//
//  Created by Shubh Chopra on 8/17/17.
//  Copyright © 2017 Shubh Chopra. All rights reserved.
//

import UIKit

struct cellData {
    let cell: Int!
    let memo: String!
    let date: NSDate!
    let principle: Float!
    let intrest:Float!
    let currency:String!
}
class SavingTableViewController: UITableViewController {

    var totalSaving:Float = 0
    @IBOutlet weak var totalSavingsLabel: UILabel!
    var cellDataCollection = [cellData]()
    override func viewWillAppear(_ animated: Bool) {
        var index = 0
        self.loadData()
        cellDataCollection.removeAll()
        for saving in data{
            cellDataCollection.append(cellData(cell : index , memo: saving.Memo , date: saving.Date , principle: saving.Principle , intrest: saving.Intrest ,currency: saving.Currency))
            index = index + 1
        }
        navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "Add", style: UIBarButtonItemStyle.plain, target: self, action: #selector(addTapped))
        tableView.beginUpdates()
        let range = NSMakeRange(0, self.tableView.numberOfSections)
        let sections = NSIndexSet(indexesIn: range)
        self.tableView.reloadSections(sections as IndexSet, with: .automatic)
        tableView.endUpdates()
        
    }
   
    private func loadData() {
        if let savedSavings = NSKeyedUnarchiver.unarchiveObject(withFile: filePath) as? [Savings] {
            data = savedSavings
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return cellDataCollection.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = Bundle.main.loadNibNamed("SavingsTableViewCell", owner: self, options: nil)?.first as! SavingsTableViewCell
        let formatter = DateFormatter()
        // initially set the format based on your datepicker date
        formatter.dateFormat = "yyyy-MM-dd"
        let myString = formatter.string(from: cellDataCollection[indexPath.row].date! as Date)
        // convert your string to date
        let yourDate = formatter.date(from: myString)
        //then again set the date format whhich type of output you need
        formatter.dateFormat = "dd-MMM-yyyy"
        // again convert your date to string
        cell.dateLabel.text = formatter.string(from: yourDate!)
        cell.intrestLabel.text = String(cellDataCollection[indexPath.row].intrest) + " %"
        var rate:Float = 0.0
        for currency in allCurrencyRates
        {
            if currency.range(of:cellDataCollection[indexPath.row].currency) != nil {
                let endIndex = currency.index(currency.endIndex, offsetBy: -4)
                let startIndex = currency.index(currency.startIndex, offsetBy: 8)
                var truncated = currency.substring(to: endIndex)
                truncated = truncated.substring(from: startIndex)
                rate = Float(truncated)!
            }
        }
        let calendar = NSCalendar.current
        let date1 = calendar.startOfDay(for: cellDataCollection[indexPath.row].date! as Date)
        let date2 = calendar.startOfDay(for: NSDate() as Date)
        let components = calendar.dateComponents([.day], from: date1, to: date2)
        cell.completionProgress.progress = Float(components.day!) / 366
        let totalAmount = cellDataCollection[indexPath.row].principle + ((cellDataCollection[indexPath.row].principle * cellDataCollection[indexPath.row].intrest) / 100 * cell.completionProgress.progress)
        cell.currentAmountOrignal.text = String(totalAmount)
        cell.currentAmountReferenced.text = String(totalAmount / rate)
        cell.currentCurrency.text = cellDataCollection[indexPath.row].currency
        cell.referencedCurrency.text = base
        totalSaving = Float(totalSaving) + ((totalAmount / rate) / 2)
        UserDefaults.standard.setValue(totalSaving, forKey: "TotalSavings")
        navigationItem.title  = "Total Savings: " + String(Float(totalSaving)) + " (" + base + ")"

            cell.DailyIntrestGain.text = String((cellDataCollection[indexPath.row].principle * cellDataCollection[indexPath.row].intrest) / Float(36600.0)) + " / Day(" + cell.currentCurrency.text! + ")"
        cell.DailyIntrestGainReferenceCurrency.text = String(((cellDataCollection[indexPath.row].principle * cellDataCollection[indexPath.row].intrest) / Float(36600.0)) / rate) + " / Day(" + base + ")"
        cell.backgroundViewCard.layer.shadowColor = UIColor.black.cgColor.copy(alpha: 0.2)
            cell.backgroundViewCard.layer.shadowOffset = CGSize.init(width: 0, height: 0)
        cell.backgroundViewCard.layer.shadowOpacity = 0.8
        
        return cell
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 169
    }
    func addTapped()
    {
        performSegue(withIdentifier: "AddSavings", sender: nil)
    }
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            data.remove(at: indexPath.row)
            cellDataCollection.remove(at: indexPath.row)
            NSKeyedArchiver.archiveRootObject(data, toFile: filePath)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
        }
    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
