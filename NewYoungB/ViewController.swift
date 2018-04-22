//
//  ViewController.swift
//  YoungB
//
//  Created by 이창현 on 2017. 12. 16..
//  Copyright © 2017년 이창현. All rights reserved.
//

import UIKit
/*import FacebookLogin
import FacebookCore
import FacebookShare
import Alamofire*/
extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(rgb: Int) {
        self.init(
            red: (rgb >> 16) & 0xFF,
            green: (rgb >> 8) & 0xFF,
            blue: rgb & 0xFF
        )
    }
}
var underText = "배달 요청하기"
class ViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITableViewDelegate, UITableViewDataSource {
    
    
    
    
    var tableView:UITableView = {
        let view = UITableView()
        view.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    let items = ["이가연","김이번","박삼번","곽사번","명오번"]
    let itemsInfo = ["3학년 2반","3학년 2반","3학년 2반","3학년 2반","3학년 2반"]
    let purchaseInfo = ["미리 결제","대신 구매","현금 결제","미리 결제","미리 결제"]
    let prices = [3000,4500,3000,3000,5000]
    
    let arr = ["모든 요청", "미리 결제된 요청", "현금 결제 요청", "대신 구매 요청"]
    
    var underLabel: UILabel!
    
    var txf: UITextField!
    
    let url = "http://soylatte.kr"
    let port = ":6974"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        navigationController?.navigationBar.isHidden = true
    }
    
