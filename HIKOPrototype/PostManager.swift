import UIKit

class PostManager: NSObject {
    static let sharedInstance = PostManager()
    var posts:[Post] = []
    
    func fetchPosts(x: Int, callback:()-> Void) {
        let query = NCMBQuery(className: "Post")
        query.whereKey("category", equalTo: x)
        query.includeKey("user")
        query.orderByDescending("createDate")
        query.findObjectsInBackgroundWithBlock { (objects, error) in
            if error == nil {
                self.posts = []
                for object in objects {
                    let text = object.objectForKey("text") as! String
                    let post = Post(text: text)
                    let image = object.objectForKey("image") as! String
                    let descript = object.objectForKey("descript") as! String
                    let objectIdObject = object.objectForKey("objectId") as! NSString
                    let categoryObject = object.objectForKey("category") as! Int
                    let userObject = object.objectForKey("user") as! NCMBUser
                    let user = User(name: userObject.userName!, password: "")
                    print(userObject.userName!)
                    post.descript = descript
                    post.user = user
                    post.image = image
                    post.objectId = objectIdObject
                    post.category = categoryObject
                    self.posts.append(post)
                    
                    let commentQuery = NCMBQuery(className: "Comment")
                    commentQuery.whereKey("post", equalTo: objectIdObject)
                    commentQuery.orderByDescending("createDate")
                    commentQuery.findObjectsInBackgroundWithBlock ({ (objects, error) in
                        if error == nil {
                            for object in objects {
                                let text = object.objectForKey("text") as! String
                                let comment = Comment(text: text)
                                post.comments.append(comment)
                            }
                        }
                    })
                  callback()
                }
            }
        }
    }
    
    func fetchPosts(callback:()-> Void) {
        let query = NCMBQuery(className: "Post")
        query.includeKey("user")
        query.orderByDescending("createDate")
        query.findObjectsInBackgroundWithBlock { (objects, error) in
            if error == nil {
                self.posts = []
                for object in objects {
                    let text = object.objectForKey("text") as!String
                    let post = Post(text: text)
                    let image = object.objectForKey("image") as!String
                    let descript = object.objectForKey("descript") as!String
                    let objectIdObject = object.objectForKey("objectId") as!NSString
                    let categoryObject = object.objectForKey("category") as!Int
                    let userObject = object.objectForKey("user") as! NCMBUser
                    let user = User(name: userObject.userName!, password: "")
                    post.descript = descript
                    post.user = user
                    post.image = image
                    post.objectId = objectIdObject
                    post.category = categoryObject
                    self.posts.append(post)
                    
                    let commentQuery = NCMBQuery(className: "Comment")
                    commentQuery.whereKey("post", equalTo: objectIdObject)
                    commentQuery.orderByDescending("createDate")
                    commentQuery.findObjectsInBackgroundWithBlock ({ (objects, error) in
                        if error == nil {
                            for object in objects {
                                let text = object.objectForKey("text") as! String
                                let comment = Comment(text: text)
                                post.comments.append(comment)
                            }
                        }
                    })
                 callback()
                }
            }
        }
    }
    
    func fetchPost(searchText: String, callback:()-> Void) {
        let query = NCMBQuery(className: "Post")
        query.includeKey("user")
        query.whereKey("text", lessThanOrEqualTo: searchText)
        query.orderByDescending("createDate")
        query.findObjectsInBackgroundWithBlock { (objects, error) in
            if error == nil {
                self.posts = []
                for object in objects {
                    let text = object.objectForKey("text") as!String
                    let post = Post(text: text)
                    let image = object.objectForKey("image") as!String
                    let descript = object.objectForKey("descript") as!String
                    let objectIdObject = object.objectForKey("objectId") as!NSString
                    let categoryObject = object.objectForKey("category") as!Int
                    let userObject = object.objectForKey("user") as! NCMBUser
                    let user = User(name: userObject.userName!, password: "")
                    post.descript = descript
                    post.user = user
                    post.image = image
                    post.objectId = objectIdObject
                    post.category = categoryObject
                    self.posts.append(post)
                    
                    let commentQuery = NCMBQuery(className: "Comment")
                    commentQuery.whereKey("post", equalTo: objectIdObject)
                    commentQuery.orderByDescending("createDate")
                    commentQuery.findObjectsInBackgroundWithBlock ({ (objects, error) in
                        if error == nil {
                            for object in objects {
                                let text = object.objectForKey("text") as! String
                                let comment = Comment(text: text)
                                post.comments.append(comment)
                            }
                        }
                    })
                  callback()
                }
            }
        }
    }
}


