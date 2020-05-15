import UIKit
import CoreLocation

class MineViewController: UIViewController,CLLocationManagerDelegate {
    
    static var uid:String = "1"
    static var username:String = "helloworld"
    static var sex:String = "男"
    static var headImageStr:String = ""
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var headImage: UIImageView!
    
    @IBOutlet weak var usernameLable: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        usernameLable.text = MineViewController.username
        //headImage.image = UIImage(data: Data(base64Encoded: MineViewController.headImageStr)!)
        //设置tableview
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "UITableViewCell")
        tableView.tableFooterView = UIView()
    }
}

extension MineViewController: UITableViewDataSource {
    //行数
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    //行名
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell")!
        if indexPath.row == 0 {
            cell.textLabel?.text = "    昵称：" + MineViewController.username
        }else if indexPath.row == 1 {
            cell.textLabel?.text = "    密码：修改密码"
        }else if indexPath.row == 2 {
            cell.textLabel?.text = "    性别 ：" + MineViewController.sex
        }else if indexPath.row == 3 {
            cell.textLabel?.text = "    位置："
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    }

}

extension MineViewController: UITableViewDelegate{
    
    @objc func clickInputBtn(_ title:String, _ text:String) {
        //初始化UITextField
        var inputText:UITextField = UITextField();
        let msgAlertCtr = UIAlertController.init(title: "修改"+title, message: "请输入新的"+title, preferredStyle: .alert)
        let ok = UIAlertAction.init(title: "确定", style:.default) { (action:UIAlertAction) ->() in
            
        }
        let cancel = UIAlertAction.init(title: "取消", style:.cancel) { (action:UIAlertAction) -> ()in
            print("取消输入")
        }
        msgAlertCtr.addAction(ok)
        msgAlertCtr.addAction(cancel)
        //添加textField输入框
        msgAlertCtr.addTextField { (textField) in
            //设置传入的textField为初始化UITextField
            inputText = textField
            inputText.placeholder = text
        }
        //设置到当前视图
        self.present(msgAlertCtr, animated: true, completion: nil)
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            clickInputBtn("昵称", MineViewController.username)
        }else if indexPath.row == 1 {
            clickInputBtn("密码", "新密码")
        }
    }

    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .none
    }
    

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    }

}
