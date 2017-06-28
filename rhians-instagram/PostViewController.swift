//
//  PostViewController.swift
//  rhians-instagram
//
//  Created by Rhian Chavez on 6/27/17.
//  Copyright © 2017 Rhian Chavez. All rights reserved.
//

import UIKit
import Parse
import ParseUI

class PostViewController: UIViewController {
    
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var descriptionField: UITextField!
    var picture: UIImage?
    
    override func viewWillAppear(_ animated: Bool) {
        image.image = picture
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func postImage(_ sender: UIButton) {
        Post.postUserImage(image: picture, withCaption: descriptionField.text) { (bool: Bool, error: Error?) in
            if bool{
                print("AAAAA")
                self.dismiss(animated: true, completion: nil)
            }
            else{
                print(error?.localizedDescription ?? "")
            }
        }
    }

    @IBAction func endEditing(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
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
