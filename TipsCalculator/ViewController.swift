//
//  ViewController.swift
//  TipsCalculator
//
//  Created by Ignacio Bogarin on 06/02/23.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var totalInvoiceLabel: UILabel!
    @IBOutlet weak var totalSplitLabel: UILabel!
    @IBOutlet weak var totalBillLabel: UILabel!
    @IBOutlet weak var peoplePicker: UIPickerView!
    @IBOutlet weak var tipsPicker: UIPickerView!
    @IBOutlet weak var pointButtonUI: UIButton!
    var isDecimal = false
    var textDecimal = ""
    var textTotal = ""
    var totalInvoice : Double = 0
    var billTotal : Double = 0
    var split :Int = 1
    var splitTotal : Double = 0
    var tip : Int = 0
    var tipTotal : Double = 0
    var people = [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20]
    var porcent = [0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tipsPicker.dataSource = self
        tipsPicker.delegate = self
        
        peoplePicker.dataSource = self
        peoplePicker.delegate = self
        
        tipsPicker.tag = 0
        peoplePicker.tag = 1
        
        totalInvoiceLabel.text = "$ 0.00"
        totalBillLabel.text = "$ 0"
        totalSplitLabel.text = "$ 0.00"
        
    }
    
    @IBAction func ButtonNumbers(_ sender: UIButton) {
        print(sender.tag)
        if isDecimal {
            if textDecimal.count < 2 {
                textDecimal += String(sender.tag)
                billTotal = Double(textTotal+"."+textDecimal) ?? 0
                
                if textDecimal.count == 1 {
                    totalBillLabel.text = "$ \(String(format: "%.1f", billTotal))"
                }
                if textDecimal.count == 2 {
                    totalBillLabel.text = "$ \(String(format: "%.2f", billTotal))"
                }
            }
        } else {
            textTotal += String(sender.tag)
            billTotal = Double(textTotal) ?? 0
            
            totalBillLabel.text = "$ \(String(format: "%.0f", billTotal))"
        }
        calculation()
        
    }
    @IBAction func point(_ sender: UIButton) {
        print(".")
        isDecimal = true
        
        self.pointButtonUI.setImage(UIImage(systemName: "dot.squareshape.fill"), for: .normal)
        
        //dot.viewfinder
        
    }
    
    @IBAction func backSpace(_ sender: UIButton) {
        print("<-")
        if isDecimal {
            if textDecimal.count == 0 {
                isDecimal = false
                self.pointButtonUI.setImage(UIImage(systemName: "dot.viewfinder"), for: .normal)
            }
            if textDecimal.count == 1 {
                textDecimal = String(textDecimal.prefix(textDecimal.count - 1))
                billTotal = Double(textTotal+"."+textDecimal) ?? 0
                
                totalBillLabel.text = "$ \(String(format: "%.0f", billTotal))"
                
                isDecimal = false
                self.pointButtonUI.setImage(UIImage(systemName: "dot.viewfinder"), for: .normal)
            }
            
            if textDecimal.count == 2 {
                textDecimal = String(textDecimal.prefix(textDecimal.count - 1))
                billTotal = Double(textTotal+"."+textDecimal) ?? 0
                
                totalBillLabel.text = "$ \(String(format: "%.1f", billTotal))"
            }

            
        } else {
            if textTotal.count > 0 {
                textTotal = String(textTotal.prefix(textTotal.count - 1))
            }
            billTotal = Double(textTotal) ?? 0
            totalBillLabel.text = "$ \(String(format: "%.0f", billTotal))"
        }
        
        calculation()
    }
    
    func calculation() {
        let currencyFormatter = NumberFormatter()
        currencyFormatter.usesGroupingSeparator = true
        currencyFormatter.numberStyle = .currency
        // localize to your grouping and decimal separator
        currencyFormatter.locale = Locale.current
        
        //
        let propine = (billTotal * Double(tip)) / 100
        let total = billTotal + propine
        let divide = total / Double(split)
        
        totalInvoiceLabel.text = currencyFormatter.string(from: NSNumber(value: total))
        totalSplitLabel.text = currencyFormatter.string(from: NSNumber(value: divide))
    }
    

}

extension ViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if (pickerView.tag == 0) {
            return porcent.count
        } else {
            return people.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if (pickerView.tag == 0) {
            return String(porcent[row])
        }
        else {
            return String(people[row])
        }
        
    }
    /*
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        //return NSAttributedString(string: pickerData[row], attributes: [NSAttributedString.Key.foregroundColor : UIColor.white])
        
        if (pickerView.tag == 0) {
                return NSAttributedString(string: String(porcent[row]), attributes: [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: CGFloat(1.0))])
            }
            else {
                return NSAttributedString(string: String(people[row]), attributes: [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: CGFloat(20.0))])
            }
        
    } */
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        
        let label: UILabel = (view as? UILabel) ?? {
                let label: UILabel = UILabel()
                //label.font = UIFont.systemFont(ofSize: 24)
            label.font = UIFont.boldSystemFont(ofSize: 26)
            label.textColor = UIColor.white
                label.textAlignment = .center
                return label
            }()
            label.text = self.pickerView(pickerView, titleForRow: row, forComponent: component)
            return label
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if (pickerView.tag == 0) {
            tip = porcent[row]
            calculation()
        }
        else {
            split = people[row]
            calculation()
        }
    }
    
}



