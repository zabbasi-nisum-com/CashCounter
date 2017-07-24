//
//  ViewController.swift
//  CashCounter
//
//  Created by Zohaib Aziz on 18/07/2017.
//  Copyright © 2017 NISUM. All rights reserved.
//

import UIKit


class ViewController: UIViewController ,UITextFieldDelegate {
    
    @IBOutlet var btnBack: UIButton!
    @IBOutlet var btnNext: UIButton!
    @IBOutlet var cursorView: UIView!
    @IBOutlet var txtTotal: UITextField!
    var activeTextFeild: UITextField!
    var idx:Int = 0
    var preTxtValue:Int = 0
    @IBOutlet var nKeyboard: UIView!
    @IBOutlet var nKbBtnView: UIView!
    var numPad = NumPad()
    @IBOutlet var reconcileBtn: UIButton!
    
    @IBOutlet var lblExpDep: UILabel!
    @IBOutlet var lblVariance: UILabel!
    @IBOutlet var lblActDep: UILabel!
    var totalValue : Double! = 0
    var textFields : [UITextField] = [UITextField]()
    var textFieldViews : [UIView] = [UIView]()
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
        
        UIView.animate(withDuration: 1, delay: 0, options: .repeat, animations: {() -> Void in
            self.cursorView.alpha = 0 }, completion: {(animated: Bool) -> Void in
                self.cursorView.alpha = 1
        })
        
        
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
        
        self.getAllViewTextFields()
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
    
    func getAllViewTextFields(){
        textFields.removeAll()
        textFieldViews.removeAll()
        let mainView = self.view.subviews.filter { (view) -> Bool in
            return view.tag > 1000
        }
        for superView in mainView{
            print ("mainView Tag \(superView.tag)")
            for view in superView.subviews{
                print("View tag \(view.tag)")
                if view.tag > 0{
                textFieldViews.append(view)
                textFields.append( view.subviews.filter({ (view) -> Bool
                    in return view is UITextField
                }).first as! UITextField)
            
                }
            }
        }
            print (textFields.count)
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
                    labelView.textColor = UIColor.darkGray
                    
                }
            }
        }
        
    }
    
    func setDepositFromCalculation( ) {
        
        for item in textFields{
            let label = textFieldViews.filter({(view) -> Bool in return view.tag == item.tag}).first?.subviews.filter({ (view) -> Bool in
                return view is UILabel && view.tag == 50
            }).first as! UILabel
            getDenominationValues(val: label.text!, textField: item)
        }
        
    }
    
    func getDenominationValues(val:String,textField : UITextField) {
        
        let text: String = (textField.text?.isEmpty )! ? "0" : textField.text!
        
        switch val {
        case "1¢": totalValue = totalValue +  Double(text)! * 0.01
        case "5¢": totalValue = totalValue +  Double(text)! * 0.05
        case "10¢": totalValue = totalValue +  Double(text)! * 0.10
        case "25¢": totalValue = totalValue +  Double(text)! * 0.25
        case "50¢": totalValue = totalValue +  Double(text)! * 0.50
        case "100¢": totalValue =  totalValue + Double(text)! * 1.0
        case "PENNIES": totalValue =  totalValue + Double(text)! * 0.5
        case "NICKELS": totalValue =  totalValue + Double(text)! * 2
        case "DIMES": totalValue =  totalValue + Double(text)! * 5
        case "QUARTERS": totalValue =  totalValue + Double(text)! * 10
        case "$1": totalValue =  totalValue + Double(text)! * 1
        case "$2": totalValue =  totalValue + Double(text)! * 2
        case "$5": totalValue =  totalValue + Double(text)! * 5
        case "$10": totalValue =  totalValue + Double(text)! * 10
        case "$25": totalValue =  totalValue + Double(text)! * 25
        case "$50": totalValue =  totalValue + Double(text)! * 50
        case "$100": totalValue =  totalValue + Double(text)! * 100
            
        default: print("\(totalValue)")
        }
        
        print("\(totalValue)")
        
    }
    
 
    
    func showKeyboarb() {
        numPad.isHidden = false
        nKbBtnView.isHidden = false
        reconcileBtn.isHidden = true
        nKeyboard.backgroundColor = UIColor.lightGray
    }
    
    func hideKeyboarb() {
        numPad.isHidden = true
        nKbBtnView.isHidden = true
        nKeyboard.backgroundColor = UIColor.white
        reconcileBtn.isHidden = false
        if (activeTextFeild != nil) {
            activeTextFeild.endEditing(true)
        }
        cursorView.isHidden = true
        self.setViewUnHighLighted(tg: idx)
    }
    
    // MARK: -TextField Delegate
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        //Here we add Custom Cursor in TextFeild
        cursorView.isHidden = false
        textField.addSubview(cursorView)
        
        //Here we Check Feild for Un-Highlight
        if (activeTextFeild.text == "") {
            self.setViewUnHighLighted(tg: activeTextFeild.tag)
            
        }
        

        
        //Here we get Current TextFeild
        activeTextFeild = textField
        idx = activeTextFeild.tag
        self.setViewHighLight(tg: idx)
        if (activeTextFeild.text != "") {
            preTxtValue = Int(activeTextFeild.text!)!

        }else{
            preTxtValue = 0
        }
        self.showKeyboarb()
        return false
    }
    

}



extension ViewController: NumPadDelegate {
    
    func numPad(_ numPad: NumPad, itemTapped item: Item, atPosition position: Position) {
        switch (position.row, position.column) {
        case (3, 0):
            
            activeTextFeild.text = nil
            if (idx == 0 ) {
                lblActDep.text = "-"
                lblVariance.text = "-$0.40"
            }
            
        default:
            
            let item = numPad.item(forPosition: position)!
            let string = activeTextFeild.text!.sanitized() + item.title!
            
            if Int(string) == 0 {
                activeTextFeild.text = nil

            } else {
                if (idx == 0 ) {
                    
                    // Total View Activated
                    activeTextFeild.text = string.currency()
                    let val = string.currency()?.replacingOccurrences(of: "$", with: "")
                    lblActDep.text = activeTextFeild.text
                    lblVariance.text = String(Double(val!)! - 0.40)

                    
                }else{
                    
                    // Total View Denomination
                    activeTextFeild.text = string
                    
                    totalValue = 0
                    getAllViewTextFields()
                    setDepositFromCalculation()
                    lblActDep.text = String(totalValue)
                    lblVariance.text = String(totalValue - 0.40)

                }
                
            }
        }
        
        
        
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
