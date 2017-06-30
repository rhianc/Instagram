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
    
    
    @IBOutlet weak var profileView: PFImageView!
    @IBOutlet weak var bio: UILabel!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    var myPosts: [PFObject] = []
    
    let screenWidth  = UIScreen.main.fixedCoordinateSpace.bounds.width
    let screenHeight = UIScreen.main.fixedCoordinateSpace.bounds.height

    override func viewWillAppear(_ animated: Bool) {
        
        if let serverBio = PFUser.current()!.object(forKey: "bio"){
            print(serverBio)
            bio.text = serverBio as! String
        }
        collectionView.delegate = self
        collectionView.dataSource = self
        profileView.layer.cornerRadius = 0.5*profileView.frame.width
        profileView.layer.masksToBounds = true
        if let pic = PFUser.current()!.object(forKey: "profilePic"){
            profileView.file = pic as! PFFile
            profileView.loadInBackground()
        }
        
        name.text = PFUser.current()?.username
        self.automaticallyAdjustsScrollViewInsets = false
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        let cellsPerLine: CGFloat = 3
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.sectionInset.top = 0
        layout.sectionInset.bottom = 0
        let width = collectionView.frame.size.width/cellsPerLine
        //print(width)
        let height = width
        //print(height)
        layout.itemSize = CGSize(width: width, height: height)
        fetchData()
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
                //print(allPosts)
                // reload tableViewData
                var mine: [PFObject] = []
                let currentUsername = PFUser.current()?.username as String!
                
                for post in allPosts{
                    let Author = post["author"] as! PFUser
                    let Username = Author.username as! String
                    if Username == currentUsername{
                        mine.append(post)
                    }
                }
                //print(mine)
                self.myPosts = mine
                self.collectionView.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.reloadData()
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
        let post = myPosts[indexPath.row]
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

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "personalToDetail"{
            let destination = segue.destination as! DetailViewController
            let cell = sender as! ProfileCollectionViewCell
            let index = collectionView.indexPath(for: cell)!
            destination.data = myPosts[index.row]
        }
    }

}
