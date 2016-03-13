//
//  ViewController.swift
//  BusquedaOpenLibrary
//
//  Created by Jesus Rodriguez Barrera on 13/03/16.
//  Copyright © 2016 Aplicapp. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var isbnTexto: UITextField!
    @IBOutlet weak var salidaTexto: UITextView!
    
    func sincrono(isbn:String){
        let urls = "https://openlibrary.org/api/books?jscmd=data&format=json&bibkeys=ISBN:\(isbn)"
        let url = NSURL(string: urls)
        let datos:NSData? = NSData(contentsOfURL: url!)
        if datos == nil{
            let alert = UIAlertController(title: "Error", message: "La conexión a internet parece estar desactivada.", preferredStyle: .Alert)
            let cancelAction = UIAlertAction(title: "Ok", style: .Cancel, handler: nil)
            alert.addAction(cancelAction)
            self.presentViewController(alert, animated: true, completion: nil)
        }else{
                let texto = NSString(data: datos!, encoding: NSUTF8StringEncoding)
            if texto == "{}"{
                salidaTexto.text = "Libro no encontrado."
            }else{
                salidaTexto.text = texto! as String
            }
        }
    }
    @IBAction func backGroundTap(sender: AnyObject) {
        isbnTexto.resignFirstResponder() //Desaparecer el teclado
    }
    
    @IBAction func textFieldDoneEditing(sender: UITextField) {
        sender.resignFirstResponder() //Desaparecer el teclado
        sincrono(isbnTexto.text!)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        isbnTexto.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

