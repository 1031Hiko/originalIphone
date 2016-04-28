import UIKit

class PostWishList: NSObject {
    
    static let postWishSharedInstance = PostWishList()
    
    var myPosts: Array<Post> = []
    
    func addPostWishList(post: Post) {
        self.myPosts.insert(post, atIndex: 0)
        savePost()
    }
    
    func savePost(){
        var tmpPosts: Array<Dictionary<String, AnyObject>> = []
        for myPost in self.myPosts {
            let postDic = PostWishList.convertDictionary(myPost)
            tmpPosts.append(postDic)
        }
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setObject(tmpPosts, forKey: "myPosts")
        defaults.synchronize()
    }
    
    func getMyPosts(){
        let defaults = NSUserDefaults.standardUserDefaults()
        if let posts = defaults.objectForKey("myPosts") as? Array<Dictionary<String, String>> {
            for dic in posts {
                let post = PostWishList.convertPostModel(dic)
                self.myPosts.append(post)
            }
        }
    }
    
    class func convertPostModel(dic: Dictionary<String, String>) -> Post {
        let post = Post(text: dic["text"]!)
        
//        post.user = User(dic["user"]!)
        return post
    }
    
    class func convertDictionary(post: Post) -> Dictionary<String, AnyObject> {
        var dic = Dictionary<String, AnyObject>()
        dic["text"] = post.text
//        dic["user"] = post.user
        return dic
    }
    
    func removeMyPost(index: Int){
        self.myPosts.removeAtIndex(index)
        savePost()
    }
    
    
}