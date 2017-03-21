//
//  ViewController.swift
//  Trial1
//
//  Created by Jaya   on 08/03/17.
//  Copyright © 2017 AppCoda. All rights reserved.
//

import UIKit

class PodCastViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    
    
    @IBOutlet weak var tableView: UITableView!
    
    let activityIndicator : UIActivityIndicatorView = UIActivityIndicatorView()

    var podCastArray : [PodCast] = []
    var cacheCell : [Bool] = []
    
    var index = 0
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        createActivityIndicator(appendItems: "LinkinPark")
        loadUrl(appendItems: "LinkinPark")
        createSearchBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("View will appar")
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        
    }
    func loadUrl(appendItems:String){
        
        self.podCastArray.removeAll()
        
        let baseUrlStringWithSearchText = baseUrlString + appendItems
        //Activity indicator start
        LoadDataFromURl.instance.getData(urlString: baseUrlStringWithSearchText) { (data : Data) -> Void  in
            
            ParserHelper.instance.parsePodCastItems(data: data) { (json : [PodCast]) -> Void in
                
                DispatchQueue.main.async {
                    // accessing UIElements in main thread
                    
                    self.activityIndicator.stopAnimating()
                    
                    self.podCastArray = json
                    self.tableView.reloadData()
                    self.cacheCell = [Bool](repeating : false, count : self.podCastArray.count)
                
                }
            }
        }
    }

    // MARK: Search Bar
    func createSearchBar() {
        
        //let searchBar = UISearchBar()
        let searchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: (UIScreen.main.bounds.width), height: 70))
        searchBar.showsCancelButton = false
        searchBar.placeholder = "Enter your album here!"
        searchBar.delegate = self

       // self.navigationItem.titleView = searchBar
        self.tableView.tableHeaderView = searchBar
    }
    
    // search bar delegate
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchText.isEmpty {
            createActivityIndicator(appendItems: "Hello")
            
        } else {
            createActivityIndicator(appendItems: searchText)
            print("searchText \(searchText)")
        }
    }
    
    // MARK: Activity Indicator
    
    func createActivityIndicator(appendItems : String) {
        
        activityIndicator.center = self.tableView.center
        activityIndicator.isHidden = false
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        self.view.addSubview(activityIndicator)
        
        activityIndicator.startAnimating()
        loadUrl(appendItems: appendItems)
    
        
    }

    // MARK: Table View Rows
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return podCastArray.count
    }
    
    
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CustomTableViewCell
        
        let podCastObject = podCastArray[indexPath.row]
        
        cell.artistLabel.text = podCastObject.artistName
        cell.trackLabel.text = podCastObject.trackName
        cell.collectionLabel.text = podCastObject.collectionName
 
        if cacheCell[(indexPath.row)] == false {
            DispatchQueue.global(qos: .userInitiated).async {
                do{
                   let url = Foundation.URL(string: podCastObject.artworkUrl100!)
                   let testImage =  try Data(contentsOf: url!)
                   let img = UIImage(data: testImage)
                    //I am writing in documents directory or file system
                    DispatchQueue.main.async {
                    //I fetch from file system
                        self.cacheCell[(indexPath.row)] = true
                        cell.artWorkImgView.image = img
                    }
                }catch{
                    
                }
            }
        }
        return cell
    }
    
    
    // MARK: Select Row
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailStoryBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let instance = detailStoryBoard.instantiateViewController(withIdentifier: "audioView") as! AudioViewController
        instance.indx = indexPath.row
        instance.resultPodCastArray = podCastArray
        self.navigationController?.pushViewController(instance, animated: true)
    }
    
    
}

