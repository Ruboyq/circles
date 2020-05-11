import UIKit

class TrendsViewController: UIViewController {

    @objc func showPublish(){
        let sb = UIStoryboard(name: "TrendsPublish", bundle: nil)
        let destination = sb.instantiateViewController(withIdentifier: "PublishView")
        //页面传参
        //destination.info = ListViewController.listData[indexPath.row]
        self.navigationController?.pushViewController(destination, animated: true)
        //self.present(destination, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad();
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "发布", style: .plain, target: self, action: #selector(showPublish))
    }

}
