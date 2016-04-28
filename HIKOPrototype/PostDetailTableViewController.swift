import UIKit

class PostDetailTableViewController: UITableViewController, UITextFieldDelegate {
    @IBOutlet weak var commentTextField: UITextField!
    
    let postWishList = PostWishList.postWishSharedInstance
    
    var post: Post!
    let postManager = PostManager.sharedInstance
    
    let backgroundView = UIView()
    let shareView = UIView()
    
    let black = UIColor(red: 50.0 / 255, green: 56.0 / 255, blue: 60.0 / 255, alpha: 1.0)

    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        commentTextField.delegate = self
        
        let tapRecogniser = UITapGestureRecognizer(target: self, action: #selector(PostDetailTableViewController.tapGesture(_:))  )
        self.view.addGestureRecognizer(tapRecogniser)
        
        let rightShareBarButtonItem:UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Action, target: self, action: #selector(PostDetailTableViewController.showActionMenu))
        
        let rightCommentPostBarButtonItem:UIBarButtonItem = UIBarButtonItem(title: "Post", style: .Plain, target: self, action: #selector(PostDetailTableViewController.postComment))
        
        self.navigationItem.setRightBarButtonItems([rightShareBarButtonItem,rightCommentPostBarButtonItem], animated: true)

        
        self.navigationController!.setNavigationBarHidden(false, animated: true)
        self.navigationController!.navigationBar.barTintColor = black
        self.navigationController!.navigationBar.tintColor = UIColor.whiteColor()
        
        self.tableView.registerNib(UINib(nibName: "PostDetailImageTableViewCell", bundle: nil), forCellReuseIdentifier: "PostDetailImageTableViewCell")
        self.tableView.registerNib(UINib(nibName: "PostDetailTableViewCell", bundle: nil), forCellReuseIdentifier: "PostDetailTableViewCell")
        self.tableView.registerNib(UINib(nibName: "CommentTableViewCell", bundle: nil), forCellReuseIdentifier: "CommentTableViewCell")

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func postComment(){
        if (commentTextField.text!.isEmpty){
            let alertController = UIAlertController(title: "Error", message: "'post' is empty", preferredStyle: UIAlertControllerStyle.Alert)
            let action = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil)
            alertController.addAction(action)
            presentViewController(alertController, animated: true, completion: nil)
        } else {
        let comment = Comment(text: commentTextField.text!)
        post.comments.insert(comment, atIndex: 0)
        self.tableView.reloadData()
        comment.post = post
        comment.save{ () in
            self.postManager.fetchPosts { ()  in
                self.tableView.reloadData()
            }
          }
        }
        commentTextField.text = ""
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        //キーボード閉じる為のメソッド
        commentTextField.resignFirstResponder()
        return true
    }
    
    func tapGesture(sender: UITapGestureRecognizer) {
        commentTextField.resignFirstResponder()
    }

   
    
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 3
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else if section == 1 {
            return 1
        } else {
            return post.comments.count
        }
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
        let cell = tableView.dequeueReusableCellWithIdentifier("PostDetailImageTableViewCell", forIndexPath: indexPath) as! PostDetailImageTableViewCell
//            var imageName = post.image
        
//            let image = getImage(imageName: Post)
            
        return cell
            
        } else if indexPath.section == 1 {
        let cell = tableView.dequeueReusableCellWithIdentifier("PostDetailTableViewCell", forIndexPath: indexPath)as! PostDetailTableViewCell
            
            cell.titleLabel.text = post.text
            cell.updateTimeLabel.text = getCurrentTime()
            cell.userNameLabel.text = post.user?.name
        return cell
        
        } else {
        let cell = tableView.dequeueReusableCellWithIdentifier("CommentTableViewCell", forIndexPath: indexPath) as! CommentTableViewCell
            cell.nameLabel.text = post.user?.name
            cell.commentLabel.text = post.comments[indexPath.row].text
        return cell
        }
    }
    
