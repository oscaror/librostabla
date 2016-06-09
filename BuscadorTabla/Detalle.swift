//
//  Detalle.swift
//  BuscadorTabla
//
//  Created by Oscar Ortega on 01/06/16.
//  Copyright © 2016 Ozzcorp. All rights reserved.
//

import UIKit
import CoreData

class Detalle: UIViewController {

    @IBOutlet weak var isbnDetalle: UILabel!
    
    @IBOutlet weak var tituloDetalle: UILabel!
    @IBOutlet weak var autorDetalle: UILabel!
    @IBOutlet weak var portadaDetalle: UIImageView!
    
    var isbn : String = ""
    var contexto : NSManagedObjectContext? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Detalle"
        
        self.contexto = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
        
        let libroEntidad = NSEntityDescription.entityForName("Libro", inManagedObjectContext: self.contexto!)
        let peticion = libroEntidad?.managedObjectModel.fetchRequestFromTemplateWithName("petLibro", substitutionVariables: ["isbn": isbn])
        
        do{
            let libroEntidad2 = try self.contexto?.executeFetchRequest(peticion!)
            for libroResultadoEntidad in libroEntidad2!{
                let titulo = libroResultadoEntidad.valueForKey("nombre") as! String
                let autor = libroResultadoEntidad.valueForKey("autores") as! String
                let portada : UIImage? = UIImage(data: libroResultadoEntidad.valueForKey("portada") as! NSData)
                
                tituloDetalle.text = titulo
                isbnDetalle.text = isbn
                autorDetalle.text = autor
                portadaDetalle.image = portada
//                if  portada != nil {
//                    portadaDetalle.image = portada
//                }else {
//                    portadaDetalle.image = UIImage(named: "blank")
//                }
            }
        }
        catch {
            
        }
        
        
//        let cadenaIsbn = "ISBN: " + isbn
//        self.isbnDetalle.text = cadenaIsbn
//
//        let cadenaBusqueda = isbn
//        
//        var autores : [String] = []
//        var titulo2 = ""
//        var imgUrl = ""
//        let bloque2 : String = "api/books?jscmd=data&format=json&bibkeys=ISBN:"
//        
//        
//        let urls = "http://openlibrary.org/" //se crea el string con el url del servidor
//        let urls2 = urls+bloque2+cadenaBusqueda
//        let url = NSURL(string: urls2) //se convierte en una URL
//        //print (url)
//        
//        let datos : NSData? =  NSData (contentsOfURL: url!) //usando NSData, solicitamos una peticion al servidor, se espera aqui a que el servidor conteste y el resultado lo asociamos a esa variable
//        if datos == nil{
//            showSimpleAlert()
//            self.tituloDetalle.text = "Error de conexión - Intenta de nuevo"
//            tituloDetalle.text = ""
//            autorDetalle.text = ""
//            portadaDetalle.image = UIImage (named: "blank")
//            
//            
//        }else {
//            let texto = NSString(data:datos!, encoding:NSUTF8StringEncoding)
//            if texto == "{}"{
//                showSimpleAlert2()
//                tituloDetalle.text! = ""
//                autorDetalle.text! = ""
//                portadaDetalle.image = UIImage (named: "blank")
//                
//            }else {
//                do {
//                    let json = try NSJSONSerialization.JSONObjectWithData(datos!, options: NSJSONReadingOptions.MutableLeaves)
//                    let dico1 = json as! NSDictionary
//                    if let dico2 = dico1["ISBN:"+cadenaBusqueda] as? NSDictionary{
//                        titulo2 = dico2["title"] as! NSString as String
//                        
//                        
//                        if let dico3 = dico2["authors"] as? NSArray{
//                            for autor in dico3{
//                                //self.autor.text = dico3[0]["name"] as! NSString as String
//                                autores.append(autor["name"] as! NSString as String)
//                            }
//                            
//                        }
//                        if let dico4 = dico2["cover"] as? NSDictionary{
//                            imgUrl = dico4["medium"] as! NSString as String
//                            
//                        }
//                        
//                    }
//                    
//                }
//                    
//                catch _ {
//                    
//                }
//                
//                self.tituloDetalle.text = titulo2
//                tituloDetalle.numberOfLines = 0
//                tituloDetalle.lineBreakMode = NSLineBreakMode.ByWordWrapping
//                tituloDetalle.sizeToFit()
//
//                self.autorDetalle.text = autores.joinWithSeparator(",")
//                autorDetalle.numberOfLines = 0
//                autorDetalle.lineBreakMode = NSLineBreakMode.ByWordWrapping
//                autorDetalle.sizeToFit()
//
//                if imgUrl != ""{
//                    let url = NSURL(string: imgUrl)
//                    let data = NSData(contentsOfURL: url!)
//                    self.portadaDetalle.image = UIImage(data: data!)
//                }
//                else{
//                    self.portadaDetalle.image = UIImage(named: "blank")
//                }
//                
//                
//                
//            }
//        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
