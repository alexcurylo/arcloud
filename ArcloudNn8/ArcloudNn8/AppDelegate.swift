//
// Please report any problems with this app template to contact@estimote.com
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        ESTConfig.setupAppID("arcloud-nn8", andAppToken:"cfe3e7b97fbb6245cb90a065f4ac0c64");
        
        return true
    }
}
