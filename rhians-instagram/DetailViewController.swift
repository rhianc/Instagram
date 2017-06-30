//
//  DetailViewController.swift
//  rhians-instagram
//
//  Created by Rhian Chavez on 6/29/17.
//  Copyright © 2017 Rhian Chavez. All rights reserved.
//

import UIKit
import ParseUI
import Parse

class DetailViewController: UIViewController {
    
    @IBOutlet weak var profileView: PFImageView!
    @IBOutlet weak var nameAndTimeLabel: UILabel!
    @IBOutlet weak var mainPicView: PFImageView!
    @IBOutlet weak var captionLabel: UILabel!
    @IBOutlet weak var Date: UILabel!
    var data: PFObject!

    override func viewWillAppear(_ animated: Bool) {
        mainPicView.file = data["media"] as! PFFile
        mainPicView.loadInBackground()
        captionLabel.text = data["caption"] as! String
        let author = data["author"] as? PFUser
        if author != nil{
            nameAndTimeLabel.text = author?.username
        }
        profileView.layer.cornerRadius = 0.5*profileView.frame.width
        profileView.layer.masksToBounds = true
        if let pic = author?.object(forKey: "profilePic"){
            profileView.file = pic as! PFFile
            profileView.loadInBackground()
        }
        if let date = data.createdAt {
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .medium
            dateFormatter.timeStyle = .short
            let dateString = dateFormatter.string(from: date)
            //print(dateString) // Prints: Jun 28, 2017, 2:08 PM
            Date.text = dateString
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
