//
//  LoggedInViewController.swift
//  rhians-instagram
//
//  Created by Rhian Chavez on 6/27/17.
//  Copyright © 2017 Rhian Chavez. All rights reserved.
//

import UIKit
import ParseUI
import Parse

class LoggedInViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate,UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    let vc = UIImagePickerController()
    let pc = UIImagePickerController()
    var image: UIImage?
    var posts: [PFObject] = []
    let screenWidth  = UIScreen.main.fixedCoordinateSpace.bounds.width
    let screenHeight = UIScreen.main.fixedCoordinateSpace.bounds.height

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 150
        tableView.sectionFooterHeight = 0
        tableView.sectionHeaderHeight = 0
        
        vc.delegate = self
        vc.allowsEditing = true
        pc.delegate = self
        pc.allowsEditing = true
        pc.sourceType = UIImagePickerControllerSourceType.photoLibrary
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            print("Camera is available 📸")
            vc.sourceType = .camera
        } else {
            print("Camera 🚫 available so we will use photo library instead")
            vc.sourceType = .photoLibrary
        }
        fetchData()
        Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.onTimer), userInfo: nil, repeats: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func fetchData(){
        let query = PFQuery(className: "Post")
        query.order(byDescending: "createdAt")
        query.includeKey("author")
        query.includeKey("caption")
        query.limit = 20
        // fetch data asynchronously
        query.findObjectsInBackground { (posts: [PFObject]?, error: Error?) in
            if let error = error {
                print(error.localizedDescription)
                // pop up an alert describing error
            }
            else{
                self.posts = posts!
                // reload tableViewData
                self.tableView.reloadData()
            }
        }
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "instagramCell", for: indexPath) as! UIInstagramTableViewCell
        let post = posts[indexPath.section]
        cell.picture.file = (post["media"] as! PFFile)
        cell.picture.loadInBackground()
        cell.caption.text = (post["caption"] as! String)
        cell.caption.font = UIFont(name:"HelveticaNeue", size: 14.0)
//        cell.specifc = (post["media"] as! PFFile)
//        cell.label = (post["caption"] as! String)
//        print(cell.label)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return screenHeight/15
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.1
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        // create the view
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight/10))
        headerView.backgroundColor = UIColor(white: 1, alpha: 1)
        // Add a UILabel for the username here
        let user = UILabel(frame: CGRect(x: 1, y: 10, width: screenWidth*8/10, height: 30))
        user.font = UIFont(name:"HelveticaNeue-Bold", size: 18.0)
        let specific = posts[section]
        let author = specific["author"] as? PFUser
        if author != nil{
            user.text = author?.username
            headerView.addSubview(user)
        }
        return headerView
    }
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [String : Any]) {
        // Get the image captured by the UIImagePickerController
//        let originalImage =   info[UIImagePickerControllerOriginalImage] as! UIImage
        let editedImage = info[UIImagePickerControllerEditedImage] as! UIImage
        
        // Do something with the images (based on your use case)
        self.image = editedImage
        //print("got here")
        dismiss(animated: false, completion: nil)
        performSegue(withIdentifier: "postedPop", sender: nil)
    }
    
    @IBAction func openCamera(_ sender: UIBarButtonItem) {
        self.present(vc, animated: true, completion: nil)
    }
    
    
    @IBAction func uploadPictures(_ sender: UIBarButtonItem) {
        self.present(pc, animated: true, completion: nil)
    }
    
    func onTimer() {
        // Add code to be run periodically
        fetchData()
    }
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination as! PostViewController
        destination.picture = image
    }

}
