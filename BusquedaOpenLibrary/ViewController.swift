//
//  ViewController.swift
//  BusquedaOpenLibrary
//
//  Created by Jesus Rodriguez Barrera on 13/03/16.
//  Copyright © 2016 Aplicapp. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var tituloEtiqueta: UILabel!
    @IBOutlet weak var autorEtiqueta: UILabel!
    @IBOutlet weak var portadaEtiqueta: UILabel!
    @IBOutlet weak var portadaView: UIImageView!
    
    @IBOutlet weak var isbnTexto: UITextField!
    @IBOutlet weak var tituloLabel: UILabel!
    @IBOutlet weak var autoresLabel: UITextView!
    
    func sincrono(isbn:String){
        let urls = "https://openlibrary.org/api/books?jscmd=data&format=json&bibkeys=ISBN:\(isbn)"
        let url = NSURL(string: urls)
        let datos:NSData? = NSData(contentsOfURL: url!)
        if datos == nil{
            tituloLabel.hidden = true
            tituloEtiqueta.hidden = true
            autoresLabel.hidden = true
            autorEtiqueta.hidden = true
            portadaEtiqueta.hidden = true
            portadaView.hidden = true
            
            let alert = UIAlertController(title: "Error", message: "La conexión a internet parece estar desactivada.", preferredStyle: .Alert)
            let cancelAction = UIAlertAction(title: "Ok", style: .Cancel, handler: nil)
            alert.addAction(cancelAction)
            self.presentViewController(alert, animated: true, completion: nil)
        }else{
                let texto = NSString(data: datos!, encoding: NSUTF8StringEncoding)
            if texto == "{}"{
                tituloLabel.hidden = true
                tituloEtiqueta.hidden = true
                autoresLabel.hidden = true
                autorEtiqueta.hidden = true
                portadaEtiqueta.hidden = true
                portadaView.hidden = true
                
                let alert = UIAlertController(title: "Error", message: "Libro no encontrado.", preferredStyle: .Alert)
                let cancelAction = UIAlertAction(title: "Ok", style: .Cancel, handler: nil)
                alert.addAction(cancelAction)
                self.presentViewController(alert, animated: true, completion: nil)
            }else{
                do{
                    tituloLabel.hidden = false
                    tituloEtiqueta.hidden = false
                    
                    
                    let json = try NSJSONSerialization.JSONObjectWithData(datos!, options: NSJSONReadingOptions.MutableLeaves)
                    
                    let isbnJson = json as! NSDictionary
                    let isbnQuery = isbnJson["ISBN:\(isbn)"] as! NSDictionary
                    let autores = isbnQuery["authors"] as! [NSDictionary]
                    let portada = isbnQuery["cover"] as! NSDictionary?
                    
                    if portada == nil{
                        portadaEtiqueta.hidden = true
                        portadaView.hidden = true
                    }else{
                        let portadaMedium = portada!["medium"] as! NSString as String
                        
                        if let url  = NSURL(string: portadaMedium),
                            data = NSData(contentsOfURL: url)
                        {
                            portadaEtiqueta.hidden = false
                            portadaView.hidden = false
                            portadaView.image = UIImage(data: data)
                        }
                    }
                    
                    
                    self.tituloLabel.text = isbnQuery["title"] as! NSString as String
                    var autoresString = ""
                    for autor in autores{
                        if autoresString == ""{
                            autoresString += autor["name"] as! NSString as String
                        }else{
                            autoresString += ", "
                            autoresString += autor["name"] as! NSString as String
                        }
                    }
                    if autoresString == ""{
                        autoresLabel.hidden = true
                        autorEtiqueta.hidden = true
                    }else{
                        autoresLabel.hidden = false
                        autorEtiqueta.hidden = false
                        self.autoresLabel.text = autoresString
                    }
                    
                }catch _{
                    
                }
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
        
        tituloLabel.hidden = true
        tituloEtiqueta.hidden = true
        autoresLabel.hidden = true
        autorEtiqueta.hidden = true
        portadaEtiqueta.hidden = true
        portadaView.hidden = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

