import UIKit

class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let logo = UIImage(named: "logo");
        let imageView = UIImageView(image: logo);
        imageView.contentMode = .scaleAspectFit
        self.navigationItem.titleView = imageView;
    }


}
