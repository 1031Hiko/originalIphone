import UIKit

class User: NSObject {
    
    var name: String
    var password: String
    
    init(name: String, password: String){
        self.name = name
        self.password = password
    }
    
    
    func signUp(callBack: (message: String?) -> Void) {
        let user = NCMBUser()
        user.userName = name
        user.password = password
        user.signUpInBackgroundWithBlock {(error) in
            callBack(message: error?.userInfo["NSLocalizedDescription"] as? String)
        }
    }
    
    func login(callback: (message: String?) -> Void) {
        NCMBUser.logInWithUsernameInBackground(self.name, password: self.password) { (user, error) in
            callback(message: error?.userInfo["NSLocalizedDescription"] as? String)
        }
    }
    
    

}
