import UIKit

class MyPageViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var backProfileImageView: UIImageView!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var headerScrollView: UIScrollView!
    @IBOutlet weak var tableView: UITableView!
    
    let postManager = PostManager.sharedInstance
    
    let myArray: NSArray = ["MUA","Designer","Photo"]
    
    var selectedSegCon = 0
    
    var ImageName = String()
    
    //Post用
    let backPostView = UIView()
    let textField = UITextField()
    let textView = UITextView()
    
    //cameraボタン用
    let backgroundView = UIView()
    let shareView = UIView()
    var cameraImageSelected = UIImageView()
    
    
    var currentSelectedPost: Post?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textField.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        
        
        tableView.registerNib(UINib(nibName: "PostTableViewCell", bundle: nil), forCellReuseIdentifier: "PostTableViewCell")
        headerScrollView.contentSize = CGSize(width: self.view.frame.width*2, height: headerScrollView.frame.height)
        headerScrollView.pagingEnabled = true
        headerScrollView.delegate = self
        
    
        setProfileImageView()
        
        
        setBackProfileImageView()
        
        
        let profileLabel = makeProfileLabel()
        headerScrollView.addSubview(profileLabel)
        
        
        
        //セルの高さを設定
        self.tableView.rowHeight = 85
        

        postManager.fetchPosts { 
            self.tableView.reloadData()
        }
    
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        //キーボード閉じる為のメソッド
        textField.resignFirstResponder()
        return true
        
    }
    
    
    //スクロールビュー
    func scrollViewDidScroll(scrollView: UIScrollView) {
        headerScrollView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: headerScrollView.contentOffset.x * 0.6 / self.view.frame.width)
    }
    
    //LogOutButton 表示
    override func viewWillAppear(animated: Bool) {
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .Plain, target: self, action: #selector(MyPageViewController.logout))
    }
    
    func logout() {
        NCMBUser.logOut()
        performSegueWithIdentifier("modalToLoginViewController", sender: self)
    }
    
    
    @IBAction func tapPostBtn(sender: UIBarButtonItem) {

        let backView = makeBackPostView()
        self.view.addSubview(backView)
        
        let postView = makePostView()
        backView.addSubview(postView)
        
        let textField = makeTextField()
        postView.addSubview(textField)
        
        let textView = makeTextView()
        postView.addSubview(textView)
        
        let titleLabel = makeLabel("title", y: 5)
        postView.addSubview(titleLabel)
        
        let postLabel = makeLabel("post", y: 85)
        postView.addSubview(postLabel)
        
        let cancelBtn = makeCancelBtn(postView)
        postView.addSubview(cancelBtn)
        
        let submitBtn = makeSubmitBtn()
        postView.addSubview(submitBtn)
        
        let cameraBtn = makeCameraBtn()
        postView.addSubview(cameraBtn)
        
        cameraImageSelected = makeCameraImageView()
        postView.addSubview(cameraImageSelected)
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(MyPageViewController.tapGesture(_:)))
        self.view.addGestureRecognizer(tapRecognizer)
        
        let mySegcon: UISegmentedControl = UISegmentedControl(items: myArray as [AnyObject])
        mySegcon.center = CGPoint(x: 150, y: 265)
        
        mySegcon.backgroundColor = UIColor.grayColor()
        mySegcon.tintColor = UIColor.whiteColor()
        mySegcon.addTarget(self, action: #selector(MyPageViewController.segconChanged(_:)), forControlEvents: UIControlEvents.ValueChanged)
        postView.addSubview(mySegcon)
        
 }

    
    func tapGesture(sender: UITapGestureRecognizer) {
        textField.resignFirstResponder()
        textView.resignFirstResponder()
    }

    func tappedCancelBtn(sender :AnyObject){
        backPostView.removeFromSuperview()
    }
    
    func tappedSubmitBtn(sender: AnyObject){
        if (textField.text!.isEmpty) || (textView.text.isEmpty){
            let alertController = UIAlertController(title: "Error", message: "'title' or 'post' is empty", preferredStyle: UIAlertControllerStyle.Alert)
            let action = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil)
            alertController.addAction(action)
            presentViewController(alertController, animated: true, completion: nil)
        } else {
            
            let post = Post(text: textField.text!)
            post.image = ImageName
            post.descript = textView.text!
            post.category = selectedSegCon
            post.save { () in
                self.postManager.fetchPosts { () in
                  self.tableView.reloadData()
                }
            }
        }
            backPostView.removeFromSuperview()
            textField.text = ""
            textView.text = ""
    }
    
    func segconChanged(sender: UISegmentedControl) {
        selectedSegCon = sender.selectedSegmentIndex
        }
    
    func getCurrentTime() -> String {
        let now = NSDate() // 現在日時の取得
        let dateFormatter = NSDateFormatter()
        dateFormatter.timeStyle = .ShortStyle
        dateFormatter.dateStyle = .ShortStyle
        let currentTime = dateFormatter.stringFromDate(now)
        return currentTime
    }
    
    
    
    //make parts//
    
    //ProfileImageView 生成
    func setProfileImageView() {
        profileImageView.image = UIImage()
        profileImageView.layer.cornerRadius = 5
        profileImageView.layer.borderWidth = 2
        profileImageView.layer.borderColor = UIColor.whiteColor().CGColor
        
    }
    
    func setBackProfileImageView() {
        backProfileImageView.image = UIImage()
        backProfileImageView.layer.cornerRadius = 3
        backProfileImageView.layer.borderWidth = 1
        backProfileImageView.layer.borderColor = UIColor.whiteColor().CGColor
    }
    
    func makeProfileLabel() -> UILabel {
        let profileLabel = UILabel()
        profileLabel.frame.size = CGSizeMake(200, 100)
        profileLabel.center.x = self.view.frame.width*3/2
        profileLabel.center.y = headerScrollView.center.y-64
        profileLabel.text = "protoType"
        profileLabel.font = UIFont(name: "HirakakuProN-W6", size: 13)
        profileLabel.textColor = UIColor.whiteColor()
        profileLabel.textAlignment = NSTextAlignment.Center
        profileLabel.numberOfLines = 0
        return profileLabel
    }
    
    func makeBackPostView() -> UIView {
        backPostView.frame = CGRectMake(0, 0, self.view.frame.width, self.view.frame.height)
        backPostView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.6)
        return backPostView
    }
    
    func makePostView()-> UIView {
        let postView = UIView()
        postView.frame.size = CGSizeMake(330, 450)
        postView.center.x = self.view.center.x
        postView.center.y = 300
        postView.backgroundColor = UIColor.whiteColor()
        postView.layer.shadowOpacity = 0.3
        postView.layer.cornerRadius = 3
        return postView
    }
    
    func makeTextField() -> UITextField {
        
        textField.frame = CGRectMake(10, 40, 280, 40)
        textField.font = UIFont(name: "HiraKakuProN-W6", size: 15)
        textField.borderStyle = UITextBorderStyle.RoundedRect
        return textField
    }
    
    func makeTextView() -> UITextView {
        
        textView.frame = CGRectMake(10, 120, 280, 110)
        textView.font = UIFont(name: "HiraKakuProN-W6", size: 15)
        textView.layer.cornerRadius = 8
        textView.layer.borderColor = UIColor(red: 0.85, green: 0.85, blue: 0.85, alpha: 1.0).CGColor
        textView.layer.borderWidth = 1
        return textView
    }
    
    func makeLabel(text: String, y: CGFloat) -> UILabel {
        let label = UILabel(frame: CGRectMake(10, y, 280, 40))
        label.text = text
        label.font = UIFont(name: "HiraKakuProN-W6", size: 15)
        return label
    }
    
    func makeCancelBtn(postView: UIView) -> UIButton {
        let cancelBtn = UIButton()
        cancelBtn.frame.size = CGSizeMake(20, 20)
        cancelBtn.center.x = postView.frame.width-15
        cancelBtn.center.y = 15
        cancelBtn.setBackgroundImage(UIImage(named: "cancel.png"), forState: .Normal)
        cancelBtn.backgroundColor = UIColor(red: 0.14, green: 0.3, blue: 0.68, alpha: 1.0)
        cancelBtn.layer.cornerRadius = cancelBtn.frame.width/2
        cancelBtn.addTarget(self, action: #selector(MyPageViewController.tappedCancelBtn(_:)), forControlEvents:.TouchUpInside)
        return cancelBtn
    }
    
    func makeSubmitBtn() -> UIButton {
        let submitBtn = UIButton()
        submitBtn.frame = CGRectMake(10, 400, 280, 40)
        submitBtn.setTitle("送信", forState: .Normal)
        submitBtn.titleLabel?.font = UIFont(name: "HiraKakuProN-W6", size: 15)
        submitBtn.backgroundColor = UIColor(red: 0.14, green: 0.3, blue: 0.68, alpha: 1.0)
        submitBtn.setTitleColor(UIColor.grayColor(), forState: UIControlState.Highlighted)
        submitBtn.layer.cornerRadius = 7
        submitBtn.addTarget(self, action: #selector(MyPageViewController.tappedSubmitBtn(_:)), forControlEvents: .TouchUpInside)
        return submitBtn
    }
    
    //camera用部品一式
    func makeCameraBtn() -> UIButton {
        let cameraBtn = UIButton()
        cameraBtn.frame = CGRectMake(10, 300, 40, 40)
        cameraBtn.setTitle("C", forState: .Normal)
        cameraBtn.titleLabel?.font = UIFont(name: "HiraKakuProN-W6", size: 15)
        cameraBtn.backgroundColor = UIColor(red: 0.14, green: 0.3, blue: 0.68, alpha: 1.0)
        cameraBtn.setTitleColor(UIColor.grayColor(), forState: UIControlState.Highlighted)
        cameraBtn.layer.cornerRadius = 7
        cameraBtn.addTarget(self, action: #selector(MyPageViewController.showActionMenu), forControlEvents: .TouchUpInside)
        return cameraBtn
    }
    
    func makeCameraImageView() -> UIImageView! {
        let cameraImageView = UIImageView()
        cameraImageView.frame.size = CGSizeMake(250, 60)
        cameraImageView.center.x = self.view.center.x
        cameraImageView.center.y = 350
        cameraImageView.backgroundColor = UIColor.whiteColor()
        cameraImageView.layer.shadowOpacity = 0.3
        cameraImageView.layer.cornerRadius = 3
        return cameraImageView
    }
    
    func tappedCameraBtn(sender: UIButton){
        
    }
    
    func showActionMenu() {
        setBackgroundView()
        setShareView()
        
        setShareBtn(self.view.frame.width/8, tag: 1, imageName: "facebook_icon")
        setShareBtn(self.view.frame.width/8 * 3, tag: 2, imageName: "twitter_icon")
        setShareBtn(self.view.frame.width/8 * 5, tag: 3, imageName: "safari_icon")
        setShareBtn(self.view.frame.width/8 * 7, tag: 4, imageName: "bookmark_icon")
        
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            self.shareView.frame.origin = CGPointMake(0, self.view.frame.height - 145)
        })
    }
    
    func setBackgroundView() {
        backgroundView.frame.size = self.view.frame.size
        backgroundView.frame.origin = CGPointMake(0, 0)
        backgroundView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.6)
        self.view.addSubview(backgroundView)
        let gesture = UITapGestureRecognizer(target: self, action: #selector(MyPageViewController.tapBackgroundView))
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
        shareBtn.addTarget(self, action: #selector(MyPageViewController.tapCameraBtn(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        shareView.addSubview(shareBtn)
    }
    
    func tapCameraBtn(sender: UIButton){
        if sender.tag == 1 {
            //cameraのLibrary実装
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.PhotoLibrary){
                let album = UIImagePickerController()
                album.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
                album.allowsEditing = true
                album.delegate = self
                self.presentViewController(album, animated: true, completion: nil)
            }
        } else if sender.tag == 2 {
            //cameraのPhotoの実装
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera) {
                let camera = UIImagePickerController()
                camera.sourceType = UIImagePickerControllerSourceType.Camera
                camera.delegate = self
                camera.allowsEditing = true
                self .presentViewController(camera, animated: true, completion: nil)
            }
        } else if sender.tag == 3 {
            //Safariで記事を開く
        } else if sender.tag == 4 {
            //ブックマークに追加
        }
    }
    
    //カメラロールから選択した写真 or その場で撮った写真をniftyへ保存
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        cameraImageSelected.image = info[UIImagePickerControllerEditedImage] as? UIImage
        let image = cameraImageSelected.image
        let pngData = UIImagePNGRepresentation(image!)
        ImageName = NSUUID().UUIDString + ".png"
        let ncmbFile = NCMBFile.fileWithName(ImageName, data: pngData)
        ncmbFile.saveInBackgroundWithBlock(){ error in
            if let error = error {
                print("File save error : ", error)
            } else {
                print("File save OK")
            }
        }
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func updateImage(){
        let image = cameraImageSelected.image
        let pngData = UIImagePNGRepresentation(image!)
        ImageName = NSUUID().UUIDString + ".png"
        let ncmbFile = NCMBFile.fileWithName(ImageName, data: pngData)
        ncmbFile.saveInBackgroundWithBlock(){ error in
            if let error = error {
                print("File save error : ", error)
            } else {
                print("File save OK")
            }
        }
    }

    
    //TableViewに関する記述
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return postManager.posts.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("PostTableViewCell") as! PostTableViewCell
        let post = postManager.posts[indexPath.row]
        cell.title.text = post.text
        cell.time.text = getCurrentTime()
        cell.userImage.image = UIImage(named: "pug")
        cell.userName.text = post.user?.name
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let post = self.postManager.posts[indexPath.row]
        self.performSegueWithIdentifier("MyPageToPostDetailTableViewController", sender: post)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let postDetailTableViewController = segue.destinationViewController as! PostDetailTableViewController
        postDetailTableViewController.post = sender as! Post!
    }
    
    
}
















