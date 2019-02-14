//
//  HomeVC.swift
//  FakeTime
//
//  Created by Luy Nguyen on 1/23/19.
//  Copyright © 2019 Luy Nguyen. All rights reserved.
//

import UIKit
import AVKit

class HomeVC: BaseVC {
    @IBOutlet weak var navi: NavigationView!
    @IBOutlet weak var imgAvatar: KHImageView!
    @IBOutlet weak var lbName: KHLabel!
    @IBOutlet weak var tfDelayTime: KHTextField!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var ctrHeightTableView: NSLayoutConstraint!
    @IBOutlet weak var viewDelay: UIView!
    @IBOutlet weak var lbTimeCountDown: KHLabel!
    
    var timer: Timer = Timer()
    var caller: CallerObj = CallerObj()
    var isCallVideo: Bool = false
    var arrItem: [HomeObj] = {
        let items: [HomeObj] = [HomeObj(#imageLiteral(resourceName: "home_call"), title: "Call", typeCall: .call, isSelected: true),
                                HomeObj(#imageLiteral(resourceName: "home_message"), title: "Messenger", typeCall: .messenger),
                                HomeObj(#imageLiteral(resourceName: "home_line"), title: "Line", typeCall: .line),
                                HomeObj(#imageLiteral(resourceName: "home_wechat"), title: "Wechat", typeCall: .weChat)]
        return items
    }()
    var timeCountDown: Int = 0 {
        didSet {
            let (h, m,s) = timeCountDown.secondsToHoursMinutesSeconds()
            lbTimeCountDown.text = "Call " + "(\(h):\(m):\(s))"
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        caller = CallerObj(name: KeyString.girlFriend, phoneNumber: "123456789", avatar: #imageLiteral(resourceName: "girlfriend"), pathVideo: KeyString.girlFriendVideo)
        initUI()
        initData()
    }
    
    @IBAction func callPhone(_ sender: Any) {
        isCallVideo = false
        delayTime()
    }
    
    @IBAction func callVideo(_ sender: Any) {
        isCallVideo = true
        delayTime()
    }
    
    @IBAction func actionCancelDelay(_ sender: Any) {
        viewDelay.isHidden = true
        timer.invalidate()
    }
    
    @IBAction func actionTimeCountDown(_ sender: Any) {
        viewDelay.isHidden = true
        timer.invalidate()
        if isCallVideo {
            showCallVideoVC()
        } else {
            showCallVC()
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}

extension HomeVC {
    func initUI() {
        navi.handleMenu = {
            self.clickMenu()
        }
        navi.handleActionRight = {
            let vc = ListCallVC.init(nibName: "ListCallVC", bundle: nil)
            self.navigationController?.pushViewController(vc, animated: true)
            vc.handleSelect = { (callerObj) in
                callerObj.typeCall = self.caller.typeCall
                self.caller = callerObj
                self.initData()
            }
        }
        tableView.register(CellHome.self)
    }
    
    func initData() {
        imgAvatar.image = caller.avatar
        lbName.text = caller.name
    }
    
    func delayTime() {
        if let timeCountDown = Int(tfDelayTime.text!) {
            if timeCountDown > 0 {
                viewDelay.isHidden = false
                self.timeCountDown = timeCountDown
                timer = Timer.every(1, {
                    if self.timeCountDown == 0 {
                        self.viewDelay.isHidden = true
                        self.timer.invalidate()
                        
                        if self.isCallVideo {
                            self.showCallVideoVC()
                        } else {
                            self.showCallVC()
                        }
                        return
                    }
                    self.timeCountDown -= 1
                    print(self.timeCountDown)
                })
            } else {
                if isCallVideo {
                    showCallVideoVC()
                } else {
                    showCallVC()
                }
            }
        } else {
            Common.showAlert("Please enter the correct timeout")
        }
    }
    
    func showCallVC() {
        switch caller.typeCall {
        case .call:
            let vc = Call_ScreenWaitVC.init(nibName: "Call_ScreenWaitVC", bundle: nil)
            vc.caller = self.caller
            self.present(vc, animated: true, completion: nil)
            break
        case .messenger:
            let vc = Messenger_ScreenWaitVC.init(nibName: "Messenger_ScreenWaitVC", bundle: nil)
            vc.caller = self.caller
            self.present(vc, animated: true, completion: nil)
            break
        case .line:
            let vc = Line_ScreenWaitVC.init(nibName: "Line_ScreenWaitVC", bundle: nil)
            vc.caller = self.caller
            self.present(vc, animated: true, completion: nil)
            break
        case .weChat:
            let vc = Wechat_ScreenWaitVC.init(nibName: "Wechat_ScreenWaitVC", bundle: nil)
            vc.caller = self.caller
            self.present(vc, animated: true, completion: nil)
            break
        }
    }
    
    func showCallVideoVC() {
        switch caller.typeCall {
        case .call:
            let vc = CallVideo_ScreenWaitVC.init(nibName: "CallVideo_ScreenWaitVC", bundle: nil)
            vc.caller = self.caller
            self.present(vc, animated: true, completion: nil)
            break
        case .messenger:
             let vc = MessengerVideo_ScreenWaitVC.init(nibName: "MessengerVideo_ScreenWaitVC", bundle: nil)
            vc.caller = self.caller
             self.present(vc, animated: true, completion: nil)
            break
        case .line:
            let vc = LineVideo_ScreenWaitVC.init(nibName: "LineVideo_ScreenWaitVC", bundle: nil)
            vc.caller = self.caller
            self.present(vc, animated: true, completion: nil)
            break
        case .weChat:
            let vc = WechatVideo_ScreenWaitVC.init(nibName: "WechatVideo_ScreenWaitVC", bundle: nil)
            vc.caller = self.caller
            self.present(vc, animated: true, completion: nil)
            break
        }
    }
}

extension HomeVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrItem.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as CellHome
        cell.config(arrItem[indexPath.item])
        UIView.animate(withDuration: 0, animations: {
            self.tableView.layoutIfNeeded()
        }) { (completed) in
            self.ctrHeightTableView.constant = self.tableView.contentSize.height
        }
        return cell
    }
}

extension HomeVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60*heightRatio
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        arrItem[indexPath.item].isSelected = true
        for i in arrItem.indices {
            if i != indexPath.item {
                arrItem[i].isSelected = false
            }
        }
        caller.typeCall = arrItem[indexPath.item].typeCall
        tableView.reloadData()
    }
}
