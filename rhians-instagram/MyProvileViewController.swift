//
//  MyProvileViewController.swift
//  rhians-instagram
//
//  Created by Rhian Chavez on 6/28/17.
//  Copyright © 2017 Rhian Chavez. All rights reserved.
//

import UIKit
import Parse
import ParseUI

class MyProvileViewController: UIViewController {

   
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func logout(_ sender: UIBarButtonItem) {
        PFUser.logOutInBackground { (error: Error?) in
            if error == nil{
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let viewController = storyboard.instantiateViewController(withIdentifier: "main") as! LoginViewController
                self.present(viewController, animated: true, completion: nil)
            }
            else{
                print(error?.localizedDescription)
            }
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
