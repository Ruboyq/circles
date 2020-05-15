import UIKit
import CoreData

class LoginController: UIViewController, URLSessionDelegate {
    
    static var baseurl:String = "http://192.168.3.4:8080"
    
    @IBOutlet weak var usernameText: UITextField!
    
    @IBOutlet weak var pwdText: UITextField!
    
    @IBOutlet weak var loginBtn: UIButton!
    
    @IBOutlet weak var regBtn: UIButton!
    
    var urlSession: URLSession!
    
    struct UserData: Codable {
        var uid: Int?
        var name: String?
        var sex: String?
        var icon: String?
    }
    
    struct UserResponseData: Codable {
        var code: Int = 0
        var msg: String = ""
        var data: UserData?
    }
    
    struct UserLiteData: Codable {
        var uid: Int
        var name: String
    }
    
    struct UserResponseLiteData: Codable {
        var code: Int = 0
        var msg: String = ""
        var data: UserData
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if MineViewController.uid != "-1" {
            let sb = UIStoryboard(name: "MainIn", bundle: nil)
            let destination = sb.instantiateViewController(withIdentifier: "Mainboard")
            destination.modalPresentationStyle = UIModalPresentationStyle.fullScreen
            self.present(destination, animated: true, completion: nil)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedObectContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
        do {
            let fetchedResults = try managedObectContext.fetch(fetchRequest) as? [User]
            if let results = fetchedResults {
                for result in results {
                    MineViewController.uid = result.uid!
                    MineViewController.username = result.username!
                    MineViewController.headImageStr = result.headImageStr!
                    MineViewController.sex = result.sex!
                    break
                }
            }
        } catch  {}
        loginBtn.addTarget(self, action: #selector(loginEvent), for: .touchDown)
        regBtn.addTarget(self, action: #selector(regEvent), for: .touchDown)
        usernameText.placeholder = "用户名"
        pwdText.placeholder = "密码"
        pwdText.isSecureTextEntry = true
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 5
        //config.protocolClasses = [MyURLProtocol.self]
        urlSession = URLSession(configuration: config, delegate: self, delegateQueue: nil)
    }
    
    @objc func loginEvent(){
        //登陆按钮点击后
        let url = URL(string: LoginController.baseurl+"/user/login")
        var request = URLRequest(url: url!, cachePolicy: .reloadIgnoringCacheData)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        //request.allHTTPHeaderFields=["Content-Type":"application/json"]
        let paramStr = "{\"userName\":\"\(usernameText.text ?? "")\",\"password\":\"\(pwdText.text ?? "")\"}"
        //将参数字符串转换为二进制Data数据
        let paramData = paramStr.data(using: .utf8)
        request.httpBody = paramData
        
        var dataTask: URLSessionDataTask?
        dataTask = urlSession.dataTask(with: request, completionHandler: { (data, response, error) in
            if let data = data,
                let response = response as? HTTPURLResponse, response.statusCode == 200 {
                do {
                    print(String(data: data, encoding: .utf8) ?? "")
                    let tmpModel = try JSONDecoder().decode(UserResponseData.self, from: data)
                    if tmpModel.code == 200 {
                        MineViewController.username = tmpModel.data!.name!
                        MineViewController.sex = tmpModel.data!.sex!
                        MineViewController.headImageStr = tmpModel.data!.icon!
                        MineViewController.uid = String(tmpModel.data!.uid!)
                        DispatchQueue.main.async {
                            let sb = UIStoryboard(name: "MainIn", bundle: nil)
                            let destination = sb.instantiateViewController(withIdentifier: "Mainboard")
                            destination.modalPresentationStyle = UIModalPresentationStyle.fullScreen
                            self.present(destination, animated: true, completion: nil)
                        }
                        self.saveUserInfo()
                    } else {
                        DispatchQueue.main.async {
                            let alertController = UIAlertController(title: "提示", message: "用户名或密码错误",preferredStyle: .alert)
                            let cancelAction1 = UIAlertAction(title: "确定", style: .default, handler: nil)
                            alertController.addAction(cancelAction1)
                            self.present(alertController, animated: true, completion: nil)
                        }
                    }
                } catch {
                    DispatchQueue.main.async {
                        let alertController = UIAlertController(title: "提示", message: "用户名或密码错误",preferredStyle: .alert)
                        let cancelAction1 = UIAlertAction(title: "确定", style: .default, handler: nil)
                        alertController.addAction(cancelAction1)
                        self.present(alertController, animated: true, completion: nil)
                    }
                }
            }
        })
        dataTask?.resume()
        
    }
    
    @objc func saveUserInfo(){
        DispatchQueue.main.async {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let managedObjectContext = appDelegate.persistentContainer.viewContext
            let entity = NSEntityDescription.entity(forEntityName: "User", in: managedObjectContext)
            let oneinfo = NSManagedObject(entity: entity!, insertInto: managedObjectContext)
            oneinfo.setValue(MineViewController.uid, forKey: "uid")
            oneinfo.setValue(MineViewController.username, forKey: "username")
            oneinfo.setValue(MineViewController.headImageStr, forKey: "headImageStr")
            oneinfo.setValue(MineViewController.sex, forKey: "sex")
            do {
                try managedObjectContext.save()
            } catch  {}
        }
    }
    
    @objc func regEvent(){
        //注册按钮点击后
        let url = URL(string: LoginController.baseurl+"/user/reg")
        var request = URLRequest(url: url!, cachePolicy: .reloadIgnoringCacheData)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        //request.allHTTPHeaderFields=["Content-Type":"application/json"]
        let paramStr = "{\"userName\":\"\(usernameText.text ?? "")\",\"pwd\":\"\(pwdText.text ?? "")\"}"
        //将参数字符串转换为二进制Data数据
        let paramData = paramStr.data(using: .utf8)
        request.httpBody = paramData
        
        var dataTask: URLSessionDataTask?
        dataTask = urlSession.dataTask(with: request, completionHandler: { (data, response, error) in
            if let data = data,
                let response = response as? HTTPURLResponse, response.statusCode == 200 {
                do {
                    print(String(data: data, encoding: .utf8) ?? "")
                    let tmpModel = try JSONDecoder().decode(UserResponseData.self, from: data)
                    if tmpModel.code == 200 {
                        MineViewController.username = tmpModel.data!.name!
                        MineViewController.sex = tmpModel.data!.sex!
                        MineViewController.headImageStr = tmpModel.data!.icon!
                        MineViewController.uid = String(tmpModel.data!.uid!)
                        DispatchQueue.main.async {
                            let sb = UIStoryboard(name: "MainIn", bundle: nil)
                            let destination = sb.instantiateViewController(withIdentifier: "Mainboard")
                            destination.modalPresentationStyle = UIModalPresentationStyle.fullScreen
                            self.present(destination, animated: true, completion: nil)
                        }
                        self.saveUserInfo()
                    } else {
                        DispatchQueue.main.async {
                            let alertController = UIAlertController(title: "提示", message: "用户名已经存在啦",preferredStyle: .alert)
                            let cancelAction1 = UIAlertAction(title: "确定", style: .default, handler: nil)
                            alertController.addAction(cancelAction1)
                            self.present(alertController, animated: true, completion: nil)
                        }
                    }
                } catch {
                    print("Error: \(error)")
                    DispatchQueue.main.async {
                        let alertController = UIAlertController(title: "提示", message: "用户名已经存在啦",preferredStyle: .alert)
                        let cancelAction1 = UIAlertAction(title: "确定", style: .default, handler: nil)
                        alertController.addAction(cancelAction1)
                        self.present(alertController, animated: true, completion: nil)
                    }
                }
            }
        })
        dataTask?.resume()
    }
    
}
