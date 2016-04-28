import UIKit

class Comment: NSObject {
    
    var text: String
    var post: Post?
    
    init(text: String) {
        self.text = text
    }
    
    func save(callback: () -> Void) {
        let commentObject = NCMBObject(className: "Comment")
        commentObject.setObject(text, forKey: "text")
        commentObject.setObject(post!.objectId, forKey: "post")
        commentObject.saveInBackgroundWithBlock { (error) in
            if error == nil {
                callback()
                print("Got It")
            }
        }
    }

}
