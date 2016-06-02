//
//  Maestro.swift
//  BuscadorTabla
//
//  Created by Oscar Ortega on 31/05/16.
//  Copyright © 2016 Ozzcorp. All rights reserved.
//

import UIKit


class Maestro: UITableViewController {
    
    var titulo : Array<Array<String>> = Array<Array<String>>()
    

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Open Library"
        
        let addButton : UIBarButtonItem = UIBarButtonItem(title: "+", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(Maestro.addBook))
        
        self.navigationItem.rightBarButtonItem = addButton
        
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return titulo.count
    }
    func addBook (){
        performSegueWithIdentifier("agregar", sender: self)
    }
    
    
    @IBAction func saveBook (segue: UIStoryboardSegue){
        //ISBN.append(contenedor)
        //contenedor.append()
        if segue.identifier == "exit"{
            let indexPath = NSIndexPath(forRow: titulo.count-1, inSection: 0)
            tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
            tableView.reloadData()
                //print (titulo, " hola")
        }
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)

        // Configure the cell...
        cell.textLabel?.text = self.titulo[indexPath.row][0]

        return cell
    }

    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if (section == 0){
            return "Historial de Busqueda"
        }
        return "Default"
    }

 
//    @IBAction func unwindToTableView(segue: UIStoryboardSegue) {
//        //if let VistaBusqueda = segue.sourceViewController as? VistaBusqueda{
//        ISBN.append(contenedor)
//        let indexPath = NSIndexPath(forRow: ISBN.count-1, inSection: 0)
//        tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
//        tableView.reloadData()
//        print (ISBN, " hola")
//        //}
//        
//        //if let sourceViewController = sender.sourceViewController as? VistaBusqueda,
//        //    isbnTemp = sourceViewController.buscador{
//        // ^ note 2nd clause of if let statement above
//        //if let selectedIndexPath = tableView.indexPathForSelectedRow {
//        // Update cell text
//        //ISBN.append(isbnTemp.text!)
//        //tableView.reloadRowsAtIndexPaths([selectedIndexPath], withRowAnimation: .None)
//        
//        //tableView.reloadData()
//        
//        //}
//        //}
//    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "detalle"{
            let dt = segue.destinationViewController as! Detalle
            let ip = self.tableView.indexPathForSelectedRow
            dt.isbn = self.titulo[ip!.row][1]
            //dt.tituloDetalle?.text = self.titulo[ip!.row][0]
        }
        else {
            let backItem = UIBarButtonItem()
            backItem.title = "Cancel"
            navigationItem.backBarButtonItem = backItem
        }
        
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    


}
