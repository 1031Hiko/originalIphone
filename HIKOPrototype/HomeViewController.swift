import UIKit

class HomeViewController: UIViewController, UIScrollViewDelegate, PostTableViewDelegate {
    @IBOutlet weak var postsScrollView: UIScrollView!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var appNameView: UIView!
    
    var currentSelectedPost: Post?
    
    let postManager = PostManager.sharedInstance
    
    var tabButtons: Array<UIButton> = []
    
    let black = UIColor(red: 50.0 / 255, green: 56.0 / 255, blue: 60.0 / 255, alpha: 1.0)
    let red = UIColor(red: 195.0 / 255, green: 123.0 / 255, blue: 175.0 / 255, alpha: 1.0)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        PostWishList.postWishSharedInstance.getMyPosts()
        
        postsScrollView.delegate = self
        
        
        
        //ScrollViewに関すること
        setTabButton(self.view.center.x/2, text: "MUA/Hair", color: red, tag: 1)
        setTabButton(self.view.center.x, text: "Designer/Stylist", color: red, tag: 2)
        setTabButton(self.view.center.x*3/2, text: "Photo/Model", color: red, tag: 3)
//        setTabButton(self.view.center.x*3/1.5, text: "designer", tag: 4)
//        setTabButton(self.view.center.x*3/2, text: "model", tag: 5)
//        setTabButton(self.view.center.x*3/4, text: "photographer", tag: 6)
        
        self.postsScrollView.contentSize = CGSizeMake(self.view.frame.width * 3, self.view.frame.height)
        self.postsScrollView.pagingEnabled = true
        
        //    PostsTableViewのinstanceを生成
        

        setSelectedButton(tabButtons[0], selected: true)
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        setPostTableView(0, category: 0)
        setPostTableView(self.view.frame.width, category: 1)
        setPostTableView(self.view.frame.width*2, category: 2)
        self.navigationController!.setNavigationBarHidden(true, animated: false)
        if NCMBUser.currentUser() == nil {
            performSegueWithIdentifier("modalLoginViewController", sender: self)
        }
    }
    

    func setPostTableView(x: CGFloat, category: Int){

        let frame = CGRectMake(x, 0, self.view.frame.width, self.view.frame.height)
//        let postTableView = PostTableView(frame: frame, style: UITableViewStyle.Plain)
        let postTableView = PostTableView(frame: frame, style: .Plain, category: category)
        postTableView.category = category
                postTableView.customDelegate = self
        self.postsScrollView.addSubview(postTableView)
//        if x == 0 {
//            postManager.fetchPosts(0) { ()in
//                postTableView.reloadData()
//            }
//        } else if x == self.view.frame.width {
//            postManager.fetchPosts(1) { ()in
//                postTableView.reloadData()
//            }
//        } else {
//            postManager.fetchPosts(2) { ()in
//                postTableView.reloadData()
//            }
//        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    func setTabButton(x: CGFloat, text: String, color: UIColor, tag: Int) {
        let tabButton = UIButton()
        tabButton.frame.size = CGSizeMake(100, 80)
        tabButton.center = CGPointMake(x, 18)
        tabButton.setTitle(text, forState: UIControlState.Normal)
        tabButton.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        tabButton.setTitleColor(color, forState: UIControlState.Selected)
        tabButton.titleLabel?.font = UIFont(name: "HirakakuProN-W6", size: 10)
        tabButton.tag = tag
        tabButton.addTarget(self, action: #selector(HomeViewController.tapTabButton(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        self.headerView.addSubview(tabButton)
        tabButtons.append(tabButton)
    }
    
    func tapTabButton(sender: UIButton) {
        let pointX = self.view.frame.width * CGFloat(sender.tag - 1)
        postsScrollView.setContentOffset(CGPointMake(pointX, 0), animated: true)
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        let page = scrollView.contentOffset.x / scrollView.frame.width
        
        for num in 0..<3 {
            if page == CGFloat(num) {
                setSelectedButton(tabButtons[num], selected: true)
            } else {
                setSelectedButton(tabButtons[num], selected: false)
            }
        }
    }
    
    
    func scrollViewDidEndScrollingAnimation(scrollView: UIScrollView) {
        let page = scrollView.contentOffset.x / scrollView.frame.width
        
        for num in 0..<3 {
            if page == CGFloat(num) {
                setSelectedButton(tabButtons[num], selected: true)
            } else {
                setSelectedButton(tabButtons[num], selected: false)
            }
        }
    }
    
    func setSelectedButton(button: UIButton, selected: Bool) {
        button.selected = selected
        button.layer.borderColor = button.titleLabel?.textColor.CGColor
    }
    
    func didSelectTableViewCell(post: Post) {
       self.currentSelectedPost = post
       self.performSegueWithIdentifier("HomeToPostDetailTableViewController", sender: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let postDetailTableViewController = segue.destinationViewController as! PostDetailTableViewController
        postDetailTableViewController.post = self.currentSelectedPost
    }
}

