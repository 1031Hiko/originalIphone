import UIKit

@objc protocol PostTableViewDelegate{
    func didSelectTableViewCell(post: Post)
}

class PostTableView: UITableView, UITableViewDelegate, UITableViewDataSource {
    
    weak var customDelegate: PostTableViewDelegate?
    let postManager = PostManager.sharedInstance
    var category: Int!
    
    override init(frame: CGRect, style: UITableViewStyle) {
        super.init(frame: frame, style: style)
        
        self.delegate = self
        self.dataSource = self
        
//        postManager.fetchPosts { () in
//            self.reloadData()
//        }
//
        self.registerNib(UINib(nibName: "PostTableViewCell", bundle: nil), forCellReuseIdentifier: "PostTableViewCell")
    }
    
    convenience init(frame: CGRect, style: UITableViewStyle, category: Int) {
        self.init(frame: frame, style: style)
        
        self.category = category
        print(category)
        postManager.fetchPosts(category) {
            self.reloadData()
        }
    }
    

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //    the number of sections
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    //    the number of cells
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return postManager.posts.count
    }
    
    //    content of cell
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("PostTableViewCell", forIndexPath: indexPath) as! PostTableViewCell
        let post = postManager.posts[indexPath.row]
        
        cell.title.text = post.text
        cell.time.text = getCurrentTime()
        cell.userImage.image = UIImage(named: "pug")
        cell.userName.text = post.user?.name
        
        return cell
    }
    
    //    height of rows
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 85
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == 0 {
            let post = self.postManager.posts[indexPath.row]
            print(post.text)
            self.customDelegate?.didSelectTableViewCell(post)
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
}
