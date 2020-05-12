import UIKit

class TrendsPublishController: UIViewController, UIImagePickerControllerDelegate, UIGestureRecognizerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var contextTextView: UITextView!
    
    @IBOutlet weak var pic0: UIImageView!
    
    @IBOutlet weak var pic1: UIImageView!
    
    @IBOutlet weak var pic2: UIImageView!
    
    @IBOutlet weak var pic3: UIImageView!
    
    @IBOutlet weak var pic4: UIImageView!
    
    @IBOutlet weak var pic5: UIImageView!
    
    @IBOutlet weak var pic6: UIImageView!
    
    @IBOutlet weak var pic7: UIImageView!
    
    @IBOutlet weak var pic8: UIImageView!
    
    @IBOutlet weak var selectBtn: UIButton!
    
    @IBOutlet weak var selectLabel: UILabel!
    
    static public var selectCircle: String = ""
    
    var imgArray = [UIImageView]()
    var imgBase64Array = [String]()
    
    var imgCount:Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad();
        contextTextView.layer.borderWidth = 1;
        contextTextView.layer.borderColor = UIColor.lightGray.cgColor;
        imgArray.append(pic0)
        imgArray.append(pic1)
        imgArray.append(pic2)
        imgArray.append(pic3)
        imgArray.append(pic4)
        imgArray.append(pic5)
        imgArray.append(pic6)
        imgArray.append(pic7)
        imgArray.append(pic8)
        for i in 0...8 {
            let tap = UITapGestureRecognizer(target: self, action: #selector(tapGesture))
            tap.delegate = self
            tap.numberOfTapsRequired = 1
            tap.numberOfTouchesRequired = 1
            tap.name = String(i)
            imgArray[i].addGestureRecognizer(tap)
            imgBase64Array.append("")
        }
        imgArray[imgCount].image = UIImage(named:"plus")
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "发布", style: .plain, target: self, action: #selector(realPublish))
        selectBtn.addTarget(self, action: #selector(selectCircle), for: UIControl.Event.touchUpInside)
    }
    
    @objc func tapGesture(tap:UITapGestureRecognizer) {
        //添加图片
        if Int(tap.name!)! == imgCount {
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
        //无效点击
        if imgBase64Array[Int(tap.name!)!] == "" {
            return
        }
        //删除图片
        imgArray[Int(tap.name!)!].image = UIImage(named:"blank")
        imgBase64Array[Int(tap.name!)!] = ""
        imgCount-=1
        if Int(tap.name!)!<=7 {
            for i in Int(tap.name!)!...7 {
                imgArray[i].image = imgArray[i+1].image
                imgBase64Array[i] = imgBase64Array[i+1]
            }
        }
        imgArray[imgCount].image = UIImage(named:"plus")
        for i in (imgCount+1)...8 {
            imgArray[i].image = UIImage(named:"blank")
            imgBase64Array[i] = ""
        }
    }
    
    //选择图片成功后代理
    func imagePickerController(_ picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        //查看info对象
        //print(info)
        //显示的图片
        let image:UIImage!
        image = info[.editedImage] as? UIImage
        imgArray[imgCount].image = image
        imgBase64Array[imgCount] = image!.pngData()!.base64EncodedString()
        //图片控制器退出
        picker.dismiss(animated: true, completion: {
            () -> Void in
        })
        imgCount += 1
        if imgCount < 9 {
            imgArray[imgCount].image = UIImage(named:"plus")
        }
    }
    
    @objc func realPublish(){
        print("123123")
    }
    
    @objc func selectCircle(){
        let sb = UIStoryboard(name: "AllCircles", bundle: nil)
        let destination = sb.instantiateViewController(withIdentifier: "AllCircles") as! AllCirclesController
        AllCirclesController.parentController = self
        self.present(destination, animated: true, completion: nil)
    }
    
    func changeCirle(){
        selectLabel.text = TrendsPublishController.selectCircle
    }

}
