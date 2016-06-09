//
//  VistaBusqueda.swift
//  BuscadorTabla
//
//  Created by Oscar Ortega on 31/05/16.
//  Copyright © 2016 Ozzcorp. All rights reserved.
//

import UIKit
import CoreData

class VistaBusqueda: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var buscador: UITextField!
    @IBOutlet weak var titulo: UILabel!
    @IBOutlet weak var autor: UILabel!
    @IBOutlet weak var portada: UIImageView!
    
    var cadenaBusqueda = ""
    var contexto : NSManagedObjectContext? = nil
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.buscador.delegate = self
        habilitarBoton()
        
        self.contexto = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func habilitarBoton (){
        if (titulo.text == "" && autor.text == ""){
            self.navigationItem.rightBarButtonItem?.enabled = false
        }
        else {
            self.navigationItem.rightBarButtonItem?.enabled = true
        }
    }
 
    

    @IBAction func buscarLibro(sender: AnyObject) {
        buscar()
        textFieldShouldReturn(buscador)
        habilitarBoton()

    }
    
    
    
    //ocultar teclado presionando la tecla enter
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        buscador.resignFirstResponder()
        buscar()
        habilitarBoton()
        
        
        return true
    }
    
    //ocultar teclado tocando la pantalla
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?){
        buscador.resignFirstResponder()
        self.view.endEditing(true)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "exit" {
            let mtv = segue.destinationViewController as! Maestro
            mtv.titulo = self.titulo.text!
            mtv.autores = self.autor.text!
            mtv.portada = self.portada.image
            mtv.isbn = self.cadenaBusqueda
                //mtv.titulo.append([self.titulo.text!, self.buscador.text!])
        }
    }
   
    func buscar () {
        //el metodo es sincrono
        cadenaBusqueda = buscador.text!
        let libroEntidad = NSEntityDescription.entityForName("Libro", inManagedObjectContext: self.contexto!)
        let peticion = libroEntidad?.managedObjectModel.fetchRequestFromTemplateWithName("petLibro", substitutionVariables: ["isbn": buscador.text!])
        do{
            let libroEntidad2 = try self.contexto?.executeFetchRequest(peticion!)
                if (libroEntidad2?.count > 0) {
                    buscador.text = nil
                    showAlertDup()
                    return
                }
        }
        catch{
            
        }
        var autores : [String] = []
        var titulo2 = ""
        var imgUrl = ""
        let bloque2 : String = "api/books?jscmd=data&format=json&bibkeys=ISBN:"
        
        
        let urls = "http://openlibrary.org/" //se crea el string con el url del servidor
        let urls2 = urls+bloque2+cadenaBusqueda
        let url = NSURL(string: urls2) //se convierte en una URL
        //print (url)
        
        let datos : NSData? =  NSData (contentsOfURL: url!) //usando NSData, solicitamos una peticion al servidor, se espera aqui a que el servidor conteste y el resultado lo asociamos a esa variable
        if datos == nil{
            showSimpleAlert()
            self.titulo.text = "Error de conexión - Intenta de nuevo"
            buscador.text = ""
            titulo.text = ""
            autor.text = ""
            portada.image = UIImage (named: "blank")
            
            
        }else {
            let texto = NSString(data:datos!, encoding:NSUTF8StringEncoding)
            if texto == "{}"{
                showSimpleAlert2()
                buscador.text! = ""
                titulo.text! = ""
                autor.text! = ""
                portada.image = UIImage (named: "blank")
                
            }else {
                do {
                    let json = try NSJSONSerialization.JSONObjectWithData(datos!, options: NSJSONReadingOptions.MutableLeaves)
                    let dico1 = json as! NSDictionary
                    if let dico2 = dico1["ISBN:"+cadenaBusqueda] as? NSDictionary{
                        titulo2 = dico2["title"] as! NSString as String
                        
                    
                        if let dico3 = dico2["authors"] as? NSArray{
                            for autor in dico3{
                                //self.autor.text = dico3[0]["name"] as! NSString as String
                                autores.append(autor["name"] as! NSString as String)
                            }
                            
                        }
                        if let dico4 = dico2["cover"] as? NSDictionary{
                            imgUrl = dico4["medium"] as! NSString as String
                            
                        }
                   
                    }
                    
                }
                    
                catch _ {
                    
                }
                
                self.titulo.text = titulo2
                titulo.numberOfLines = 0
                titulo.lineBreakMode = NSLineBreakMode.ByWordWrapping
                titulo.sizeToFit()
                
                self.autor.text = autores.joinWithSeparator(",")
                autor.numberOfLines = 0
                autor.lineBreakMode = NSLineBreakMode.ByWordWrapping
                autor.sizeToFit()

                
                if imgUrl != ""{
                    let url = NSURL(string: imgUrl)
                    let data = NSData(contentsOfURL: url!)
                    self.portada.image = UIImage(data: data!)
                }
                else{
                    self.portada.image = UIImage(named: "not found")
                }
                
                    
                
            }
        }
    }
    
    
    func showSimpleAlert() {
        let title = NSLocalizedString("Error", comment: "")
        let message = NSLocalizedString("No hay conexión a internet. Reintente más tarde", comment: "")
        let cancelButtonTitle = NSLocalizedString("OK", comment: "")
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        
        // Create the action.
        let cancelAction = UIAlertAction(title: cancelButtonTitle, style: .Cancel) { action in
            NSLog("The simple alert's cancel action occured.")
        }
        
        // Add the action.
        alertController.addAction(cancelAction)
        
        presentViewController(alertController, animated: true, completion: nil)
    }
    
    func showSimpleAlert2() {
        let title = NSLocalizedString("Error", comment: "")
        let message = NSLocalizedString("Libro no encontrado - Compruebe ISBN", comment: "")
        let cancelButtonTitle = NSLocalizedString("OK", comment: "")
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        
        // Create the action.
        let cancelAction = UIAlertAction(title: cancelButtonTitle, style: .Cancel) { action in
            NSLog("The simple alert's cancel action occured.")
        }
        
        // Add the action.
        alertController.addAction(cancelAction)
        
        presentViewController(alertController, animated: true, completion: nil)
    }
    
    func showAlertDup() {
        let title = NSLocalizedString("Atención", comment: "")
        let message = NSLocalizedString("Este libro ya esta registrado - Intente una nueva busqueda", comment: "")
        let cancelButtonTitle = NSLocalizedString("OK", comment: "")
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        
        // Create the action.
        let cancelAction = UIAlertAction(title: cancelButtonTitle, style: .Cancel) { action in
            NSLog("The simple alert's cancel action occured.")
        }
        
        // Add the action.
        alertController.addAction(cancelAction)
        
        presentViewController(alertController, animated: true, completion: nil)
    }

    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        if (string == " ") {
            return false
        }
        return true
    }

    
    
    


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
