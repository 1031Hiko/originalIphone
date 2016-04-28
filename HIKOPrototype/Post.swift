import UIKit

enum PostCategory:Int {
    case Mua = 0
    case Designer = 1
    case Photo = 2
}

class Post: NSObject {
    var text: String
    var user: User?
    var category: Int?
    var objectId: NSString?
    var image: String?
    var descript: String?
    
    var comments: [Comment] = []
    
    init(text: String) {
        self.text = text
    }
    
    func save(callback: () -> Void) {
        
        let postObject = NCMBObject(className: "Post")
        postObject.setObject(text, forKey: "text")
        postObject.setObject(image, forKey: "image")
        postObject.setObject(descript, forKey: "descript")
        postObject.setObject(category!.hashValue, forKey: "category")
        postObject.setObject(NCMBUser.currentUser(), forKey: "user")
        postObject.saveInBackgroundWithBlock { (error) in
            if error == nil {
                callback()
            }
        }
    }
}
