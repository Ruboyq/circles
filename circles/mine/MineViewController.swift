import UIKit
import CoreLocation

class MineViewController: UIViewController, CLLocationManagerDelegate, UIGestureRecognizerDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate  {
    
    static var uid:String = "1"
    static var username:String = "helloworld"
    static var sex:String = "男"
    static var headImageStr:String = ""
    static var userCity:String = ""
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var headImage: UIImageView!
    
    @IBOutlet weak var usernameLable: UILabel!
    
    @IBOutlet weak var logoutBtn: UIButton!
    
    var locationManager:CLLocationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        usernameLable.text = MineViewController.username
        headImage.image = UIImage(data: Data(base64Encoded: MineViewController.headImageStr)!)
        //设置tableview
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "UITableViewCell")
        tableView.tableFooterView = UIView()
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapGesture))
        tap.delegate = self
        tap.numberOfTapsRequired = 1
        tap.numberOfTouchesRequired = 1
        headImage.addGestureRecognizer(tap)
        reLocationAction()
    }
    
    @objc func tapGesture(tap:UITapGestureRecognizer) {
        //判断设置是否支持图片库
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            //初始化图片控制器
            let picker = UIImagePickerController()
            //设置代理
            picker.delegate = self
            //指定图片控制器类型
            picker.sourceType = UIImagePickerController.SourceType.photoLibrary
            //设置是否允许编辑
            picker.allowsEditing = true
            //弹出控制器，显示界面
            self.present(picker, animated: true, completion: {
                () -> Void in
            })
        }else{
            print("读取相册错误")
        }
        return;
    }
    
    //选择图片成功后代理
    func imagePickerController(_ picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        //查看info对象
        //print(info)
        //显示的图片
        let image:UIImage!
        image = info[.editedImage] as? UIImage
        headImage.image = image
        MineViewController.headImageStr = image!.pngData()!.base64EncodedString()
        //图片控制器退出
        picker.dismiss(animated: true, completion: {
            () -> Void in
        })
    }
    
    func reLocationAction(){
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest//定位最佳
        locationManager.distanceFilter = 500.0//更新距离
        locationManager.requestWhenInUseAuthorization()
        if (CLLocationManager.locationServicesEnabled()){
            locationManager.startUpdatingLocation()
            print("定位开始")
        }
    }
    func locationManager(_ manager: CLLocationManager, didFinishDeferredUpdatesWithError error: Error?) {
        print("获取经纬度发生错误")
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]){
        let thelocations:NSArray = locations as NSArray
        let location = thelocations.lastObject as! CLLocation
        let latitude = location.coordinate.latitude
        let longitude = location.coordinate.longitude
        let latitudeStr = Float(latitude)
        let longitudeStr = Float(longitude)
        print(latitudeStr)
        print(longitudeStr)
        locationManager.stopUpdatingLocation()
        LonLatToCity()
    }
    
    func LonLatToCity() {
        let geocoder: CLGeocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(locationManager.location ?? CLLocation()) { (placemark, error) -> Void in
            if(error == nil)//成功
            {
                let array = placemark! as NSArray
                let mark = array.firstObject as! CLPlacemark
                let city: String = (mark.addressDictionary! as NSDictionary).value(forKey: "City") as! String
                print(city)
                MineViewController.userCity = city
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
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
            cell.textLabel?.text = "    位置：" + MineViewController.userCity
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
        inputText.text = ""
        let msgAlertCtr = UIAlertController.init(title: "修改"+title, message: "请输入修改后的"+title, preferredStyle: .alert)
        let ok = UIAlertAction.init(title: "确定", style:.default) { (action:UIAlertAction) ->() in
            if title == "昵称" {
                self.usernameLable.text = inputText.text!
                MineViewController.username = inputText.text!
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            } else if title == "性别" {
                MineViewController.sex = inputText.text!
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
        let cancel = UIAlertAction.init(title: "取消", style:.cancel) { (action:UIAlertAction) -> () in
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
        }else if indexPath.row == 2 {
            clickInputBtn("性别", MineViewController.sex)
        }
    }

    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .none
    }
    

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    }

}
