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

class MyProvileViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    var myPosts: [PFObject] = []
    
    let screenWidth  = UIScreen.main.fixedCoordinateSpace.bounds.width
    let screenHeight = UIScreen.main.fixedCoordinateSpace.bounds.height

    override func viewWillAppear(_ animated: Bool) {
        let profileView = UIImageView(frame: CGRect(x: screenWidth/10, y: screenHeight/7, width: screenWidth/7, height: screenWidth/7))
        profileView.layer.cornerRadius = screenWidth/14
//        profileView.layer.borderColor = UIColor(white: 1, alpha: 0.8).cgColor
        profileView.layer.borderColor = UIColor.blue.cgColor
        profileView.layer.borderWidth = 3
        view.addSubview(profileView)
        name.text = PFUser.current()?.username
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
                let allPosts = posts!
                // reload tableViewData
                var mine: [PFObject] = []
                for post in allPosts{
                    if post["author"] as! PFUser == PFUser.current(){
                        mine.append(post)
                    }
                }
                self.myPosts = mine
                self.collectionView.reloadData()
            }
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
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return myPosts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionCell", for: indexPath) as! ProfileCollectionViewCell
        let post = myPosts[indexPath.section]
        cell.collectionImage.file = (post["media"] as! PFFile)
        cell.collectionImage.loadInBackground()
        return cell
    }
    
    @IBAction func logout(_ sender: UIBarButtonItem) {
        PFUser.logOutInBackground { (error: Error?) in
            if error == nil{
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let viewController = storyboard.instantiateViewController(withIdentifier: "main") as! LoginViewController
                self.present(viewController, animated: true, completion: nil)
            }
            else{
                print(error?.localizedDescription ?? "")
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
