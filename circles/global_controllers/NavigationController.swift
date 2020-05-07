import UIKit

class NavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.navigationBar.barTintColor = UIColor.white
        self.navigationBar.isTranslucent = false
    }


}
