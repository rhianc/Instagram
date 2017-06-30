//
//  EditProfileViewController.swift
//  rhians-instagram
//
//  Created by Rhian Chavez on 6/29/17.
//  Copyright © 2017 Rhian Chavez. All rights reserved.
//

import UIKit
import Parse
import ParseUI

class EditProfileViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    @IBOutlet weak var profilePicView: PFImageView!
    @IBOutlet weak var bio: UITextField!
    let pc = UIImagePickerController()
    
    override func viewWillAppear(_ animated: Bool) {
        if let pic = PFUser.current()!.object(forKey: "profilePic"){
            profilePicView.file = pic as! PFFile
            profilePicView.loadInBackground()
        }
        if let serverBio = PFUser.current()!.object(forKey: "bio"){
            print(serverBio)
            bio.text = serverBio as! String
        }
        pc.delegate = self
        pc.allowsEditing = true
        pc.sourceType = UIImagePickerControllerSourceType.photoLibrary
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func tappedAway(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    @IBAction func done(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func tappedPic(_ sender: UITapGestureRecognizer) {
        self.present(pc, animated: true, completion: nil)
    }
    
    @IBAction func changedBio(_ sender: Any) {
        PFUser.current()!.setObject(bio.text!, forKey: "bio")
        PFUser.current()!.saveInBackground()
    }
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [String : Any]) {
        // Get the image captured by the UIImagePickerController
        let editedImage = info[UIImagePickerControllerEditedImage] as! UIImage
        // Do something with the images (based on your use case)
        let pic = Post.getPFFileFromImage(image: editedImage)!
        PFUser.current()!.setObject(pic, forKey: "profilePic")
        //print("got here")
        PFUser.current()!.saveInBackground()
        self.pc.dismiss(animated: true, completion: nil)
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        let viewController = storyboard.instantiateViewController(withIdentifier: "edit") as! EditProfileViewController
//        self.present(viewController, animated: true, completion: nil)
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
