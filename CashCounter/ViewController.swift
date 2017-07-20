//
//  ViewController.swift
//  CashCounter
//
//  Created by Zohaib Aziz on 18/07/2017.
//  Copyright © 2017 NISUM. All rights reserved.
//

import UIKit


class ViewController: UIViewController ,UITextFieldDelegate {
    
    @IBOutlet var txtTotal: UITextField!
    var activeTextFeild: UITextField!
    var idx:Int = 0
    @IBOutlet var nKeyboard: UIView!
    @IBOutlet var nKbBtnView: UIView!
    var numPad = NumPad()
    @IBOutlet var reconcileBtn: UIButton!
    
    @IBOutlet var lblExpDep: UILabel!
    @IBOutlet var lblVariance: UILabel!
    @IBOutlet var lblActDep: UILabel!
    override func viewDidLoad() {
        
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.title = "Count Cash Deposite - #302"
        self.navigationItem.setHidesBackButton(true, animated:false);
        //Here we create NumPad for future use
        numPad = DefaultNumPad(frame: nKeyboard.frame)
        numPad.delegate = self
        self.view.addSubview(numPad)
        
        //here we hide panel
        self.hideKeyboarb()
        
        activeTextFeild = txtTotal
        
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: -IBActions
    
    @IBAction func tapOnTotal(_ sender: Any) {
        
          self.navigationController?.popViewController(animated: false)
    }
    @IBAction func taponDenomin(_ sender: Any) {
        
        //Here we Create Object
        let denominView = self.storyboard?.instantiateViewController(withIdentifier: "ViewController2") as? ViewController
        
        //Here we Push searchView
        self.navigationController?.pushViewController(denominView!, animated: false)
    }
    @IBAction func kbBack(_ sender: Any) {
        
        self.moveBack()
        
    }
    @IBAction func kbNext(_ sender: Any) {
        
        self.moveToNext()
    }
    @IBAction func openPanel(_ sender: Any) {
        
        self.showKeyboarb()
    }


    @IBAction func closePanel(_ sender: Any) {
        
        self.hideKeyboarb()
    }

    @IBAction func doneTap(_ sender: Any) {
        
        self.hideKeyboarb()
    }
 // MARK: -Custom Methods
    
    func moveToNext(){
        
        if (idx < 17) {
            idx += 1
            let view:UIView = self.view.viewWithTag(idx)!
            for subview in view.subviews {
                // Manipulate the view
                if (subview is UITextField){
                    let txt:UITextField = (subview as? UITextField)!
                    txt.becomeFirstResponder()
                    return
                }
            }
        }
    }
    
    func moveBack(){
        
        if (idx > 1) {
            idx -= 1
            let view:UIView = self.view.viewWithTag(idx)!
            for subview in view.subviews {
                // Manipulate the view
                if (subview is UITextField){
                    let txt:UITextField = (subview as? UITextField)!
                    txt.becomeFirstResponder()
                    return
                }
            }
        }
    }
    
    func setViewHighLight(tg : Int){
        
        let view:UIView = self.view.viewWithTag(tg)!
        for subview in view.subviews {
            // Manipulate the view
            if (subview is UILabel){
                let labelView:UILabel = (subview as? UILabel)!
                if (labelView.tag == 100) {
                    labelView.backgroundColor = UIColor.init(red: 90.0/255.0, green: 155.0/255.0, blue: 255/255.0, alpha: 1)
                }
                if (labelView.tag == 50) {
                    labelView.textColor = UIColor.init(red: 90.0/255.0, green: 155.0/255.0, blue: 255/255.0, alpha: 1)
                    
                }
            }
        }
        
    }
    
    func setViewUnHighLighted(tg : Int){
        
        let view:UIView = self.view.viewWithTag(tg)!
        for subview in view.subviews {
            // Manipulate the view
            if (subview is UILabel){
                let labelView:UILabel = (subview as? UILabel)!
                if (labelView.tag == 100) {
                    labelView.backgroundColor = UIColor.lightGray                }
                if (labelView.tag == 50) {
                    labelView.textColor = UIColor.lightGray
                    
                }
            }
        }
        
    }
    

    
    func showKeyboarb() {
        numPad.isHidden = false
        nKbBtnView.isHidden = false
        reconcileBtn.isHidden = true
        nKeyboard.backgroundColor = UIColor.lightGray
        if (activeTextFeild != nil) {
            activeTextFeild.becomeFirstResponder()
        }
    }
    
    func hideKeyboarb() {
        numPad.isHidden = true
        nKbBtnView.isHidden = true
        nKeyboard.backgroundColor = UIColor.white
        reconcileBtn.isHidden = false
        if (activeTextFeild != nil) {
            activeTextFeild.endEditing(true)

        }
    }
    
    // MARK: -TextField Delegate
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        if textField == activeTextFeild {
            
            textField.resignFirstResponder()
            return false
        }
        
        if (activeTextFeild.text == "") {
            self.setViewUnHighLighted(tg: activeTextFeild.tag)
        }
        activeTextFeild = textField
        idx = activeTextFeild.tag
        self.setViewHighLight(tg: idx)
        
        return true
    }
    

    
}



extension ViewController: NumPadDelegate {
    
    func numPad(_ numPad: NumPad, itemTapped item: Item, atPosition position: Position) {
        switch (position.row, position.column) {
        case (3, 0):
            activeTextFeild.text = nil
        default:
            let item = numPad.item(forPosition: position)!
            let string = activeTextFeild.text!.sanitized() + item.title!
            if Int(string) == 0 {
                activeTextFeild.text = nil
            } else {
                activeTextFeild.text = string.currency()
                //activeTextFeild.text = formatCurrency(value: Double(string)!)

            }
        }
    }
    
    func formatCurrency(value: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.maximumFractionDigits = 2
        formatter.locale = Locale(identifier: Locale.current.identifier)
        let result = formatter.string(from: value as NSNumber)
        return result!
    }
    

}

extension String {
    
    func currency() -> String? {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        let digits = NSDecimalNumber(string: sanitized())
        let place = NSDecimalNumber(value: powf(10, 2))
        return formatter.string(from: digits.dividing(by: place))
    }
    


    
    func sanitized() -> String {
        return String(self.characters.filter { "01234567890".characters.contains($0) })
    }
    
}


//extension UIViewController
//{
//    func hideKeyboard2()
//    {
//        let tap: UITapGestureRecognizer = UITapGestureRecognizer(
//            target: self,
//            action: #selector(UIViewController.dismissKeyboard))
//        
//        view.addGestureRecognizer(tap)
//    }
//    
//    func dismissKeyboard()
//    {
//        view.endEditing(true)
//    }
//}
