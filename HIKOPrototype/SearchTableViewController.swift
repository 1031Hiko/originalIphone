
import UIKit

class SearchTableViewController: UITableViewController,UISearchResultsUpdating {
    
    var imageView = UIImageView()
    let postManager = PostManager.sharedInstance
    
    var data: [String] = []
    var filteredData: [String]!
    var resultSearchController = UISearchController()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.resultSearchController = UISearchController(searchResultsController: nil)
        self.resultSearchController.searchResultsUpdater = self
        
        self.resultSearchController.dimsBackgroundDuringPresentation = false
        self.resultSearchController.searchBar.sizeToFit()
        
        self.tableView.tableHeaderView = self.resultSearchController.searchBar
        
        self.tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      
      if self.resultSearchController.active
      {
           return self.filteredData.count
      }
      else
      {
          return self.data.count
      }
        
    }


    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as UITableViewCell?
        
        if self.resultSearchController.active
        {
            cell!.textLabel?.text = self.filteredData[indexPath.row]
        }
//        else
//        {
////            setImageFirst()
////            setImageSecond()
////            setImageThird()
////            setImageFourth()
////            setImageFifth()
//            
//           cell!.textLabel?.text = self.data[indexPath.row]
//        }
        return cell!
    }
    
//    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//        let post = self.postManager.posts[indexPath.row]
//        self.performSegueWithIdentifier("SearchToPostDetailTableViewController", sender: post)
//    }
//    
//    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        let postDetailTableViewController = segue.destinationViewController as! PostDetailTableViewController
//        postDetailTableViewController.post = sender as! Post!
//    }
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
//        self.filteredData.removeAll()
        
        let searchPredicate = NSPredicate(format: "SELF CONTAINS[c] %@", searchController.searchBar.text!)
        let searchText = searchController.searchBar.text!
        setSearchText(searchText)
        let searchPosts = postManager.posts
        for searchpost in searchPosts {
        let textPost = searchpost.text
        self.data.append(textPost)
            
        }
        
        let array = (self.data as NSArray).filteredArrayUsingPredicate(searchPredicate)
        
        self.filteredData = array as! [String]
        
        self.tableView.reloadData()
        
    }
    
    func setSearchText(searchText: String) {
        postManager.fetchPost(searchText) { ()in
            self.tableView.reloadData()
        }
    }
    
    func setImageFirst(){
        imageView = UIImageView(frame: CGRectMake(0,0,100,120))
        let firstImage = UIImage(named: "1")
        imageView.image = firstImage
        imageView.layer.cornerRadius = 5
        imageView.layer.borderWidth = 2
        imageView.layer.borderColor = UIColor.whiteColor().CGColor
        imageView.layer.position = CGPoint(x: self.view.bounds.width/2, y: 200.0)
        self.view.addSubview(imageView)
    }
    
    func setImageSecond(){
        
    }
    
    func setImageThird() {
        
    }
    
    func setImageFourth() {
        
    }
    
    func setImageFifth() {
        
    }
    
}