    func setUI() {
        let viewBack = UILabel(frame: CGRect(x: 0, y: 20, width: view.frame.width, height: view.frame.height * (249 / 667)))
        viewBack.backgroundColor = .white
        view.addSubview(viewBack)
        
        let viewMagam = FirstView(frame: CGRect(x: 18, y: 69 + 44, width: 340, height: 158-11), pfImage: #imageLiteral(resourceName: "Boy.jpg"), name: "이가연", grade: "3학년 2반", menu1: "오버액션토끼 초코 롤빵", menu2: "포카칩 Original", menu3: "생생가득 180ml", plusMenu: 5, payment: "f", susuryo: 6, pay: 3000)
        viewMagam.layer.cornerRadius = view.frame.height * 2 / 667
        viewMagam.layer.borderWidth = 1
        viewMagam.layer.borderColor = UIColor.gray.cgColor
        
        view.addSubview(viewMagam)
        
        
        
        let viewBack_2 = UILabel(frame: CGRect(x: 0, y: 20 + view.frame.height * 249 / 667, width: view.frame.width, height: view.frame.height * (398 / 667)))
        viewBack_2.backgroundColor = UIColor(rgb: 0xF5F5F5)
        view.addSubview(viewBack_2)
        
        let btnSearch = UIButton(frame: CGRect(x: view.frame.width * 341 / 375, y: view.frame.height * 34 / 667, width: view.frame.width * 16 / 375, height: view.frame.height * 16 / 667))
        btnSearch.setImage(#imageLiteral(resourceName: "icCheck.png"), for: .normal)
        view.addSubview(btnSearch)
        
        let bottomTxf = UILabel(frame: CGRect(x: view.frame.width * 153 / 375, y: view.frame.height * 45 / 667, width: view.frame.width * 69 / 375, height: view.frame.height * 6 / 667))
        bottomTxf.backgroundColor = UIColor(rgb: 0xFFCE0A)
        view.addSubview(bottomTxf)
        
        let txfMain = UITextField(frame: CGRect(x: 0, y: view.frame.height * 32 / 667, width: view.frame.width, height: view.frame.height * 21 / 667))
        txfMain.layer.borderWidth = 0
        txfMain.textAlignment = .center
        txfMain.text = arr[0]
        txfMain.font = UIFont(name: "AppleSDGothicNeoB", size: view.frame.height * 18 / 667)
        
        
        let pickerView = UIPickerView()
        pickerView.delegate = self
        txfMain.inputView = pickerView
        txf = txfMain
        txf = txfMain
        view.addSubview(txfMain)
        
        
        let btnMenu = UIButton(frame: CGRect(x: view.frame.width * 18 / 375, y: view.frame.height * 37 / 667, width: view.frame.width * 16 / 375, height: view.frame.height * 10.7 / 667))
        btnMenu.setImage(#imageLiteral(resourceName: "icCheck.png"), for: .normal)
        view.addSubview(btnMenu)
        
        let lblMagam = UILabel(frame: CGRect(x: view.frame.width * 18 / 375, y: view.frame.height * 69 / 667, width: view.frame.width * 0.5, height: view.frame.height * 15 / 667))
        lblMagam.text = "마감 임박~"
        lblMagam.textColor = UIColor(rgb: 0x1E1801)
        lblMagam.alpha = 0.2
        lblMagam.font = UIFont(name: "AppleSDGothic", size: view.frame.height * 12 / 667)
        view.addSubview(lblMagam)
        
        
        tableView = UITableView(frame: CGRect(x: 18, y: 269+38, width: 340, height: 76*4))
        self.view.addSubview(tableView)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
        tableView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        
        let tableLabel = UILabel(frame: CGRect(x: 18, y: 270+22, width: 59, height: 15))
        tableLabel.text = "우리 반 요청"
        tableLabel.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 12)
        
        view.addSubview(tableLabel)
        
        
        underLabel = UILabel(frame: CGRect(x: 0, y: 587+22, width: 375, height: 60))
        underLabel.text = underText
        underLabel.font = UIFont(name: "AppleSDGothicNeo-Medium", size: 24)
        underLabel.textColor = UIColor(red: 30/255, green: 24/255, blue: 10/255, alpha: 0.7)
        underLabel.backgroundColor = UIColor(red: 1, green: 206/255, blue: 10/255, alpha: 1)
        underLabel.textAlignment = .center
        view.addSubview(underLabel)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UnderTableViewCell(style: .default, reuseIdentifier: "cell")
        cell.nameLabel.text = items[indexPath.row]
        cell.userInfoLabel.text = "\(itemsInfo[indexPath.row])"
        cell.priceLabel.text = "\(prices[indexPath.row])원"
        cell.howParchaceLabel.text = "\(purchaseInfo[indexPath.row])"
        cell.fee.text = "\(prices[indexPath.row]/10)원"
        switch indexPath.row {
        case 1:
            cell.howParchaceLabel.textColor = UIColor(red: 1, green: 119/255, blue: 73/255, alpha: 1)
        case 2:
            cell.howParchaceLabel.textColor = UIColor(red: 30/255, green:165/255, blue:208/255, alpha:1)
        default:
            cell.howParchaceLabel.textColor = .black
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var height:CGFloat = CGFloat()
        height = 76
        return height
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return arr.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return arr[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        txf.text = arr[row]
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
}

class FirstView: UIView {
    var pfImage: UIImage!
    var name: String!
    var grade: String!
    var menu1: String!
    var menu2: String!
    var menu3: String!
    var plusMenu: Int!
    var payment: String!
    var susuryo: Int!
    var pay: Int!
    
    init(frame: CGRect, pfImage: UIImage, name: String, grade: String, menu1: String, menu2: String, menu3: String, plusMenu: Int, payment: String, susuryo: Int, pay: Int) {
        super.init(frame: frame)
        self.pfImage = pfImage
        self.name = name
        self.grade = grade
        self.menu1 = menu1
        self.menu2 = menu2
        self.menu3 = menu3
        self.plusMenu = plusMenu
        self.payment = payment
        self.susuryo = susuryo
        self.pay = pay
        setLayOut()
    }
    
    var btnCheck: UIButton!
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setLayOut() {
        let profileImage = UIImageView(frame: CGRect(x: 16, y: 16, width: 36, height: 36))
        profileImage.image = pfImage
        profileImage.layer.cornerRadius = profileImage.frame.width * 0.5
        profileImage.layer.masksToBounds = false
        profileImage.clipsToBounds = true
        profileImage.layer.borderColor = UIColor.white.cgColor
        self.addSubview(profileImage)
        
        let lblName = UILabel(frame: CGRect(x: frame.width * 57 / 330, y: frame.height * 14.7 / 158, width: frame.width * 0.8, height: frame.height * 24 / 158))
        lblName.text = name
        lblName.textColor = UIColor(rgb: 0x1e1801)
        lblName.font = UIFont.systemFont(ofSize: 16)
        addSubview(lblName)
        
        let lblGrade = UILabel(frame: CGRect(x: frame.width * 57 / 330, y: frame.height * 14.7 / 158, width: frame.width * 0.8, height: frame.height * 24 / 158))
        lblGrade.text = name
        lblGrade.textColor = UIColor(rgb: 0x1E1801)
        lblGrade.alpha = 0.2
        lblGrade.font = UIFont.systemFont(ofSize: 16)
        addSubview(lblGrade)
        
        let hr = UILabel(frame: CGRect(x: frame.width * 16 / 330, y: frame.height * 66 / 158, width: frame.width * 308 / 330, height: frame.height * 1 / 158))
        hr.layer.borderWidth = 1
        hr.layer.borderColor = UIColor(rgb: 0x1E1801).cgColor
        hr.alpha = 0.2
        addSubview(hr)
        
        let lblPrchse = UILabel(frame: CGRect(x: 250, y: 97-8, width: 50, height: 12))
        lblPrchse.text = "미리 결제"
        lblPrchse.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 12)
        lblPrchse.textColor = UIColor(red: 144/255, green: 144/255, blue: 144/255, alpha: 1)
        addSubview(lblPrchse)
        
        let lblFee = UILabel(frame: CGRect(x: 300, y: 97-8, width: 30, height: 12))
        lblFee.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 10)
        lblFee.text = "300원"
        lblFee.textColor = UIColor(red: 1, green: 206/255, blue: 10/255, alpha: 1)
        addSubview(lblFee)
        
        let lblInfo = UILabel(frame: CGRect(x: 59, y: 40, width: 40, height: 12))
        lblInfo.text = grade
        lblInfo.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 10)
        lblInfo.textColor = UIColor(red: 30/255, green: 24/255, blue: 1/255, alpha: 1)
        addSubview(lblInfo)
        
        btnCheck = UIButton(frame: CGRect(x: 304, y: 24, width: 20, height: 20))
        btnCheck.setBackgroundImage(#imageLiteral(resourceName: "icCheck.png"), for: UIControlState.normal)
        btnCheck.addTarget(self, action: #selector(touchEvent(_:)), for: .touchUpInside)
        addSubview(btnCheck)
        
        let lblPrice = UILabel(frame: CGRect(x: 234, y: 113-11, width: 93, height: 36))
        lblPrice.font = UIFont(name: "AppleSDGothicNeo-SemiBold", size: 28)
        lblPrice.text = "3000원"
        addSubview(lblPrice)
        
        
        let lblInfo1 = UILabel(frame: CGRect(x: 16, y: 78-33, width: 130, height: 96))
        lblInfo1.textAlignment = .left
        lblInfo1.font = UIFont(name: "AppleSDGothicNeo-SemiBold", size: 10)
        lblInfo1.textColor = UIColor(red: 30/255, green: 24/255, blue: 1/255, alpha: 0.5)
        lblInfo1.text = "오버액션토끼 초코 롤빵 x 1\n포카칩 Original x 1\n생생가득 180ml x 1 "
        lblInfo1.lineBreakMode = .byWordWrapping
        lblInfo1.numberOfLines = 0
        
        addSubview(lblInfo1)
        
        
        
        
        
    }
    
    @objc func touchEvent(_ button : UIButton) {
        if (btnCheck.currentBackgroundImage == #imageLiteral(resourceName: "icCheck.png")) {
            btnCheck.setBackgroundImage(#imageLiteral(resourceName: "icCheckActive.png"), for: UIControlState.normal)
            underText = "배달 수락하기"
        }
        else {
            btnCheck.setBackgroundImage(#imageLiteral(resourceName: "icCheck.png"), for: UIControlState.normal)
            underText = "배달 요청하기"
        }
    }

}


class UnderTableViewCell: UITableViewCell {
    
    var nameLabel: UILabel!
    var userInfoLabel: UILabel!
    var userProfilePhoto: UIImageView!
    var priceLabel: UILabel!
    var howParchaceLabel: UILabel!
    var fee: UILabel!
    
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:)")
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        
        
        nameLabel = UILabel(frame:CGRect(x:57,y:23.7,width:45,height:19))
        nameLabel.textAlignment = .left
        nameLabel.font = UIFont(name: "AppleSDGothicNeo-SemiBold", size: 16)
        nameLabel.textColor = .black
        contentView.addSubview(nameLabel)
        
        userInfoLabel = UILabel(frame:CGRect(x:59,y:43.5,width:41,height:12))
        userInfoLabel.textAlignment = .left
        userInfoLabel.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 10)
        userInfoLabel.textColor = UIColor(rgb: 0x1e1801)
        contentView.addSubview(userInfoLabel)
        
        
        userProfilePhoto = UIImageView(frame: CGRect(x: 16, y: 20, width: 36, height: 36))
        userProfilePhoto.image = #imageLiteral(resourceName: "Boy.jpg")
        userProfilePhoto.layer.borderWidth = 0.5
        userProfilePhoto.layer.masksToBounds = false
        userProfilePhoto.layer.borderColor = UIColor.black.cgColor
        userProfilePhoto.layer.cornerRadius = userProfilePhoto.frame.height/2
        userProfilePhoto.clipsToBounds = true
        contentView.addSubview(userProfilePhoto)
        
        priceLabel = UILabel(frame: CGRect(x: 247, y: 33, width: 80, height: 29))
        priceLabel.textAlignment = .left
        priceLabel.font = UIFont(name:"AppleSDGothicNeo-SemiBold", size:24)
        priceLabel.textColor = .black
        contentView.addSubview(priceLabel)
        
        howParchaceLabel = UILabel(frame: CGRect(x: 267, y: 22, width: 30, height: 9))
        howParchaceLabel.textAlignment = .left
        howParchaceLabel.font = UIFont(name:"AppleSDGothicNeo-Regular", size:8)
        howParchaceLabel.textColor = .black
        contentView.addSubview(howParchaceLabel)
        
        fee = UILabel(frame: CGRect(x: 302, y: 22, width: 30, height: 9))
        fee.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 8)
        fee.textColor = UIColor(red: 255/255, green: 206/255, blue: 10/255, alpha: 1)
        contentView.addSubview(fee)
    }
    
    
    
}
