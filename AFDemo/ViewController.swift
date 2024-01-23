//
//  ViewController.swift
//  AFDemo
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var textView: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        textView.text = ""
        // Do any additional setup after loading the view.
    }
    
    func addLine(_ line: String) {
        textView.text.append(line + "\n\n")
        print(line)
    }

    var purchaseHandler: (() -> Void)? = nil
    @IBAction func purchaseButtonAction(_ sender: Any) {
        self.purchaseHandler?()
    }
    
    var addToCartHandler: (() -> Void)? = nil
    @IBAction func addToCartButtonAction(_ sender: Any) {
        self.addToCartHandler?()
    }
    
    var finalEventHandler: (() -> Void)? = nil
    @IBAction func finalEventButtonAction(_ sender: Any) {
        self.finalEventHandler?()
    }
    
}

