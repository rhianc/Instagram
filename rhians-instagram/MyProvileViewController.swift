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
        collectionView.delegate = self
        collectionView.dataSource = self
        let profileView = UIImageView(frame: CGRect(x: screenWidth/10, y: screenHeight/7, width: screenWidth/7, height: screenWidth/7))
        profileView.layer.cornerRadius = screenWidth/14
//        profileView.layer.borderColor = UIColor(white: 1, alpha: 0.8).cgColor
        profileView.layer.borderColor = UIColor.blue.cgColor
        profileView.layer.borderWidth = 3
        view.addSubview(profileView)
        name.text = PFUser.current()?.username
        self.automaticallyAdjustsScrollViewInsets = false
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        let cellsPerLine: CGFloat = 3
        let rowsPerView: CGFloat = 1.5
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.sectionInset.top = 0
        let width = collectionView.frame.size.width/cellsPerLine
        print(width)
        let height = collectionView.frame.size.height/rowsPerView
        print(height)
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
