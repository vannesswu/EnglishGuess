//
//  UserAgreement.swift
//  EnglishGuess
//
//  Created by 吳建豪 on 2017/3/12.
//  Copyright © 2017年 吳建豪. All rights reserved.
//

import Foundation
import UIKit

class UserAgreement:UIViewController ,UITextViewDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
    }
    
    override func viewWillLayoutSubviews() {
        setupViews()
    }
    
    let titleLabel:UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 40)
        label.backgroundColor = UIColor.white
        label.text = "用戶協議"
        return label
    }()
    lazy var textView:UITextView = {
        let tv = UITextView()
        tv.font = UIFont.systemFont(ofSize: 15)
        tv.isScrollEnabled = true
        tv.delegate = self
        tv.isEditable = false
        tv.contentSize = CGSize(width: self.view.frame.width, height: 2000)
        return tv
    }()
    lazy var confirmButton:UIButton = {
        let btn = UIButton()
        btn.setTitle("我知道了", for: .normal)
        btn.backgroundColor = UIColor.lightGray
        btn.setTitleColor(UIColor.black, for: .normal)
        btn.addTarget(self, action: #selector(dismissVC), for: .touchUpInside)
        return btn
    }()
    func dismissVC() {
        dismiss(animated: true, completion: nil)
    }

    func setupViews(){
        view.addSubview(titleLabel)
        view.addSubview(textView)
        view.addSubview(confirmButton)
        titleLabel.anchor(view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 5, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 60)
   
        textView.frame = CGRect(x: 0, y: 60, width: view.frame.width, height: view.frame.height-110)
        confirmButton.anchor(nil, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 50)
        
        textView.contentSize = CGSize(width: self.view.frame.width, height: 2000)
        textView.text = "在您完成你說我猜用戶註冊之前，務必請您仔細閱讀完本協議後再進行註冊。 本協議在您接受註冊時生效,將成為您和你說我猜之間具有法律意義的文件，您和你說我猜將同時受到本協議條款的約束。\n\n1.個人資料之蒐集與目的:\n在您加入你說我猜會員或下載、使用你說我猜相關服務時，軟體系統將依您所要求的服務內容，擷取提供該等服務所必須蒐集之可供辨識個人之資料，詳細擷取資料在您下載你說我猜時已取得您的同意。倘若您不同意提供上述個人資料，請勿繼續使用你說我猜服務。\n\n2.個人資訊的揭露\n除了下述情況，或依據相關法律或政府機構之命令外，在未獲得您的同意之前，你說我猜不會向任何第三人販賣、出租、交易或轉讓您所提供的個人資料、流量資料或通訊內容；\n2-1.任何您自願在個人資料中公開，在你說我猜中透露、張貼的資訊或評論，將有可能被他人轉貼或使用。\n2-2.你說我猜依法律規定或為主張權利或對任何指控提出抗辯、為保護你說我猜的利益、打擊詐欺、執行我們的政策、保護第三人的合法權利、財產或為安全需要而揭露您的個人資料。\n2-3.在取得您同意之下，你說我猜App得使用您在你說我猜帳號中所有活動之詳細資訊，包括但不限於流量資訊、任何通訊及交易之詳細資料。您得隨時撤回同意。\n2-4.若日後你說我猜轉換經營者，被第三人收購或合併，你說我猜將依法移交您的個人資料，倘若因此適用不同隱私權政策者， 你說我猜將事先通知您。\n\n3.用戶賬號密碼的保管\n用戶的賬號密碼由用戶自行妥善保管，無論基於何種目的，均禁止用戶將其賬號密碼轉讓或出借於任何第三方使用。 如用戶發現其賬號被他人非法使用，應當立即通知你說我猜，因黑客行為、用戶保管的疏忽導致用戶賬號密碼被他人非法使用或用戶將其賬號密碼轉讓或出借於任何第三方使用而導致的任何損失及一切法律後果均由用戶承擔。\n\n4.用戶的義務\n用戶應當遵守有關法律法規，按照相關協議使用規則享受你說我猜提供的服務。 不得從事以下行為，若發生下列行為，則用戶應承擔相應的法律責任。 你說我猜有權限製或取消其用戶權限：\n4-1.申請或者變更用戶信息時提供虛假信息；\n4-2.盜用他人信息；\n4-3.利用任何方式方法危害你說我猜系統的安全；\n4-4.為任何非法目的使用你說我猜；\n4-5.在你說我猜上複製、發布任何形式的虛假信息，或複制、發布含有下列內容的信息：\na 危害國家安全，洩露國家秘密，顛覆國家政權，破壞國家統一；\nb 損害國家榮譽和利益；\nc 煽動民族仇恨、民族歧視，破壞民族團結；\nd 破壞國家宗教政策，宣揚邪教和封建迷信\ne 散佈謠言，擾亂社會秩序，破壞社會穩定；\nf 散佈淫穢、色情、賭博、暴力、兇殺、恐怖或者教唆犯罪\ng 含有法律、行政法規禁止的其他內容。\n\n5.服務變更、中斷或終止\n5-1.鑑於網絡服務的特殊性，你說我猜可隨時變更、中斷或終止部分或全部的網絡服務，你說我猜均無需為此對用戶承擔責任。\n5-2.如發生下列任何一種情形，你說我猜有權在通知用戶後中斷或終止用戶提供全部或部分網絡服務而無需對用戶及任何第三方承擔任何責任：\n(1) 用戶提供的個人資料不真實、不准確或存在重大遺漏；\n(2) 用戶違反本協議中規定的使用規則；\n5-3.如用戶帳號(一般會員)在任何連續90日內未實際使用，則你說我猜有權刪除該帳號並停止為該用戶提供相關的網絡服務。\n\n6.協議修改\n6-1.你說我猜有權隨時修改本協議的任何條款，一旦本協議的內容髮生變動，你說我猜會將修改之後的協議內容向用戶公佈。\n6-2.如果不同意你說我猜對本協議任何條款所作的修改，用戶有權停止使用網絡服務。 如果用戶繼續使用網絡服務，則視為用戶接受你說我猜對本協議任何條款所作的修改。"
        
        
    }
    
    
}
