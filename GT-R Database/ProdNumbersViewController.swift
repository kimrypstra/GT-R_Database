//
//  ProdNumbersViewController.swift
//  GT-R Database
//
//  Created by Kim Rypstra on 10/12/20.
//

import UIKit

class ProdNumbersViewController: UIViewController {

    var series: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let prodMan = ProdNumberManager(series: series)
        let numbers = prodMan.generateProdNumbers()
        
        // test
        let total = numbers["Total"]
        let mSpec = numbers["M-Spec"] as! [String : Int]
        let gv1 = mSpec["GV1"]
        
        print(gv1)
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
