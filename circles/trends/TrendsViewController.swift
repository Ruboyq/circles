import UIKit

class TrendsViewController: UIViewController {

    @objc func showPublish(){
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad();
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "发布", style: .plain, target: self, action: #selector(showPublish))
    }

}
