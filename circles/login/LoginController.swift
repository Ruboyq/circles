import UIKit

class LoginController: UIViewController {
    
    
    @IBOutlet weak var usernameText: UITextField!
    
    @IBOutlet weak var pwdText: UITextField!
    
    @IBOutlet weak var loginBtn: UIButton!
    
    @IBOutlet weak var regBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loginBtn.addTarget(self, action: #selector(loginEvent), for: .touchDown)
        regBtn.addTarget(self, action: #selector(regEvent), for: .touchDown)
        usernameText.placeholder = "用户名"
        pwdText.placeholder = "密码"
    }
    
    @objc func loginEvent(){
        //登陆按钮点击后
        let sb = UIStoryboard(name: "MainIn", bundle: nil)
        let destination = sb.instantiateViewController(withIdentifier: "Mainboard")
        destination.modalPresentationStyle = UIModalPresentationStyle.fullScreen
        self.present(destination, animated: true, completion: nil)
    }
    
    @objc func regEvent(){
        //注册按钮点击后
        let sb = UIStoryboard(name: "MainIn", bundle: nil)
        let destination = sb.instantiateViewController(withIdentifier: "Mainboard")
        destination.modalPresentationStyle = UIModalPresentationStyle.fullScreen
        self.present(destination, animated: true, completion: nil)
    }
    
}