//    func getImage(x){
//        var fileData = [NCMBFile fileWithName:"x" data:nil]
//    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 160
        } else if indexPath.section == 1 {
            return 130
        } else {
            return 85
        }
    }
    
    func getCurrentTime() -> String {
        let now = NSDate() // 現在日時の取得
        let dateFormatter = NSDateFormatter()
        dateFormatter.timeStyle = .ShortStyle
        dateFormatter.dateStyle = .ShortStyle
        let currentTime = dateFormatter.stringFromDate(now)
        return currentTime
    }
    
    func showActionMenu() {
        setBackgroundView()
        setShareView()
        setShareBtn(self.view.frame.width/8, tag: 1, imageName: "facebook_icon")
        setShareBtn(self.view.frame.width/8 * 3, tag: 2, imageName: "twitter_icon")
        setShareBtn(self.view.frame.width/8 * 5, tag: 3, imageName: "safari_icon")
        setShareBtn(self.view.frame.width/8 * 7, tag: 4, imageName: "bookmark_icon")
        
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            self.shareView.frame.origin = CGPointMake(0, self.view.frame.height - 200)
        })
    }
    
    func setBackgroundView() {
        backgroundView.frame.size = self.view.frame.size
        backgroundView.frame.origin = CGPointMake(0, 0)
        backgroundView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.6)
        self.view.addSubview(backgroundView)
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(PostDetailTableViewController.tapBackgroundView))
        backgroundView.addGestureRecognizer(gesture)
    }
    
    func tapBackgroundView(){
        backgroundView.removeFromSuperview()
    }
    
    func setShareView(){
        shareView.frame = CGRectMake(0, self.view.frame.height, self.view.frame.width, 100)
        shareView.backgroundColor = UIColor.whiteColor()
        shareView.layer.cornerRadius = 3
        backgroundView.addSubview(shareView)
    }
    
    func setShareBtn(x: CGFloat, tag: Int, imageName: String){
        let shareBtn = UIButton()
        shareBtn.frame.size = CGSizeMake(60, 60)
        shareBtn.center = CGPointMake(x, 50)
        shareBtn.setBackgroundImage(UIImage(named: imageName), forState: UIControlState.Normal)
        shareBtn.layer.cornerRadius = 3
        shareBtn.tag = tag
        shareBtn.addTarget(self, action: #selector(PostDetailTableViewController.tapShareBtn(_:)), forControlEvents: .TouchUpInside)
        shareView.addSubview(shareBtn)
    }
    
    func tapShareBtn(sender: UIButton){
        if sender.tag == 1 {
//            let facebookVC = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
//            facebookVC.setInitialText(wkWebView.title)
//            facebookVC.addURL(wkWebView.URL)
//            presentViewController(facebookVC, animated: true, completion: nil)
        } else if sender.tag == 2 {
//            let twitterVC = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
//            twitterVC.setInitialText(wkWebView.title)
//            twitterVC.addURL(wkWebView.URL)
//            presentViewController(twitterVC, animated: true, completion: nil)
        } else if sender.tag == 3 {
//            UIApplication.sharedApplication().openURL(wkWebView.URL!)
        } else if sender.tag == 4 {
            if isStockedArticle(){
                showAlert("Saved already")
            } else {
                self.postWishList.addPostWishList(self.post)
                showAlert("Saved in BookMark")
            }
        }
    }
    
    func showAlert(text: String){
        let alertController = UIAlertController(title: text, message: nil , preferredStyle: UIAlertControllerStyle.Alert)
        let action = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default) { (action) -> Void in
            self.backgroundView.removeFromSuperview()
        }
        alertController.addAction(action)
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    
    func isStockedArticle() -> Bool {
        for myPost in self.postWishList.myPosts {
            if myPost.text == self.post.text {
                return true
            }
        }
        return false
    }
 
    
}


    
